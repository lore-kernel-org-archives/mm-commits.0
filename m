Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A09DC04FDF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 16:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbjHGQic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 12:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjHGQi2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 12:38:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC2110D8
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 09:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FA5C61F6A
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 16:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B8FC433C9;
        Mon,  7 Aug 2023 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691426265;
        bh=60Va41KZjKkwyUqA0sbEUh/4GMoxfuiyJO3lR6g6S/k=;
        h=Date:To:From:Subject:From;
        b=09MCE7wlC+3Lc8aBugFkGxGBSMZ8PJv34aEKVKkJPHMfd56XhlM/702TN8ust7R0H
         6EXvUKJ6SrxJYs+dtBi0zZVm8LFKE6SOsMYYRgNZl/txDi8i+OTyFhpfYi73+zFKzq
         mrg01AKyULmiDdhBqftnhBZOntPKyLLFO74BxpQo=
Date:   Mon, 07 Aug 2023 09:37:44 -0700
To:     mm-commits@vger.kernel.org, zohar@linux.ibm.com,
        vschneid@redhat.com, vgoyal@redhat.com, vbabka@suse.cz,
        tiwai@suse.de, tglx@linutronix.de, sourabhjain@linux.ibm.com,
        seanjc@google.com, rafael@kernel.org, osalvador@suse.de,
        naveen.n.rao@linux.vnet.ibm.com, mingo@redhat.com,
        linux@weissschuh.net, lf32.dev@gmail.com, konrad.wilk@oracle.com,
        hpa@zytor.com, hbathini@linux.ibm.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, dyoung@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, corbet@lwn.net, bp@alien8.de,
        boris.ostrovsky@oracle.com, bhe@redhat.com, bhelgaas@google.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-hotplug-support-for-kexec_load.patch added to mm-nonmm-unstable branch
Message-Id: <20230807163745.79B8FC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash: hotplug support for kexec_load()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-hotplug-support-for-kexec_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-hotplug-support-for-kexec_load.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: crash: hotplug support for kexec_load()
Date: Fri, 4 Aug 2023 17:03:57 -0400

The hotplug support for kexec_load() requires changes to the
userspace kexec-tools and a little extra help from the kernel.

Given a kdump capture kernel loaded via kexec_load(), and a
subsequent hotplug event, the crash hotplug handler finds the
elfcorehdr and rewrites it to reflect the hotplug change.
That is the desired outcome, however, at kernel panic time,
the purgatory integrity check fails (because the elfcorehdr
changed), and the capture kernel does not boot and no vmcore
is generated.

Therefore, the userspace kexec-tools/kexec must indicate to the
kernel that the elfcorehdr can be modified (because the kexec
excluded the elfcorehdr from the digest, and sized the elfcorehdr
memory buffer appropriately).

To facilitate hotplug support with kexec_load():
 - a new kexec flag KEXEC_UPATE_ELFCOREHDR indicates that it is
   safe for the kernel to modify the kexec_load()'d elfcorehdr
 - the /sys/kernel/crash_elfcorehdr_size node communicates the
   preferred size of the elfcorehdr memory buffer
 - The sysfs crash_hotplug nodes (ie.
   /sys/devices/system/[cpu|memory]/crash_hotplug) dynamically
   take into account kexec_file_load() vs kexec_load() and
   KEXEC_UPDATE_ELFCOREHDR.
   This is critical so that the udev rule processing of crash_hotplug
   is all that is needed to determine if the userspace unload-then-load
   of the kdump image is to be skipped, or not. The proposed udev
   rule change looks like:
   # The kernel updates the crash elfcorehdr for CPU and memory changes
   SUBSYSTEM=="cpu", ATTRS{crash_hotplug}=="1", GOTO="kdump_reload_end"
   SUBSYSTEM=="memory", ATTRS{crash_hotplug}=="1", GOTO="kdump_reload_end"

The table below indicates the behavior of kexec_load()'d kdump image
updates (with the new udev crash_hotplug rule in place):

 Kernel |Kexec
 -------+-----+----
 Old    |Old  |New
        |  a  | a
 -------+-----+----
 New    |  a  | b
 -------+-----+----

where kexec 'old' and 'new' delineate kexec-tools has the needed
modifications for the crash hotplug feature, and kernel 'old' and
'new' delineate the kernel supports this crash hotplug feature.

Behavior 'a' indicates the unload-then-reload of the entire kdump
image. For the kexec 'old' column, the unload-then-reload occurs
due to the missing flag KEXEC_UPDATE_ELFCOREHDR. An 'old' kernel
(with 'new' kexec) does not present the crash_hotplug sysfs node,
which leads to the unload-then-reload of the kdump image.

Behavior 'b' indicates the desired optimized behavior of the kernel
directly modifying the elfcorehdr and avoiding the unload-then-reload
of the kdump image.

If the udev rule is not updated with crash_hotplug node check, then
no matter any combination of kernel or kexec is new or old, the
kdump image continues to be unload-then-reload on hotplug changes.

To fully support crash hotplug feature, there needs to be a rollout
of kernel, kexec-tools and udev rule changes. However, the order of
the rollout of these pieces does not matter; kexec_load()'d kdump
images still function for hotplug as-is.

Link: https://lkml.kernel.org/r/20230804210359.8321-7-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Suggested-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Akhil Raj <lf32.dev@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kexec.h |   11 +++++++----
 arch/x86/kernel/crash.c      |   27 +++++++++++++++++++++++++++
 include/linux/kexec.h        |   14 ++++++++++++--
 include/uapi/linux/kexec.h   |    1 +
 kernel/Kconfig.kexec         |    4 ++++
 kernel/crash_core.c          |   31 +++++++++++++++++++++++++++++++
 kernel/kexec.c               |    5 +++++
 kernel/ksysfs.c              |   15 +++++++++++++++
 8 files changed, 102 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/kexec.h~crash-hotplug-support-for-kexec_load
+++ a/arch/x86/include/asm/kexec.h
@@ -214,14 +214,17 @@ void arch_crash_handle_hotplug_event(str
 #define arch_crash_handle_hotplug_event arch_crash_handle_hotplug_event
 
 #ifdef CONFIG_HOTPLUG_CPU
-static inline int crash_hotplug_cpu_support(void) { return 1; }
-#define crash_hotplug_cpu_support crash_hotplug_cpu_support
+int arch_crash_hotplug_cpu_support(void);
+#define crash_hotplug_cpu_support arch_crash_hotplug_cpu_support
 #endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-static inline int crash_hotplug_memory_support(void) { return 1; }
-#define crash_hotplug_memory_support crash_hotplug_memory_support
+int arch_crash_hotplug_memory_support(void);
+#define crash_hotplug_memory_support arch_crash_hotplug_memory_support
 #endif
+
+unsigned int arch_crash_get_elfcorehdr_size(void);
+#define crash_get_elfcorehdr_size arch_crash_get_elfcorehdr_size
 #endif
 
 #endif /* __ASSEMBLY__ */
--- a/arch/x86/kernel/crash.c~crash-hotplug-support-for-kexec_load
+++ a/arch/x86/kernel/crash.c
@@ -427,6 +427,33 @@ int crash_load_segments(struct kimage *i
 #undef pr_fmt
 #define pr_fmt(fmt) "crash hp: " fmt
 
+/* These functions provide the value for the sysfs crash_hotplug nodes */
+#ifdef CONFIG_HOTPLUG_CPU
+int arch_crash_hotplug_cpu_support(void)
+{
+	return crash_check_update_elfcorehdr();
+}
+#endif
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+int arch_crash_hotplug_memory_support(void)
+{
+	return crash_check_update_elfcorehdr();
+}
+#endif
+
+unsigned int arch_crash_get_elfcorehdr_size(void)
+{
+	unsigned int sz;
+
+	/* kernel_map, VMCOREINFO and maximum CPUs */
+	sz = 2 + CONFIG_NR_CPUS_DEFAULT;
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
+		sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
+	sz *= sizeof(Elf64_Phdr);
+	return sz;
+}
+
 /**
  * arch_crash_handle_hotplug_event() - Handle hotplug elfcorehdr changes
  * @image: a pointer to kexec_crash_image
--- a/include/linux/kexec.h~crash-hotplug-support-for-kexec_load
+++ a/include/linux/kexec.h
@@ -335,6 +335,10 @@ struct kimage {
 	unsigned int preserve_context : 1;
 	/* If set, we are using file mode kexec syscall */
 	unsigned int file_mode:1;
+#ifdef CONFIG_CRASH_HOTPLUG
+	/* If set, allow changes to elfcorehdr of kexec_load'd image */
+	unsigned int update_elfcorehdr:1;
+#endif
 
 #ifdef ARCH_HAS_KIMAGE_ARCH
 	struct kimage_arch arch;
@@ -411,9 +415,9 @@ bool kexec_load_permitted(int kexec_imag
 
 /* List of defined/legal kexec flags */
 #ifndef CONFIG_KEXEC_JUMP
-#define KEXEC_FLAGS    KEXEC_ON_CRASH
+#define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_UPDATE_ELFCOREHDR)
 #else
-#define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT)
+#define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT | KEXEC_UPDATE_ELFCOREHDR)
 #endif
 
 /* List of defined/legal kexec file flags */
@@ -501,6 +505,8 @@ static inline void arch_kexec_pre_free_p
 static inline void arch_crash_handle_hotplug_event(struct kimage *image) { }
 #endif
 
+int crash_check_update_elfcorehdr(void);
+
 #ifndef crash_hotplug_cpu_support
 static inline int crash_hotplug_cpu_support(void) { return 0; }
 #endif
@@ -509,6 +515,10 @@ static inline int crash_hotplug_cpu_supp
 static inline int crash_hotplug_memory_support(void) { return 0; }
 #endif
 
+#ifndef crash_get_elfcorehdr_size
+static inline unsigned int crash_get_elfcorehdr_size(void) { return 0; }
+#endif
+
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
 struct task_struct;
--- a/include/uapi/linux/kexec.h~crash-hotplug-support-for-kexec_load
+++ a/include/uapi/linux/kexec.h
@@ -12,6 +12,7 @@
 /* kexec flags for different usage scenarios */
 #define KEXEC_ON_CRASH		0x00000001
 #define KEXEC_PRESERVE_CONTEXT	0x00000002
+#define KEXEC_UPDATE_ELFCOREHDR	0x00000004
 #define KEXEC_ARCH_MASK		0xffff0000
 
 /*
--- a/kernel/crash_core.c~crash-hotplug-support-for-kexec_load
+++ a/kernel/crash_core.c
@@ -704,6 +704,33 @@ subsys_initcall(crash_save_vmcoreinfo_in
 #ifdef CONFIG_CRASH_HOTPLUG
 #undef pr_fmt
 #define pr_fmt(fmt) "crash hp: " fmt
+
+/*
+ * This routine utilized when the crash_hotplug sysfs node is read.
+ * It reflects the kernel's ability/permission to update the crash
+ * elfcorehdr directly.
+ */
+int crash_check_update_elfcorehdr(void)
+{
+	int rc = 0;
+
+	/* Obtain lock while reading crash information */
+	if (!kexec_trylock()) {
+		pr_info("kexec_trylock() failed, elfcorehdr may be inaccurate\n");
+		return 0;
+	}
+	if (kexec_crash_image) {
+		if (kexec_crash_image->file_mode)
+			rc = 1;
+		else
+			rc = kexec_crash_image->update_elfcorehdr;
+	}
+	/* Release lock now that update complete */
+	kexec_unlock();
+
+	return rc;
+}
+
 /*
  * To accurately reflect hot un/plug changes of cpu and memory resources
  * (including onling and offlining of those resources), the elfcorehdr
@@ -734,6 +761,10 @@ static void crash_handle_hotplug_event(u
 
 	image = kexec_crash_image;
 
+	/* Check that updating elfcorehdr is permitted */
+	if (!(image->file_mode || image->update_elfcorehdr))
+		goto out;
+
 	if (hp_action == KEXEC_CRASH_HP_ADD_CPU ||
 		hp_action == KEXEC_CRASH_HP_REMOVE_CPU)
 		pr_debug("hp_action %u, cpu %u\n", hp_action, cpu);
--- a/kernel/Kconfig.kexec~crash-hotplug-support-for-kexec_load
+++ a/kernel/Kconfig.kexec
@@ -143,4 +143,8 @@ config CRASH_MAX_MEMORY_RANGES
 	  memory buffer/segment size under 1MiB. This represents a sane choice
 	  to accommodate both baremetal and virtual machine configurations.
 
+	  For the kexec_load() syscall path, CRASH_MAX_MEMORY_RANGES is part of
+	  the computation behind the value provided through the
+	  /sys/kernel/crash_elfcorehdr_size attribute.
+
 endmenu
--- a/kernel/kexec.c~crash-hotplug-support-for-kexec_load
+++ a/kernel/kexec.c
@@ -129,6 +129,11 @@ static int do_kexec_load(unsigned long e
 	if (flags & KEXEC_PRESERVE_CONTEXT)
 		image->preserve_context = 1;
 
+#ifdef CONFIG_CRASH_HOTPLUG
+	if (flags & KEXEC_UPDATE_ELFCOREHDR)
+		image->update_elfcorehdr = 1;
+#endif
+
 	ret = machine_kexec_prepare(image);
 	if (ret)
 		goto out;
--- a/kernel/ksysfs.c~crash-hotplug-support-for-kexec_load
+++ a/kernel/ksysfs.c
@@ -165,6 +165,18 @@ static ssize_t vmcoreinfo_show(struct ko
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 
+#ifdef CONFIG_CRASH_HOTPLUG
+static ssize_t crash_elfcorehdr_size_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
+{
+	unsigned int sz = crash_get_elfcorehdr_size();
+
+	return sysfs_emit(buf, "%u\n", sz);
+}
+KERNEL_ATTR_RO(crash_elfcorehdr_size);
+
+#endif
+
 #endif /* CONFIG_CRASH_CORE */
 
 /* whether file capabilities are enabled */
@@ -255,6 +267,9 @@ static struct attribute * kernel_attrs[]
 #endif
 #ifdef CONFIG_CRASH_CORE
 	&vmcoreinfo_attr.attr,
+#ifdef CONFIG_CRASH_HOTPLUG
+	&crash_elfcorehdr_size_attr.attr,
+#endif
 #endif
 #ifndef CONFIG_TINY_RCU
 	&rcu_expedited_attr.attr,
_

Patches currently in -mm which might be from eric.devolder@oracle.com are

kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
x86-kexec-refactor-for-kernel-kconfigkexec.patch
arm-kexec-refactor-for-kernel-kconfigkexec.patch
ia64-kexec-refactor-for-kernel-kconfigkexec.patch
arm64-kexec-refactor-for-kernel-kconfigkexec.patch
loongarch-kexec-refactor-for-kernel-kconfigkexec.patch
m68k-kexec-refactor-for-kernel-kconfigkexec.patch
mips-kexec-refactor-for-kernel-kconfigkexec.patch
parisc-kexec-refactor-for-kernel-kconfigkexec.patch
powerpc-kexec-refactor-for-kernel-kconfigkexec.patch
riscv-kexec-refactor-for-kernel-kconfigkexec.patch
s390-kexec-refactor-for-kernel-kconfigkexec.patch
sh-kexec-refactor-for-kernel-kconfigkexec.patch
kexec-rename-arch_has_kexec_purgatory.patch
remove-arch_default_kexec-from-kconfigkexec.patch
crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
crash-add-generic-infrastructure-for-crash-hotplug-support.patch
kexec-exclude-elfcorehdr-from-the-segment-digest.patch
crash-memory-and-cpu-hotplug-sysfs-attributes.patch
x86-crash-add-x86-crash-hotplug-support.patch
crash-hotplug-support-for-kexec_load.patch
crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch
x86-crash-optimize-cpu-changes.patch

