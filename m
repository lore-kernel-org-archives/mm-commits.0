From: akpm@linux-foundation.org
Subject: + proper-__do_softirq-prototype.patch added to -mm tree
Date: Sun, 24 Feb 2008 16:05:12 -0800
Message-ID: <200802250005.m1P05CV6004633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756439AbYBYAFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:05:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mingo@elte.hu


The patch titled
     proper __do_softirq() prototype
has been added to the -mm tree.  Its filename is
     proper-__do_softirq-prototype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper __do_softirq() prototype
From: Adrian Bunk <bunk@kernel.org>

Add a proper prototype for __do_softirq() in include/linux/interrupt.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/irq.c    |    2 --
 arch/sh/kernel/irq.c      |    2 --
 arch/x86/kernel/irq_32.c  |    2 --
 include/asm-powerpc/irq.h |    2 --
 include/linux/interrupt.h |    1 +
 5 files changed, 1 insertion(+), 8 deletions(-)

diff -puN arch/s390/kernel/irq.c~proper-__do_softirq-prototype arch/s390/kernel/irq.c
--- a/arch/s390/kernel/irq.c~proper-__do_softirq-prototype
+++ a/arch/s390/kernel/irq.c
@@ -60,8 +60,6 @@ init_IRQ(void)
 /*
  * Switch to the asynchronous interrupt stack for softirq execution.
  */
-extern void __do_softirq(void);
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags, old, new;
diff -puN arch/sh/kernel/irq.c~proper-__do_softirq-prototype arch/sh/kernel/irq.c
--- a/arch/sh/kernel/irq.c~proper-__do_softirq-prototype
+++ a/arch/sh/kernel/irq.c
@@ -200,8 +200,6 @@ void irq_ctx_exit(int cpu)
 	hardirq_ctx[cpu] = NULL;
 }
 
-extern asmlinkage void __do_softirq(void);
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags;
diff -puN arch/x86/kernel/irq_32.c~proper-__do_softirq-prototype arch/x86/kernel/irq_32.c
--- a/arch/x86/kernel/irq_32.c~proper-__do_softirq-prototype
+++ a/arch/x86/kernel/irq_32.c
@@ -190,8 +190,6 @@ void irq_ctx_exit(int cpu)
 	hardirq_ctx[cpu] = NULL;
 }
 
-extern asmlinkage void __do_softirq(void);
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags;
diff -puN include/asm-powerpc/irq.h~proper-__do_softirq-prototype include/asm-powerpc/irq.h
--- a/include/asm-powerpc/irq.h~proper-__do_softirq-prototype
+++ a/include/asm-powerpc/irq.h
@@ -619,8 +619,6 @@ struct pt_regs;
 
 #define __ARCH_HAS_DO_SOFTIRQ
 
-extern void __do_softirq(void);
-
 #ifdef CONFIG_IRQSTACKS
 /*
  * Per-cpu stacks for handling hard and soft interrupts.
diff -puN include/linux/interrupt.h~proper-__do_softirq-prototype include/linux/interrupt.h
--- a/include/linux/interrupt.h~proper-__do_softirq-prototype
+++ a/include/linux/interrupt.h
@@ -270,6 +270,7 @@ struct softirq_action
 };
 
 asmlinkage void do_softirq(void);
+asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action*), void *data);
 extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
sparc-fix-build.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-net.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
