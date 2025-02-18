Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D14B149E17
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847247; cv=none; b=h1uWhirEjBP9Q/gHp+RnKDkP8WklTVstgQG9kE5SzlLm1WsPjYI3SQr3rDqJHeCYtnamJ4H2xf68LNJOxSqQJzh8JhuPhGnikhTyW8PAgmfMXK0FyGjJQaJUP+fKCTXxvu0xoWlFC+U2N7G3uQMfBuW1B9MXJdKNqlyeBCg8cSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847247; c=relaxed/simple;
	bh=6P34nZ8Qhu9f8bCXiTrzdrAjL3T6W5lJHkpnKMVBzp4=;
	h=Date:To:From:Subject:Message-Id; b=i8nPlLuATRZA5FyEzwaN5jB8yaPzgERBrD3arlTZM57HtoSQUvi5WEYUVngspSJPM8lxKbJNdKk1xyAD3C6nSdI0hrRyaBSowR/jqxsFGuHtPtuqVMvS9DJfBcqqSgZPlTc5n04YicrYQBule3NLK/0+O/XM5wdjxwEVuBSlTqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wZQBFpEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wZQBFpEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C9FC4CED1;
	Tue, 18 Feb 2025 02:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847247;
	bh=6P34nZ8Qhu9f8bCXiTrzdrAjL3T6W5lJHkpnKMVBzp4=;
	h=Date:To:From:Subject:From;
	b=wZQBFpEKvnkog/8FcFmsiiP1UvPuQgk+abu6ts0SMBR+gjwoTYpxGs0eDWkCIMgon
	 EU5la9TFH3kS+xjqmQFYOL5NxjUXOJ/6Opwl5P6wAnkAj3oTKlj7Oxsh02nk9NI5jn
	 okKwBJO12aHGRZzlrxlcl+FiQo/SsQdYMkBasgbE=
Date: Mon, 17 Feb 2025 18:54:06 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + regulator-allow-user-configuration-of-hardware-protection-action.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025407.51C9FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: regulator: allow user configuration of hardware protection action
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     regulator-allow-user-configuration-of-hardware-protection-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/regulator-allow-user-configuration-of-hardware-protection-action.patch

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
Subject: regulator: allow user configuration of hardware protection action
Date: Mon, 17 Feb 2025 21:39:48 +0100

When the core detects permanent regulator hardware failure or imminent
power failure of a critical supply, it will call hw_protection_shutdown in
an attempt to do a limited orderly shutdown followed by powering off the
system.

This doesn't work out well for many unattended embedded systems that don't
have support for shutdown and that power on automatically when power is
supplied:

  - A brief power cycle gets detected by the driver
  - The kernel powers down the system and SoC goes into shutdown mode
  - Power is restored
  - The system remains oblivious to the restored power
  - System needs to be manually power cycled for a duration long enough
    to drain the capacitors

Allow users to fix this by calling the newly introduced
hw_protection_trigger() instead: This way the hw_protection commandline or
sysfs parameter is used to dictate the policy of dealing with the
regulator fault.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-8-e1c09b090c0c@pengutronix.de
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

 drivers/regulator/core.c        |    4 ++--
 drivers/regulator/irq_helpers.c |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/regulator/core.c~regulator-allow-user-configuration-of-hardware-protection-action
+++ a/drivers/regulator/core.c
@@ -5262,8 +5262,8 @@ static void regulator_handle_critical(st
 	if (!reason)
 		return;
 
-	hw_protection_shutdown(reason,
-			       rdev->constraints->uv_less_critical_window_ms);
+	hw_protection_trigger(reason,
+			      rdev->constraints->uv_less_critical_window_ms);
 }
 
 /**
--- a/drivers/regulator/irq_helpers.c~regulator-allow-user-configuration-of-hardware-protection-action
+++ a/drivers/regulator/irq_helpers.c
@@ -64,16 +64,16 @@ static void regulator_notifier_isr_work(
 reread:
 	if (d->fatal_cnt && h->retry_cnt > d->fatal_cnt) {
 		if (!d->die)
-			return hw_protection_shutdown("Regulator HW failure? - no IC recovery",
-						      REGULATOR_FORCED_SAFETY_SHUTDOWN_WAIT_MS);
+			return hw_protection_trigger("Regulator HW failure? - no IC recovery",
+						     REGULATOR_FORCED_SAFETY_SHUTDOWN_WAIT_MS);
 		ret = d->die(rid);
 		/*
 		 * If the 'last resort' IC recovery failed we will have
 		 * nothing else left to do...
 		 */
 		if (ret)
-			return hw_protection_shutdown("Regulator HW failure. IC recovery failed",
-						      REGULATOR_FORCED_SAFETY_SHUTDOWN_WAIT_MS);
+			return hw_protection_trigger("Regulator HW failure. IC recovery failed",
+						     REGULATOR_FORCED_SAFETY_SHUTDOWN_WAIT_MS);
 
 		/*
 		 * If h->die() was implemented we assume recovery has been
@@ -263,14 +263,14 @@ fail_out:
 	if (d->fatal_cnt && h->retry_cnt > d->fatal_cnt) {
 		/* If we have no recovery, just try shut down straight away */
 		if (!d->die) {
-			hw_protection_shutdown("Regulator failure. Retry count exceeded",
-					       REGULATOR_FORCED_SAFETY_SHUTDOWN_WAIT_MS);
+			hw_protection_trigger("Regulator failure. Retry count exceeded",
+					      REGULATOR_FORCED_SAFETY_SHUTDOWN_WAIT_MS);
 		} else {
 			ret = d->die(rid);
 			/* If die() failed shut down as a last attempt to save the HW */
 			if (ret)
-				hw_protection_shutdown("Regulator failure. Recovery failed",
-						       REGULATOR_FORCED_SAFETY_SHUTDOWN_WAIT_MS);
+				hw_protection_trigger("Regulator failure. Recovery failed",
+						      REGULATOR_FORCED_SAFETY_SHUTDOWN_WAIT_MS);
 		}
 	}
 
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

