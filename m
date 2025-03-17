Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E11140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189526; cv=none; b=GchhXABvkhQiaQ5DtalxI2YaUXuVh4Kn1vB4bXKmhoYZR08Hpp+RzgSV4rNtzyWqb8cM0/RLTTr5dwLib2J7oewg7dmDTzc6Bx8h4sp7pawOoHQfqOsh8ugVLg9NpWgXup7AmZa5nWmMmmPP22wGmvmjy4RFhkhYLB0PhDJsfM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189526; c=relaxed/simple;
	bh=vDWj7QlP8kbPiQF1VyxGmdt+jA9BVhmjWUsFOmvu8zc=;
	h=Date:To:From:Subject:Message-Id; b=IQPh5lf3quh9y1v3RAZP/f9WvEXmPzskI7yBt8QO3gkCUFEnMxR+F1jrU3XzUKJPJ5n/1bCTrsnneV3bnvhnLapCL1Ar2lCsI7JAhw+ZYSorPzvgKiRug5pf64nPgiiue7HwGuyn50T0EXoqwgQVF3oMOJh7QFVnGa3lydypCMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Qf+QRY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Qf+QRY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80BFC4CEEC;
	Mon, 17 Mar 2025 05:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189525;
	bh=vDWj7QlP8kbPiQF1VyxGmdt+jA9BVhmjWUsFOmvu8zc=;
	h=Date:To:From:Subject:From;
	b=0Qf+QRY9kEs3Ne1ZFV/3OXJXvkzbil1j+P/Lsoxul3lKk8I1uCy2DpDSd53hMoq7K
	 hcESo/ECZ32+AufYTS2YYk79BgS59NxKfZfJO53y1OPOqj/Czee1s8LglufkwIkN3X
	 GCK4G5DzTagmZ4Qza1JvNHy2gZtoJSVzBiwGVrp8=
Date: Sun, 16 Mar 2025 22:32:05 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] regulator-allow-user-configuration-of-hardware-protection-action.patch removed from -mm tree
Message-Id: <20250317053205.C80BFC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: regulator: allow user configuration of hardware protection action
has been removed from the -mm tree.  Its filename was
     regulator-allow-user-configuration-of-hardware-protection-action.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


