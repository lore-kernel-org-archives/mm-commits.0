From: akpm@linux-foundation.org
Subject: + drm-radeon-kms-fix-hibernation-regression-related-to-radeon-pm.patch added to -mm tree
Date: Thu, 17 Jun 2010 16:25:51 -0700
Message-ID: <201006172325.o5HNPp7I000904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186Ab0FQX0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jun 2010 19:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, airlied@linux.ie, alexdeucher@gmail.com, linux@rainbow-software.org, mattst88@gmail.com


The patch titled
     drm/radeon/kms: fix hibernation regression related to radeon PM
has been added to the -mm tree.  Its filename is
     drm-radeon-kms-fix-hibernation-regression-related-to-radeon-pm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/radeon/kms: fix hibernation regression related to radeon PM
From: Rafael J. Wysocki <rjw@sisk.pl>

There is a regression from 2.6.34 related to the recent radeon power
management changes, caused by attempting to cancel a delayed work item
that's never been scheduled.  However, the code as is has some other
issues potentially leading to visible problems.

First, the mutex around cancel_delayed_work() in radeon_pm_suspend()
doesn't really serve any purpose, because cancel_delayed_work() only tries
to delete the work's timer.  Moreover, it doesn't prevent the work handler
from running, so the handler can do some wrong things if it wins the race
and in that case it will rearm itself to do some more wrong things going
forward.  So, I think it's better to wait for the handler to return in
case it's already been queued up for execution.  Also, it should be
prevented from rearming itself in that case.

Second, in radeon_set_pm_method() the cancel_delayed_work() is not
sufficient to prevent the work handler from running and queing up itself
for the next run (the failure scenario is that cancel_delayed_work()
returns 0, so the handler is run, it waits on the mutex and then rearms
itself after the mutex has been released), so again the work handler
should be prevented from rearming itself in that case..

Finally, there's a potential deadlock in radeon_pm_fini(), because
cancel_delayed_work_sync() is called under rdev->pm.mutex, but the work
handler tries to acquire the same mutex (if it wins the race).

Fix the issues described above.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Ondrej Zary <linux@rainbow-software.org>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon.h    |    3 +
 drivers/gpu/drm/radeon/radeon_pm.c |   41 ++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 8 deletions(-)

diff -puN drivers/gpu/drm/radeon/radeon.h~drm-radeon-kms-fix-hibernation-regression-related-to-radeon-pm drivers/gpu/drm/radeon/radeon.h
--- a/drivers/gpu/drm/radeon/radeon.h~drm-radeon-kms-fix-hibernation-regression-related-to-radeon-pm
+++ a/drivers/gpu/drm/radeon/radeon.h
@@ -619,7 +619,8 @@ enum radeon_dynpm_state {
 	DYNPM_STATE_DISABLED,
 	DYNPM_STATE_MINIMUM,
 	DYNPM_STATE_PAUSED,
-	DYNPM_STATE_ACTIVE
+	DYNPM_STATE_ACTIVE,
+	DYNPM_STATE_SUSPENDED,
 };
 enum radeon_dynpm_action {
 	DYNPM_ACTION_NONE,
diff -puN drivers/gpu/drm/radeon/radeon_pm.c~drm-radeon-kms-fix-hibernation-regression-related-to-radeon-pm drivers/gpu/drm/radeon/radeon_pm.c
--- a/drivers/gpu/drm/radeon/radeon_pm.c~drm-radeon-kms-fix-hibernation-regression-related-to-radeon-pm
+++ a/drivers/gpu/drm/radeon/radeon_pm.c
@@ -397,13 +397,20 @@ static ssize_t radeon_set_pm_method(stru
 		rdev->pm.dynpm_planned_action = DYNPM_ACTION_DEFAULT;
 		mutex_unlock(&rdev->pm.mutex);
 	} else if (strncmp("profile", buf, strlen("profile")) == 0) {
+		bool flush_wq = false;
+
 		mutex_lock(&rdev->pm.mutex);
-		rdev->pm.pm_method = PM_METHOD_PROFILE;
+		if (rdev->pm.pm_method == PM_METHOD_DYNPM) {
+			cancel_delayed_work(&rdev->pm.dynpm_idle_work);
+			flush_wq = true;
+		}
 		/* disable dynpm */
 		rdev->pm.dynpm_state = DYNPM_STATE_DISABLED;
 		rdev->pm.dynpm_planned_action = DYNPM_ACTION_NONE;
-		cancel_delayed_work(&rdev->pm.dynpm_idle_work);
+		rdev->pm.pm_method = PM_METHOD_PROFILE;
 		mutex_unlock(&rdev->pm.mutex);
+		if (flush_wq)
+			flush_workqueue(rdev->wq);
 	} else {
 		DRM_ERROR("invalid power method!\n");
 		goto fail;
@@ -418,9 +425,18 @@ static DEVICE_ATTR(power_method, S_IRUGO
 
 void radeon_pm_suspend(struct radeon_device *rdev)
 {
+	bool flush_wq = false;
+
 	mutex_lock(&rdev->pm.mutex);
-	cancel_delayed_work(&rdev->pm.dynpm_idle_work);
+	if (rdev->pm.pm_method == PM_METHOD_DYNPM) {
+		cancel_delayed_work(&rdev->pm.dynpm_idle_work);
+		if (rdev->pm.dynpm_state == DYNPM_STATE_ACTIVE)
+			rdev->pm.dynpm_state = DYNPM_STATE_SUSPENDED;
+		flush_wq = true;
+	}
 	mutex_unlock(&rdev->pm.mutex);
+	if (flush_wq)
+		flush_workqueue(rdev->wq);
 }
 
 void radeon_pm_resume(struct radeon_device *rdev)
@@ -432,6 +448,12 @@ void radeon_pm_resume(struct radeon_devi
 	rdev->pm.current_sclk = rdev->clock.default_sclk;
 	rdev->pm.current_mclk = rdev->clock.default_mclk;
 	rdev->pm.current_vddc = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.voltage;
+	if (rdev->pm.pm_method == PM_METHOD_DYNPM
+	    && rdev->pm.dynpm_state == DYNPM_STATE_SUSPENDED) {
+		rdev->pm.dynpm_state = DYNPM_STATE_ACTIVE;
+		queue_delayed_work(rdev->wq, &rdev->pm.dynpm_idle_work,
+					msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
+	}
 	mutex_unlock(&rdev->pm.mutex);
 	radeon_pm_compute_clocks(rdev);
 }
@@ -486,6 +508,8 @@ int radeon_pm_init(struct radeon_device 
 void radeon_pm_fini(struct radeon_device *rdev)
 {
 	if (rdev->pm.num_power_states > 1) {
+		bool flush_wq = false;
+
 		mutex_lock(&rdev->pm.mutex);
 		if (rdev->pm.pm_method == PM_METHOD_PROFILE) {
 			rdev->pm.profile = PM_PROFILE_DEFAULT;
@@ -493,13 +517,16 @@ void radeon_pm_fini(struct radeon_device
 			radeon_pm_set_clocks(rdev);
 		} else if (rdev->pm.pm_method == PM_METHOD_DYNPM) {
 			/* cancel work */
-			cancel_delayed_work_sync(&rdev->pm.dynpm_idle_work);
+			cancel_delayed_work(&rdev->pm.dynpm_idle_work);
+			flush_wq = true;
 			/* reset default clocks */
 			rdev->pm.dynpm_state = DYNPM_STATE_DISABLED;
 			rdev->pm.dynpm_planned_action = DYNPM_ACTION_DEFAULT;
 			radeon_pm_set_clocks(rdev);
 		}
 		mutex_unlock(&rdev->pm.mutex);
+		if (flush_wq)
+			flush_workqueue(rdev->wq);
 
 		device_remove_file(rdev->dev, &dev_attr_power_profile);
 		device_remove_file(rdev->dev, &dev_attr_power_method);
@@ -720,12 +747,12 @@ static void radeon_dynpm_idle_work_handl
 			radeon_pm_get_dynpm_state(rdev);
 			radeon_pm_set_clocks(rdev);
 		}
+
+		queue_delayed_work(rdev->wq, &rdev->pm.dynpm_idle_work,
+					msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
 	}
 	mutex_unlock(&rdev->pm.mutex);
 	ttm_bo_unlock_delayed_workqueue(&rdev->mman.bdev, resched);
