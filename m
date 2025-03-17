Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DD3140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189515; cv=none; b=ST9e8bsyUR5ReQKQMtyy8ULjccOJAG2nB+QgpMtEcFgJLua7hlrsJ7BtLuSuSCBwYIEh2ajiPUMGWN7bUpNFiMTxUdqRjEfqhv58lNUQ1V5IwBZ6MYCfGucTgQn8ZvCqOZuPVK9cYpebgC5Q0BUWALag2ATEMWGNL4WKaZF9bg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189515; c=relaxed/simple;
	bh=9RzlLTpT0XRarraeSRwxIt6odPLWGDUiq3z7skx6Z6Y=;
	h=Date:To:From:Subject:Message-Id; b=TOllwQ5bHhWoKkEQ0hPcyIXxE1p/yR5G4Ytwq32eoH5QJgnzAhltrkt+/BK5e9jYzg6kcxQe1ME8ZMWVcrHV5oz2MmuVX4pWnyVnUKmI6ThXBMzgJWGwJQAWQlfEpWAfIvku0wmMzBLVq8VlT6kWxCzVp9MUtFNaNn4vWlvG3bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LF4ToCkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LF4ToCkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A22C4CEEC;
	Mon, 17 Mar 2025 05:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189515;
	bh=9RzlLTpT0XRarraeSRwxIt6odPLWGDUiq3z7skx6Z6Y=;
	h=Date:To:From:Subject:From;
	b=LF4ToCkNE7C5aA7uqo9CI28TWV/pir8OJrK7kRWOkTiKL8iIz52Tiuq1oXmTnyUXu
	 NZTuoLsk2ShgNMeGySq+Ik6YmAWBr1VNUgEB04hUvJU++KzI2wZM0I3Vvg1TAK6QXM
	 VsbO7tzT0PRAybZVK1Hs/hpNjYHzpBcwvzZKiqgI=
Date: Sun, 16 Mar 2025 22:31:54 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] reboot-replace-__hw_protection_shutdown-bool-action-parameter-with-an-enum.patch removed from -mm tree
Message-Id: <20250317053155.25A22C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: reboot: replace __hw_protection_shutdown bool action parameter with an enum
has been removed from the -mm tree.  Its filename was
     reboot-replace-__hw_protection_shutdown-bool-action-parameter-with-an-enum.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: reboot: replace __hw_protection_shutdown bool action parameter with an enum
Date: Mon, 17 Feb 2025 21:39:41 +0100

Patch series "reboot: support runtime configuration of emergency
hw_protection action", v3.

We currently leave the decision of whether to shutdown or reboot to
protect hardware in an emergency situation to the individual drivers.

This works out in some cases, where the driver detecting the critical
failure has inside knowledge: It binds to the system management controller
for example or is guided by hardware description that defines what to do.

This is inadequate in the general case though as a driver reporting e.g. 
an imminent power failure can't know whether a shutdown or a reboot would
be more appropriate for a given hardware platform.

To address this, this series adds a hw_protection kernel parameter and
sysfs toggle that can be used to change the action from the shutdown
default to reboot.  A new hw_protection_trigger API then makes use of this
default action.

My particular use case is unattended embedded systems that don't have
support for shutdown and that power on automatically when power is
supplied:

  - A brief power cycle gets detected by the driver
  - The kernel powers down the system and SoC goes into shutdown mode
  - Power is restored
  - The system remains oblivious to the restored power
  - System needs to be manually power cycled for a duration long enough
    to drain the capacitors

With this series, such systems can configure the kernel with
hw_protection=reboot to have the boot firmware worry about critical
conditions.


This patch (of 12):

Currently __hw_protection_shutdown() either reboots or shuts down the
system according to its shutdown argument.

To make the logic easier to follow, both inside __hw_protection_shutdown
and at caller sites, lets replace the bool parameter with an enum.

This will be extra useful, when in a later commit, a third action is added
to the enumeration.

No functional change.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-0-e1c09b090c0c@pengutronix.de
Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-1-e1c09b090c0c@pengutronix.de
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: Matteo Croce <teknoraver@meta.com>
Cc: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Rui Zhang <rui.zhang@intel.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |   18 +++++++++++++++---
 kernel/reboot.c        |   14 ++++++--------
 2 files changed, 21 insertions(+), 11 deletions(-)

--- a/include/linux/reboot.h~reboot-replace-__hw_protection_shutdown-bool-action-parameter-with-an-enum
+++ a/include/linux/reboot.h
@@ -177,16 +177,28 @@ void ctrl_alt_del(void);
 
 extern void orderly_poweroff(bool force);
 extern void orderly_reboot(void);
-void __hw_protection_shutdown(const char *reason, int ms_until_forced, bool shutdown);
+
+/**
+ * enum hw_protection_action - Hardware protection action
+ *
+ * @HWPROT_ACT_SHUTDOWN:
+ *	The system should be shut down (powered off) for HW protection.
+ * @HWPROT_ACT_REBOOT:
+ *	The system should be rebooted for HW protection.
+ */
+enum hw_protection_action { HWPROT_ACT_SHUTDOWN, HWPROT_ACT_REBOOT };
+
+void __hw_protection_shutdown(const char *reason, int ms_until_forced,
+			      enum hw_protection_action action);
 
 static inline void hw_protection_reboot(const char *reason, int ms_until_forced)
 {
-	__hw_protection_shutdown(reason, ms_until_forced, false);
+	__hw_protection_shutdown(reason, ms_until_forced, HWPROT_ACT_REBOOT);
 }
 
 static inline void hw_protection_shutdown(const char *reason, int ms_until_forced)
 {
-	__hw_protection_shutdown(reason, ms_until_forced, true);
+	__hw_protection_shutdown(reason, ms_until_forced, HWPROT_ACT_SHUTDOWN);
 }
 
 /*
--- a/kernel/reboot.c~reboot-replace-__hw_protection_shutdown-bool-action-parameter-with-an-enum
+++ a/kernel/reboot.c
@@ -983,10 +983,7 @@ static void hw_failure_emergency_powerof
  * @ms_until_forced:	Time to wait for orderly shutdown or reboot before
  *			triggering it. Negative value disables the forced
  *			shutdown or reboot.
- * @shutdown:		If true, indicates that a shutdown will happen
- *			after the critical tempeature is reached.
- *			If false, indicates that a reboot will happen
- *			after the critical tempeature is reached.
+ * @action:		The hardware protection action to be taken.
  *
  * Initiate an emergency system shutdown or reboot in order to protect
  * hardware from further damage. Usage examples include a thermal protection.
@@ -994,7 +991,8 @@ static void hw_failure_emergency_powerof
  * pending even if the previous request has given a large timeout for forced
  * shutdown/reboot.
  */
-void __hw_protection_shutdown(const char *reason, int ms_until_forced, bool shutdown)
+void __hw_protection_shutdown(const char *reason, int ms_until_forced,
+			      enum hw_protection_action action)
 {
 	static atomic_t allow_proceed = ATOMIC_INIT(1);
 
@@ -1009,10 +1007,10 @@ void __hw_protection_shutdown(const char
 	 * orderly_poweroff failure
 	 */
 	hw_failure_emergency_poweroff(ms_until_forced);
-	if (shutdown)
-		orderly_poweroff(true);
-	else
+	if (action == HWPROT_ACT_REBOOT)
 		orderly_reboot();
+	else
+		orderly_poweroff(true);
 }
 EXPORT_SYMBOL_GPL(__hw_protection_shutdown);
 
_

Patches currently in -mm which might be from a.fatoum@pengutronix.de are


