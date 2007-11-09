From: akpm@linux-foundation.org
Subject: + blackfin-remove-dump_thread.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:44:20 -0800
Message-ID: <200711090444.lA94iL6B029941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758728AbXKIEom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:44:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bryan.wu@analog.com


The patch titled
     blackfin: remove dump_thread()
has been added to the -mm tree.  Its filename is
     blackfin-remove-dump_thread.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin: remove dump_thread()
From: Adrian Bunk <bunk@kernel.org>

Remove the unused dump_thread().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/bfin_ksyms.c  |    1 
 arch/blackfin/kernel/process.c     |   45 ---------------------------
 include/asm-blackfin/bfin-global.h |    1 
 3 files changed, 47 deletions(-)

diff -puN arch/blackfin/kernel/bfin_ksyms.c~blackfin-remove-dump_thread arch/blackfin/kernel/bfin_ksyms.c
--- a/arch/blackfin/kernel/bfin_ksyms.c~blackfin-remove-dump_thread
+++ a/arch/blackfin/kernel/bfin_ksyms.c
@@ -39,7 +39,6 @@
 EXPORT_SYMBOL(__ioremap);
 EXPORT_SYMBOL(strcmp);
 EXPORT_SYMBOL(strncmp);
-EXPORT_SYMBOL(dump_thread);
 
 EXPORT_SYMBOL(ip_fast_csum);
 
diff -puN arch/blackfin/kernel/process.c~blackfin-remove-dump_thread arch/blackfin/kernel/process.c
--- a/arch/blackfin/kernel/process.c~blackfin-remove-dump_thread
+++ a/arch/blackfin/kernel/process.c
@@ -239,51 +239,6 @@ copy_thread(int nr, unsigned long clone_
 }
 
 /*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs *regs, struct user *dump)
-{
-	dump->magic = CMAGIC;
-	dump->start_code = 0;
-	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((unsigned long)current->mm->end_code) >> PAGE_SHIFT;
-	dump->u_dsize = ((unsigned long)(current->mm->brk +
-					 (PAGE_SIZE - 1))) >> PAGE_SHIFT;
-	dump->u_dsize -= dump->u_tsize;
-	dump->u_ssize = 0;
-
-	if (dump->start_stack < TASK_SIZE)
-		dump->u_ssize =
-		    ((unsigned long)(TASK_SIZE -
-				     dump->start_stack)) >> PAGE_SHIFT;
-
-	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
-
-	dump->regs.r0 = regs->r0;
-	dump->regs.r1 = regs->r1;
-	dump->regs.r2 = regs->r2;
-	dump->regs.r3 = regs->r3;
-	dump->regs.r4 = regs->r4;
-	dump->regs.r5 = regs->r5;
-	dump->regs.r6 = regs->r6;
-	dump->regs.r7 = regs->r7;
-	dump->regs.p0 = regs->p0;
-	dump->regs.p1 = regs->p1;
-	dump->regs.p2 = regs->p2;
-	dump->regs.p3 = regs->p3;
-	dump->regs.p4 = regs->p4;
-	dump->regs.p5 = regs->p5;
-	dump->regs.orig_p0 = regs->orig_p0;
-	dump->regs.a0w = regs->a0w;
-	dump->regs.a1w = regs->a1w;
-	dump->regs.a0x = regs->a0x;
-	dump->regs.a1x = regs->a1x;
-	dump->regs.rets = regs->rets;
-	dump->regs.astat = regs->astat;
-	dump->regs.pc = regs->pc;
-}
-
-/*
  * sys_execve() executes a new program.
  */
 
diff -puN include/asm-blackfin/bfin-global.h~blackfin-remove-dump_thread include/asm-blackfin/bfin-global.h
--- a/include/asm-blackfin/bfin-global.h~blackfin-remove-dump_thread
+++ a/include/asm-blackfin/bfin-global.h
@@ -50,7 +50,6 @@ extern unsigned long get_sclk(void);
 extern unsigned long sclk_to_usecs(unsigned long sclk);
 extern unsigned long usecs_to_sclk(unsigned long usecs);
 
-extern void dump_thread(struct pt_regs *regs, struct user *dump);
 extern void dump_bfin_regs(struct pt_regs *fp, void *retaddr);
 extern void dump_bfin_trace_buffer(void);
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
dvb-bt8xx-dstc-make-code-static.patch
dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload.patch
dvb-usb-vp702xc-cleanups.patch
dvb-usb-make-some-debug-vars-static.patch
media-common-ir-functionsc-make-a-function-static.patch
cx88-mpegc-make-4-functions-static.patch
media-video-et61x251-make-5-functions-static.patch
git-hwmon.patch
fs-dlm-proper-prototypes.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
