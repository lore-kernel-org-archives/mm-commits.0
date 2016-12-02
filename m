From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-add-purgatory-for-kexec_file_load-implementation.patch removed from -mm tree
Date: Fri, 02 Dec 2016 15:45:44 -0800
Message-ID: <584207a8.6r0MPy97q1+lurRw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753343AbcLBXpe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 18:45:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add purgatory for kexec_file_load() implementation
has been removed from the -mm tree.  Its filename was
     powerpc-add-purgatory-for-kexec_file_load-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc: add purgatory for kexec_file_load() implementation

This purgatory implementation is based on the versions from kexec-tools
and kexec-lite, with additional changes.

Link: http://lkml.kernel.org/r/1480423554-6411-7-git-send-email-mpe@ellerman.id.au
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Makefile                  |    1 
 arch/powerpc/kernel/machine_kexec_64.c |    2 
 arch/powerpc/purgatory/.gitignore      |    2 
 arch/powerpc/purgatory/Makefile        |   15 ++
 arch/powerpc/purgatory/trampoline.S    |  128 +++++++++++++++++++++++
 5 files changed, 147 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation arch/powerpc/Makefile
--- a/arch/powerpc/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation
+++ a/arch/powerpc/Makefile
@@ -250,6 +250,7 @@ core-y				+= arch/powerpc/kernel/ \
 core-$(CONFIG_XMON)		+= arch/powerpc/xmon/
 core-$(CONFIG_KVM) 		+= arch/powerpc/kvm/
 core-$(CONFIG_PERF_EVENTS)	+= arch/powerpc/perf/
+core-$(CONFIG_KEXEC_FILE)	+= arch/powerpc/purgatory/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
 
diff -puN arch/powerpc/kernel/machine_kexec_64.c~powerpc-add-purgatory-for-kexec_file_load-implementation arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~powerpc-add-purgatory-for-kexec_file_load-implementation
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -310,7 +310,7 @@ void default_machine_kexec(struct kimage
 	if (!kdump_in_progress())
 		kexec_prepare_cpus();
 
-	pr_debug("kexec: Starting switchover sequence.\n");
+	printk("kexec: Starting switchover sequence.\n");
 
 	/* switch to a staticly allocated stack.  Based on irq stack code.
 	 * We setup preempt_count to avoid using VMX in memcpy.
diff -puN /dev/null arch/powerpc/purgatory/.gitignore
--- /dev/null
+++ a/arch/powerpc/purgatory/.gitignore
@@ -0,0 +1,2 @@
+kexec-purgatory.c
+purgatory.ro
diff -puN /dev/null arch/powerpc/purgatory/Makefile
--- /dev/null
+++ a/arch/powerpc/purgatory/Makefile
@@ -0,0 +1,15 @@
+targets += trampoline.o purgatory.ro kexec-purgatory.c
+
+LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined
+
+$(obj)/purgatory.ro: $(obj)/trampoline.o FORCE
+		$(call if_changed,ld)
+
+CMD_BIN2C = $(objtree)/scripts/basic/bin2c
+quiet_cmd_bin2c = BIN2C   $@
+      cmd_bin2c = $(CMD_BIN2C) kexec_purgatory < $< > $@
+
+$(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
+	$(call if_changed,bin2c)
+
+obj-y	+= kexec-purgatory.o
diff -puN /dev/null arch/powerpc/purgatory/trampoline.S
--- /dev/null
+++ a/arch/powerpc/purgatory/trampoline.S
@@ -0,0 +1,128 @@
+/*
+ * kexec trampoline
+ *
+ * Based on code taken from kexec-tools and kexec-lite.
+ *
+ * Copyright (C) 2004 - 2005, Milton D Miller II, IBM Corporation
+ * Copyright (C) 2006, Mohan Kumar M, IBM Corporation
+ * Copyright (C) 2013, Anton Blanchard, IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License as published by the Free
+ * Software Foundation (version 2 of the License).
+ */
+
+#if defined(__LITTLE_ENDIAN__)
+#define STWX_BE	stwbrx
+#define LWZX_BE	lwbrx
+#elif defined(__BIG_ENDIAN__)
+#define STWX_BE	stwx
+#define LWZX_BE	lwzx
+#else
+#error no endianness defined!
+#endif
+
+	.machine ppc64
+	.balign 256
+	.globl purgatory_start
+purgatory_start:
+	b	master
+
+	/* ABI: possible run_at_load flag at 0x5c */
+	.org purgatory_start + 0x5c
+	.globl run_at_load
+run_at_load:
+	.long 0
+	.size run_at_load, . - run_at_load
+
+	/* ABI: slaves start at 60 with r3=phys */
+	.org purgatory_start + 0x60
+slave:
+	b .
+	/* ABI: end of copied region */
+	.org purgatory_start + 0x100
+	.size purgatory_start, . - purgatory_start
+
+/*
+ * The above 0x100 bytes at purgatory_start are replaced with the
+ * code from the kernel (or next stage) by setup_purgatory().
+ */
+
+master:
+	or	%r1,%r1,%r1	/* low priority to let other threads catchup */
+	isync
+	mr	%r17,%r3	/* save cpu id to r17 */
+	mr	%r15,%r4	/* save physical address in reg15 */
+
+	or	%r3,%r3,%r3	/* ok now to high priority, lets boot */
+	lis	%r6,0x1
+	mtctr	%r6		/* delay a bit for slaves to catch up */
+	bdnz	.		/* before we overwrite 0-100 again */
+
+	bl	0f		/* Work out where we're running */
+0:	mflr	%r18
+
+	/* load device-tree address */
+	ld	%r3, (dt_offset - 0b)(%r18)
+	mr	%r16,%r3	/* save dt address in reg16 */
+	li	%r4,20
+	LWZX_BE	%r6,%r3,%r4	/* fetch __be32 version number at byte 20 */
+	cmpwi	%r0,%r6,2	/* v2 or later? */
+	blt	1f
+	li	%r4,28
+	STWX_BE	%r17,%r3,%r4	/* Store my cpu as __be32 at byte 28 */
+1:
+	/* load the kernel address */
+	ld	%r4,(kernel - 0b)(%r18)
+
+	/* load the run_at_load flag */
+	/* possibly patched by kexec */
+	ld	%r6,(run_at_load - 0b)(%r18)
+	/* and patch it into the kernel */
+	stw	%r6,(0x5c)(%r4)
+
+	mr	%r3,%r16	/* restore dt address */
+
+	li	%r5,0		/* r5 will be 0 for kernel */
+
+	mfmsr	%r11
+	andi.	%r10,%r11,1	/* test MSR_LE */
+	bne	.Little_endian
+
+	mtctr	%r4		/* prepare branch to */
+	bctr			/* start kernel */
+
+.Little_endian:
+	mtsrr0	%r4		/* prepare branch to */
+
+	clrrdi	%r11,%r11,1	/* clear MSR_LE */
+	mtsrr1	%r11
+
+	rfid			/* update MSR and start kernel */
+
+
+	.balign 8
+	.globl kernel
+kernel:
+	.llong  0x0
+	.size kernel, . - kernel
+
+	.balign 8
+	.globl dt_offset
+dt_offset:
+	.llong  0x0
+	.size dt_offset, . - dt_offset
+
+
+	.data
+	.balign 8
+.globl sha256_digest
+sha256_digest:
+	.skip	32
+	.size sha256_digest, . - sha256_digest
+
+	.balign 8
+.globl sha_regions
+sha_regions:
+	.skip	8 * 2 * 16
+	.size sha_regions, . - sha_regions
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

powerpc-kexec-enable-kexec_file_load-syscall.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

