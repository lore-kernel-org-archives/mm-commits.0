Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83FD13BC35
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847254; cv=none; b=jRtLSwlyJZgt6SEkiTacD276+ixLf75sqtR0h67ZKd6KVYE8X1mbwnFDhOhZ7OfEQDQIv/lAexFMpDWowwWaALJslvPifjkDBlloAMUpjGxV61KMILxMMCcFBI0c4VW1KWtXuJmVatgNankVfTxdtDS1Ygkx5t6+YIb5QriKWlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847254; c=relaxed/simple;
	bh=pg9E4yJYqafCE7ccLRf7NNiXmJ1ApJehwF2qEK9Eaww=;
	h=Date:To:From:Subject:Message-Id; b=L3qKmFPc8NnnAnMeiJ3c4PlJyEaF+qf/EOq98ozVROvYxx3sxWzuwTt3dCNA81VuZu5/I7n+E2l0HpiG/NkL8ninwHI3uKLpoPIGFl2PlqkzbNg4mnNezTKhRyCyZtjjPTH279K/4PGGIRybDyrV0zkAd/2Ymb/mCnwzKnPriw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C6Lw3GyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C6Lw3GyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD5CC4CED1;
	Tue, 18 Feb 2025 02:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847254;
	bh=pg9E4yJYqafCE7ccLRf7NNiXmJ1ApJehwF2qEK9Eaww=;
	h=Date:To:From:Subject:From;
	b=C6Lw3GyRZvBCdzSHElFzXR+pk9FnWA18GPSWGwBgQ73CKCFwilCRh7DFTqcZFpQqU
	 NRhwYaof0lDWN33nRBAiWDEdki4EOeOgOxE/D+zxSzPhr8vkLm90msdQyJD1CBZp3U
	 0q/R3v18KtEcADo9Wbgb/fwGZlX4kyUbsFK8Q70U=
Date: Mon, 17 Feb 2025 18:54:14 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + thermal-core-allow-user-configuration-of-hardware-protection-action.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025414.7CD5CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: thermal: core: allow user configuration of hardware protection action
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     thermal-core-allow-user-configuration-of-hardware-protection-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/thermal-core-allow-user-configuration-of-hardware-protection-action.patch

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
Subject: thermal: core: allow user configuration of hardware protection action
Date: Mon, 17 Feb 2025 21:39:51 +0100

In the general case, we don't know which of system shutdown or reboot is
the better action to take to protect hardware in an emergency situation. 
We thus allow the policy to come from the device-tree in the form of an
optional critical-action OF property, but so far there was no way for the
end user to configure this.

With recent addition of the hw_protection parameter, the user can now
choose a default action for the case, where the driver isn't fully sure
what's the better course of action.

Let's make use of this by passing HWPROT_ACT_DEFAULT in absence of the
critical-action OF property.

As HWPROT_ACT_DEFAULT is shutdown by default, this introduces no
functional change for users, unless they start using the new parameter.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-11-e1c09b090c0c@pengutronix.de
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matteo Croce <teknoraver@meta.com>
Cc: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Rui Zhang <rui.zhang@intel.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_core.c |   17 ++++++++++-------
 drivers/thermal/thermal_core.h |    1 +
 drivers/thermal/thermal_of.c   |    7 +++++--
 3 files changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/thermal/thermal_core.c~thermal-core-allow-user-configuration-of-hardware-protection-action
+++ a/drivers/thermal/thermal_core.c
@@ -369,7 +369,8 @@ void thermal_governor_update_tz(struct t
 	tz->governor->update_tz(tz, reason);
 }
 
-static void thermal_zone_device_halt(struct thermal_zone_device *tz, bool shutdown)
+static void thermal_zone_device_halt(struct thermal_zone_device *tz,
+				     enum hw_protection_action action)
 {
 	/*
 	 * poweroff_delay_ms must be a carefully profiled positive value.
@@ -380,21 +381,23 @@ static void thermal_zone_device_halt(str
 
 	dev_emerg(&tz->device, "%s: critical temperature reached\n", tz->type);
 
-	if (shutdown)
-		hw_protection_shutdown(msg, poweroff_delay_ms);
-	else
-		hw_protection_reboot(msg, poweroff_delay_ms);
+	__hw_protection_trigger(msg, poweroff_delay_ms, action);
 }
 
 void thermal_zone_device_critical(struct thermal_zone_device *tz)
 {
-	thermal_zone_device_halt(tz, true);
+	thermal_zone_device_halt(tz, HWPROT_ACT_DEFAULT);
 }
 EXPORT_SYMBOL(thermal_zone_device_critical);
 
+void thermal_zone_device_critical_shutdown(struct thermal_zone_device *tz)
+{
+	thermal_zone_device_halt(tz, HWPROT_ACT_SHUTDOWN);
+}
+
 void thermal_zone_device_critical_reboot(struct thermal_zone_device *tz)
 {
-	thermal_zone_device_halt(tz, false);
+	thermal_zone_device_halt(tz, HWPROT_ACT_REBOOT);
 }
 
 static void handle_critical_trips(struct thermal_zone_device *tz,
--- a/drivers/thermal/thermal_core.h~thermal-core-allow-user-configuration-of-hardware-protection-action
+++ a/drivers/thermal/thermal_core.h
@@ -262,6 +262,7 @@ int thermal_build_list_of_policies(char
 void __thermal_zone_device_update(struct thermal_zone_device *tz,
 				  enum thermal_notify_event event);
 void thermal_zone_device_critical_reboot(struct thermal_zone_device *tz);
+void thermal_zone_device_critical_shutdown(struct thermal_zone_device *tz);
 void thermal_governor_update_tz(struct thermal_zone_device *tz,
 				enum thermal_notify_event reason);
 
--- a/drivers/thermal/thermal_of.c~thermal-core-allow-user-configuration-of-hardware-protection-action
+++ a/drivers/thermal/thermal_of.c
@@ -397,9 +397,12 @@ static struct thermal_zone_device *therm
 	of_ops.should_bind = thermal_of_should_bind;
 
 	ret = of_property_read_string(np, "critical-action", &action);
-	if (!ret)
-		if (!of_ops.critical && !strcasecmp(action, "reboot"))
+	if (!ret && !of_ops.critical) {
+		if (!strcasecmp(action, "reboot"))
 			of_ops.critical = thermal_zone_device_critical_reboot;
+		else if (!strcasecmp(action, "shutdown"))
+			of_ops.critical = thermal_zone_device_critical_shutdown;
+	}
 
 	tz = thermal_zone_device_register_with_trips(np->name, trips, ntrips,
 						     data, &of_ops, &tzp,
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

