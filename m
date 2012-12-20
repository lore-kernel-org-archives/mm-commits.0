From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:13:46 -0800
Message-ID: <20121220201346.83C4D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37290 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2LTUNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:13:47 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so403838ggn.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:13:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/ptrace.h      |    3 ---
 arch/cris/include/uapi/asm/signal.h |    3 ---
 arch/h8300/include/asm/ptrace.h     |    3 ---
 arch/h8300/include/asm/signal.h     |    3 ---
 arch/m32r/include/asm/signal.h      |    3 ---
 drivers/net/virtio_net.c            |   12 ------------
 6 files changed, 27 deletions(-)

diff -puN arch/cris/include/asm/ptrace.h~linux-next-git-rejects arch/cris/include/asm/ptrace.h
--- a/arch/cris/include/asm/ptrace.h~linux-next-git-rejects
+++ a/arch/cris/include/asm/ptrace.h
@@ -9,9 +9,6 @@
 #define PTRACE_SETREGS            13
 
 #define profile_pc(regs) instruction_pointer(regs)
-<<<<<<< HEAD
-=======
 #define current_user_stack_pointer() rdusp()
->>>>>>> linux-next/akpm-base
 
 #endif /* _CRIS_PTRACE_H */
diff -puN arch/cris/include/uapi/asm/signal.h~linux-next-git-rejects arch/cris/include/uapi/asm/signal.h
--- a/arch/cris/include/uapi/asm/signal.h~linux-next-git-rejects
+++ a/arch/cris/include/uapi/asm/signal.h
@@ -83,15 +83,12 @@ typedef unsigned long sigset_t;
 
 #define SA_RESTORER	0x04000000
 
-<<<<<<< HEAD
 /* 
  * sigaltstack controls
  */
 #define SS_ONSTACK	1
 #define SS_DISABLE	2
 
-=======
->>>>>>> linux-next/akpm-base
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
diff -puN arch/h8300/include/asm/ptrace.h~linux-next-git-rejects arch/h8300/include/asm/ptrace.h
--- a/arch/h8300/include/asm/ptrace.h~linux-next-git-rejects
+++ a/arch/h8300/include/asm/ptrace.h
@@ -28,10 +28,7 @@
 #define current_pt_regs() ((struct pt_regs *) \
 	(THREAD_SIZE + (unsigned long)current_thread_info()) - 1)
 #define signal_pt_regs() ((struct pt_regs *)current->thread.esp0)
-<<<<<<< HEAD
-=======
 #define current_user_stack_pointer() rdusp()
 #endif /* __KERNEL__ */
->>>>>>> linux-next/akpm-base
 #endif /* __ASSEMBLY__ */
 #endif /* _H8300_PTRACE_H */
diff -puN arch/h8300/include/asm/signal.h~linux-next-git-rejects arch/h8300/include/asm/signal.h
--- a/arch/h8300/include/asm/signal.h~linux-next-git-rejects
+++ a/arch/h8300/include/asm/signal.h
@@ -16,8 +16,6 @@ typedef struct {
 	unsigned long sig[_NSIG_WORDS];
 } sigset_t;
 
-<<<<<<< HEAD
-=======
 #else
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
@@ -100,7 +98,6 @@ typedef unsigned long sigset_t;
 #include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
->>>>>>> linux-next/akpm-base
 struct old_sigaction {
 	__sighandler_t sa_handler;
 	old_sigset_t sa_mask;
diff -puN arch/m32r/include/asm/signal.h~linux-next-git-rejects arch/m32r/include/asm/signal.h
--- a/arch/m32r/include/asm/signal.h~linux-next-git-rejects
+++ a/arch/m32r/include/asm/signal.h
@@ -16,8 +16,6 @@ typedef struct {
 	unsigned long sig[_NSIG_WORDS];
 } sigset_t;
 
-<<<<<<< HEAD
-=======
 #else
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
@@ -100,7 +98,6 @@ typedef unsigned long sigset_t;
 #include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
->>>>>>> linux-next/akpm-base
 struct sigaction {
 	__sighandler_t sa_handler;
 	unsigned long sa_flags;
diff -puN drivers/net/virtio_net.c~linux-next-git-rejects drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c~linux-next-git-rejects
+++ a/drivers/net/virtio_net.c
@@ -533,10 +533,6 @@ static bool try_fill_recv(struct receive
 			break;
 		++rq->num;
 	} while (rq->vq->num_free);
-<<<<<<< HEAD
-=======
-
->>>>>>> linux-next/akpm-base
 	if (unlikely(rq->num > rq->max))
 		rq->max = rq->num;
 	virtqueue_kick(rq->vq);
@@ -730,12 +726,8 @@ static netdev_tx_t start_xmit(struct sk_
 		dev->stats.tx_fifo_errors++;
 		if (net_ratelimit())
 			dev_warn(&dev->dev,
-<<<<<<< HEAD
-				 "Unexpected TXQ (%d) queue failure: %d\n", qnum, err);
-=======
 				 "Unexpected TXQ (%d) failure: %d\n",
 				 qnum, err);
->>>>>>> linux-next/akpm-base
 		dev->stats.tx_dropped++;
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
@@ -752,10 +744,6 @@ static netdev_tx_t start_xmit(struct sk_
 		netif_stop_subqueue(dev, qnum);
 		if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
-<<<<<<< HEAD
-			free_old_xmit_skbs(sq);
-=======
->>>>>>> linux-next/akpm-base
 			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
 				netif_start_subqueue(dev, qnum);
 				virtqueue_disable_cb(sq->vq);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
revert-rtc-recycle-id-when-unloading-a-rtc-driver.patch
sgi-xp-handle-non-fatal-traps-fix.patch
sendfile-allows-bypassing-of-notifier-events.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

