From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 16 Jan 2015 13:22:00 -0800
Message-ID: <54b980f8.9lw/IRBddZV6iU+O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbbAPVWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jan 2015 16:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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

 drivers/usb/dwc2/gadget.c           |   10 ----------
 drivers/usb/gadget/udc/bdc/bdc_ep.c |    4 ----
 2 files changed, 14 deletions(-)

diff -puN drivers/usb/dwc2/gadget.c~linux-next-git-rejects drivers/usb/dwc2/gadget.c
--- a/drivers/usb/dwc2/gadget.c~linux-next-git-rejects
+++ a/drivers/usb/dwc2/gadget.c
@@ -2622,11 +2622,6 @@ static int s3c_hsotg_ep_disable_force(st
 	epctrl_reg = dir_in ? DIEPCTL(index) : DOEPCTL(index);
 
 	spin_lock_irqsave(&hsotg->lock, flags);
-<<<<<<< HEAD
-	/* terminate all requests with shutdown */
-	kill_all_requests(hsotg, hs_ep, -ESHUTDOWN, force);
-=======
->>>>>>> linux-next/akpm-base
 
 	hsotg->fifo_map &= ~(1<<hs_ep->fifo_index);
 	hs_ep->fifo_index = 0;
@@ -2969,17 +2964,12 @@ static int s3c_hsotg_udc_stop(struct usb
 	mutex_lock(&hsotg->init_mutex);
 
 	/* all endpoints should be shutdown */
-<<<<<<< HEAD
-	for (ep = 1; ep < hsotg->num_of_eps; ep++)
-		s3c_hsotg_ep_disable_force(&hsotg->eps[ep].ep, true);
-=======
 	for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 		if (hsotg->eps_in[ep])
 			s3c_hsotg_ep_disable_force(&hsotg->eps_in[ep]->ep, true);
 		if (hsotg->eps_out[ep])
 			s3c_hsotg_ep_disable_force(&hsotg->eps_out[ep]->ep, true);
 	}
->>>>>>> linux-next/akpm-base
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 
diff -puN drivers/usb/gadget/udc/bdc/bdc_ep.c~linux-next-git-rejects drivers/usb/gadget/udc/bdc/bdc_ep.c
--- a/drivers/usb/gadget/udc/bdc/bdc_ep.c~linux-next-git-rejects
+++ a/drivers/usb/gadget/udc/bdc/bdc_ep.c
@@ -718,11 +718,7 @@ static int ep_queue(struct bdc_ep *ep, s
 	struct bdc *bdc;
 	int ret = 0;
 
-<<<<<<< HEAD
-	if (!req || !ep || !ep->usb_ep.desc)
-=======
 	if (!req || !ep->usb_ep.desc)
->>>>>>> linux-next/akpm-base
 		return -EINVAL;
 
 	bdc = ep->bdc;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch

