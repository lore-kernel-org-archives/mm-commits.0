Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CC327470
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847232; cv=none; b=ePKRI3uKLTQsWUYjcbdDPZ46318jz/gtiT6ndpjpZ4VOfw/r1zQFARzVmjhWcvgKwGNgq6cxbXWIcmpQmubrLevIsNQJ8xGCLkFnq0kuhU61f7oJ/O2mPMA8gFLch8RMvXOnUVjUBphk9Fr6zZcKpn+iE6jCI2O5RP4iyUApKtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847232; c=relaxed/simple;
	bh=4JyYZZS0fpTalUzQ6/nTU3kv0JVi5FXPPZcW/RW2efs=;
	h=Date:To:From:Subject:Message-Id; b=axZnGDbYFFtStOsKJ48OqksojEDirPeNLuTJqJ9755GBa2YNlonOy41ulgny9a6A5sWf3xqkHJUkqQMbYgVscswuQbqgPN76dR1lVQadGoELP3HAX2PzLyy4dTzXPpdRi3Esq82o8RPk0HG8yU2wMgSZmAC/nRWF5tZihXuJ9ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mSG7/Xc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mSG7/Xc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C933C4CED1;
	Tue, 18 Feb 2025 02:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847232;
	bh=4JyYZZS0fpTalUzQ6/nTU3kv0JVi5FXPPZcW/RW2efs=;
	h=Date:To:From:Subject:From;
	b=mSG7/Xc6VkLWgTr8tD5zdHZ3n07TOtrWc2HXGpzJrb30DX3UOjdnWx9jlDzsccHSJ
	 l3amXnjpTMHQEueGC/BVf3X/1i6Dni9s3C9yto2CTD/h31f4ziA9AJkFnR9oatt/Hq
	 dAEU/5zNqF4E0vD4Qgwf9EGNxmIL/SwfF8Kg77Uo=
Date: Mon, 17 Feb 2025 18:53:52 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-reboot-not-shutdown-on-hw_protection_reboot-timeout.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025352.8C933C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: reboot, not shutdown, on hw_protection_reboot timeout
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-reboot-not-shutdown-on-hw_protection_reboot-timeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-reboot-not-shutdown-on-hw_protection_reboot-timeout.patch

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
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: reboot: reboot, not shutdown, on hw_protection_reboot timeout
Date: Mon, 17 Feb 2025 21:39:42 +0100

hw_protection_shutdown() will kick off an orderly shutdown and if that
takes longer than a configurable amount of time, an emergency shutdown
will occur.

Recently, hw_protection_reboot() was added for those systems that don't
implement a proper shutdown and are better served by rebooting and having
the boot firmware worry about doing something about the critical
condition.

On timeout of the orderly reboot of hw_protection_reboot(), the system
would go into shutdown, instead of reboot.  This is not a good idea, as
going into shutdown was explicitly not asked for.

Fix this by always doing an emergency reboot if hw_protection_reboot() is
called and the orderly reboot takes too long.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-2-e1c09b090c0c@pengutronix.de
Fixes: 79fa723ba84c ("reboot: Introduce thermal_zone_device_critical_reboot()")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Benson Leung <bleung@chromium.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matteo Croce <teknoraver@meta.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Rui Zhang <rui.zhang@intel.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   70 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 21 deletions(-)

--- a/kernel/reboot.c~reboot-reboot-not-shutdown-on-hw_protection_reboot-timeout
+++ a/kernel/reboot.c
@@ -932,48 +932,76 @@ void orderly_reboot(void)
 }
 EXPORT_SYMBOL_GPL(orderly_reboot);
 
+static const char *hw_protection_action_str(enum hw_protection_action action)
+{
+	switch (action) {
+	case HWPROT_ACT_SHUTDOWN:
+		return "shutdown";
+	case HWPROT_ACT_REBOOT:
+		return "reboot";
+	default:
+		return "undefined";
+	}
+}
+
+static enum hw_protection_action hw_failure_emergency_action;
+
 /**
- * hw_failure_emergency_poweroff_func - emergency poweroff work after a known delay
- * @work: work_struct associated with the emergency poweroff function
+ * hw_failure_emergency_action_func - emergency action work after a known delay
+ * @work: work_struct associated with the emergency action function
  *
  * This function is called in very critical situations to force
- * a kernel poweroff after a configurable timeout value.
+ * a kernel poweroff or reboot after a configurable timeout value.
  */
-static void hw_failure_emergency_poweroff_func(struct work_struct *work)
+static void hw_failure_emergency_action_func(struct work_struct *work)
 {
+	const char *action_str = hw_protection_action_str(hw_failure_emergency_action);
+
+	pr_emerg("Hardware protection timed-out. Trying forced %s\n",
+		 action_str);
+
 	/*
-	 * We have reached here after the emergency shutdown waiting period has
-	 * expired. This means orderly_poweroff has not been able to shut off
-	 * the system for some reason.
+	 * We have reached here after the emergency action waiting period has
+	 * expired. This means orderly_poweroff/reboot has not been able to
+	 * shut off the system for some reason.
 	 *
-	 * Try to shut down the system immediately using kernel_power_off
-	 * if populated
+	 * Try to shut off the system immediately if possible
 	 */
-	pr_emerg("Hardware protection timed-out. Trying forced poweroff\n");
-	kernel_power_off();
+
+	if (hw_failure_emergency_action == HWPROT_ACT_REBOOT)
+		kernel_restart(NULL);
+	else
+		kernel_power_off();
 
 	/*
 	 * Worst of the worst case trigger emergency restart
 	 */
-	pr_emerg("Hardware protection shutdown failed. Trying emergency restart\n");
+	pr_emerg("Hardware protection %s failed. Trying emergency restart\n",
+		 action_str);
 	emergency_restart();
 }
 
-static DECLARE_DELAYED_WORK(hw_failure_emergency_poweroff_work,
-			    hw_failure_emergency_poweroff_func);
+static DECLARE_DELAYED_WORK(hw_failure_emergency_action_work,
+			    hw_failure_emergency_action_func);
 
 /**
- * hw_failure_emergency_poweroff - Trigger an emergency system poweroff
+ * hw_failure_emergency_schedule - Schedule an emergency system shutdown or reboot
+ *
+ * @action:		The hardware protection action to be taken
+ * @action_delay_ms:	Time in milliseconds to elapse before triggering action
  *
  * This may be called from any critical situation to trigger a system shutdown
- * after a given period of time. If time is negative this is not scheduled.
+ * or reboot after a given period of time.
+ * If time is negative this is not scheduled.
  */
-static void hw_failure_emergency_poweroff(int poweroff_delay_ms)
+static void hw_failure_emergency_schedule(enum hw_protection_action action,
+					  int action_delay_ms)
 {
-	if (poweroff_delay_ms <= 0)
+	if (action_delay_ms <= 0)
 		return;
-	schedule_delayed_work(&hw_failure_emergency_poweroff_work,
-			      msecs_to_jiffies(poweroff_delay_ms));
+	hw_failure_emergency_action = action;
+	schedule_delayed_work(&hw_failure_emergency_action_work,
+			      msecs_to_jiffies(action_delay_ms));
 }
 
 /**
@@ -1006,7 +1034,7 @@ void __hw_protection_shutdown(const char
 	 * Queue a backup emergency shutdown in the event of
 	 * orderly_poweroff failure
 	 */
-	hw_failure_emergency_poweroff(ms_until_forced);
+	hw_failure_emergency_schedule(action, ms_until_forced);
 	if (action == HWPROT_ACT_REBOOT)
 		orderly_reboot();
 	else
_

Patches currently in -mm which might be from a.fatoum@pengutronix.de are

reboot-replace-__hw_protection_shutdown-bool-action-parameter-with-an-enum.patch
reboot-reboot-not-shutdown-on-hw_protection_reboot-timeout.patch
docs-thermal-sync-hardware-protection-doc-with-code.patch
reboot-describe-do_kernel_restarts-cmd-argument-in-kernel-doc.patch
reboot-rename-now-misleading-__hw_protection_shutdown-symbols.patch
reboot-indicate-whether-it-is-a-hardware-protection-reboot-or-shutdown.patch
reboot-add-support-for-configuring-emergency-hardware-protection-action.patch
regulator-allow-user-configuration-of-hardware-protection-action.patch
platform-chrome-cros_ec_lpc-prepare-for-hw_protection_shutdown-removal.patch
dt-bindings-thermal-give-os-some-leeway-in-absence-of-critical-action.patch
thermal-core-allow-user-configuration-of-hardware-protection-action.patch
reboot-retire-hw_protection_reboot-and-hw_protection_shutdown-helpers.patch

