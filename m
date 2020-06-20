From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Sat, 20 Jun 2020 12:37:00 -0700
Message-ID: <20200620193700.NPaJAmc2J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbgFTThB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 15:37:01 -0400
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

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/display/intel_ddi.c |    8 ------
 drivers/gpu/drm/i915/gt/selftest_lrc.c   |   26 ---------------------
 fs/io_uring.c                            |    6 ----
 3 files changed, 40 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2624,17 +2624,9 @@ tgl_dkl_phy_ddi_vswing_sequence(struct i
 	int rate = 0;
 
 	if (type == INTEL_OUTPUT_HDMI) {
-<<<<<<< HEAD
-		n_entries = ARRAY_SIZE(tgl_dkl_phy_hdmi_ddi_trans);
-		ddi_translations = tgl_dkl_phy_hdmi_ddi_trans;
-	} else {
-		n_entries = ARRAY_SIZE(tgl_dkl_phy_dp_ddi_trans);
-		ddi_translations = tgl_dkl_phy_dp_ddi_trans;
-=======
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
 		rate = intel_dp->link_rate;
->>>>>>> linux-next/akpm-base
 	}
 
 	ddi_translations = tgl_get_dkl_buf_trans(dev_priv, encoder->type, rate,
--- a/drivers/gpu/drm/i915/gt/selftest_lrc.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gt/selftest_lrc.c
@@ -1036,35 +1036,17 @@ static int live_timeslice_preempt(void *
 	if (err)
 		goto err_pin;
 
-<<<<<<< HEAD
-	for_each_prime_number_from(count, 1, 16) {
-		struct intel_engine_cs *engine;
-		enum intel_engine_id id;
-
-		for_each_engine(engine, gt, id) {
-			if (!intel_engine_has_preemption(engine))
-				continue;
-=======
 	for_each_engine(engine, gt, id) {
 		if (!intel_engine_has_preemption(engine))
 			continue;
->>>>>>> linux-next/akpm-base
 
 		memset(vaddr, 0, PAGE_SIZE);
 
-<<<<<<< HEAD
-			engine_heartbeat_disable(engine);
-			err = slice_semaphore_queue(engine, vma, count);
-			engine_heartbeat_enable(engine);
-			if (err)
-				goto err_pin;
-=======
 		engine_heartbeat_disable(engine);
 		err = slice_semaphore_queue(engine, vma, 5);
 		engine_heartbeat_enable(engine);
 		if (err)
 			goto err_pin;
->>>>>>> linux-next/akpm-base
 
 		if (igt_flush_test(gt->i915)) {
 			err = -EIO;
@@ -1506,11 +1488,7 @@ static int live_timeslice_nopreempt(void
 
 		ce = intel_context_create(engine);
 		if (IS_ERR(ce)) {
-<<<<<<< HEAD
-			err = PTR_ERR(rq);
-=======
 			err = PTR_ERR(ce);
->>>>>>> linux-next/akpm-base
 			goto out_spin;
 		}
 
@@ -1540,11 +1518,7 @@ static int live_timeslice_nopreempt(void
 		 * allow the maximum priority barrier through. Wait long
 		 * enough to see if it is timesliced in by mistake.
 		 */
-<<<<<<< HEAD
-		if (i915_request_wait(rq, 0, timeslice_threshold(engine)) >= 0) {
-=======
 		if (i915_request_wait(rq, 0, slice_timeout(engine)) >= 0) {
->>>>>>> linux-next/akpm-base
 			pr_err("%s: I915_PRIORITY_BARRIER request completed, bypassing no-preempt request\n",
 			       engine->name);
 			err = -EINVAL;
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -2930,13 +2930,7 @@ copy_iov:
 			return -EAGAIN;
 		}
 	}
-<<<<<<< HEAD
-out_free:
-	if (!(req->flags & REQ_F_NEED_CLEANUP))
-		kfree(iovec);
-=======
 out:
->>>>>>> linux-next/akpm-base
 	return ret;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
