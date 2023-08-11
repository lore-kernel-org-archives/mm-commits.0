Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC9BC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 17:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbjHKRya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 13:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbjHKRya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 13:54:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519BD273E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 10:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC6BC63281
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 17:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396E9C433C8;
        Fri, 11 Aug 2023 17:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691776468;
        bh=qjBrFvMii5mGyR0l83AYUayhVLY57zxIxpuioVr9914=;
        h=Date:To:From:Subject:From;
        b=IBHfdwxrPm11xgBmPJStImbhAQAptpxITzNx474rY1WancVLEri7dfLKIksTA3euc
         ImDJqwDmw/PcqgaxSpyu4mBb5i4ESd1dqVyQ3+zvHuiTk5ASUeyrSRZ0D3tmcQXO+3
         F9alU/hYLSPJfW8C59MYVEOh5YDjdAud5zoC6Hkk=
Date:   Fri, 11 Aug 2023 10:54:27 -0700
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
Subject: + crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch added to mm-nonmm-unstable branch
Message-Id: <20230811175428.396E9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash: change crash_prepare_elf64_headers() to for_each_possible_cpu()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch

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
Subject: crash: change crash_prepare_elf64_headers() to for_each_possible_cpu()
Date: Fri, 11 Aug 2023 13:06:41 -0400

The function crash_prepare_elf64_headers() generates the elfcorehdr which
describes the CPUs and memory in the system for the crash kernel.  In
particular, it writes out ELF PT_NOTEs for memory regions and the CPUs in
the system.

With respect to the CPUs, the current implementation utilizes
for_each_present_cpu() which means that as CPUs are added and removed, the
elfcorehdr must again be updated to reflect the new set of CPUs.

The reasoning behind the move to use for_each_possible_cpu(), is:

- At kernel boot time, all percpu crash_notes are allocated for all
  possible CPUs; that is, crash_notes are not allocated dynamically
  when CPUs are plugged/unplugged. Thus the crash_notes for each
  possible CPU are always available.

- The crash_prepare_elf64_headers() creates an ELF PT_NOTE per CPU.
  Changing to for_each_possible_cpu() is valid as the crash_notes
  pointed to by each CPU PT_NOTE are present and always valid.

Furthermore, examining a common crash processing path of:

 kernel panic -> crash kernel -> makedumpfile -> 'crash' analyzer
           elfcorehdr      /proc/vmcore     vmcore

reveals how the ELF CPU PT_NOTEs are utilized:

- Upon panic, each CPU is sent an IPI and shuts itself down, recording
  its state in its crash_notes.  When all CPUs are shutdown, the crash
  kernel is launched with a pointer to the elfcorehdr.

- The crash kernel via linux/fs/proc/vmcore.c does not examine or use
  the contents of the PT_NOTEs, it exposes them via /proc/vmcore.

- The makedumpfile utility uses /proc/vmcore and reads the CPU PT_NOTEs
  to craft a nr_cpus variable, which is reported in a header but otherwise
  generally unused.  Makedumpfile creates the vmcore.

- The 'crash' dump analyzer does not appear to reference the CPU
  PT_NOTEs.  Instead it looks-up the cpu_[possible|present|onlin]_mask
  symbols and directly examines those structure contents from vmcore
  memory.  From that information it is able to determine which CPUs are
  present and online, and locate the corresponding crash_notes.  Said
  differently, it appears that 'crash' analyzer does not rely on the ELF
  PT_NOTEs for CPUs; rather it obtains the information directly via kernel
  symbols and the memory within the vmcore.

(There maybe other vmcore generating and analysis tools that do use these
PT_NOTEs, but 'makedumpfile' and 'crash' seems to be the most common
solution.)

This results in the benefit of having all CPUs described in the
elfcorehdr, and therefore reducing the need to re-generate the elfcorehdr
on CPU changes, at the small expense of an additional 56 bytes per PT_NOTE
for not-present-but-possible CPUs.

On systems where kexec_file_load() syscall is utilized, all the above is
valid.  On systems where kexec_load() syscall is utilized, there may be
the need for the elfcorehdr to be regenerated once.  The reason being that
some archs only populate the 'present' CPUs from the
/sys/devices/system/cpus entries, which the userspace 'kexec' utility uses
to generate the userspace-supplied elfcorehdr.  In this situation, one
memory or CPU change will rewrite the elfcorehdr via the
crash_prepare_elf64_headers() function and now all possible CPUs will be
described, just as with kexec_file_load() syscall.

Link: https://lkml.kernel.org/r/20230811170642.6696-8-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Suggested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Akhil Raj <lf32.dev@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
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
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/crash_core.c~crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu
+++ a/kernel/crash_core.c
@@ -364,8 +364,8 @@ int crash_prepare_elf64_headers(struct c
 	ehdr->e_ehsize = sizeof(Elf64_Ehdr);
 	ehdr->e_phentsize = sizeof(Elf64_Phdr);
 
-	/* Prepare one phdr of type PT_NOTE for each present CPU */
-	for_each_present_cpu(cpu) {
+	/* Prepare one phdr of type PT_NOTE for each possible CPU */
+	for_each_possible_cpu(cpu) {
 		phdr->p_type = PT_NOTE;
 		notes_addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpu));
 		phdr->p_offset = phdr->p_paddr = notes_addr;
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

