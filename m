Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451D6140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189530; cv=none; b=NjPE9T+ud6eaqqsmQYoLo7QNnJezjSu8EtUXXO5OKNAkvfA6BHMZAE5zFyZ3d+OfSqHqJP2PODkqRcJldLNGbzK9KUx62OgIARcBXWLAKh15dwh5m2+hSBqAhNjqBDGn7fMe9IbK1fkPPyBQ4bkBlMabg9L/M2UWZssf479c8cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189530; c=relaxed/simple;
	bh=yUBrDRbuAZFhmnVsC6MVVSQg72Z4yIOp0LBBsn85shA=;
	h=Date:To:From:Subject:Message-Id; b=dic19R9HkvjnAAz84fky5ruuEI7l7zXIZTRLqQohFckgRCt694Wc/6M/cg8jRt6folx7/YP/V/kbR3k5Jly20z+nfI1gwSxJ95hNtrr3pfYa6vN27Wdd4bpuccA3eZWOqd6PHJ5aFXbSY1RyUXbfZ8INnJtbDXf8DrcR2qAlYeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BEpiGiBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BEpiGiBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89C1C4CEEC;
	Mon, 17 Mar 2025 05:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189529;
	bh=yUBrDRbuAZFhmnVsC6MVVSQg72Z4yIOp0LBBsn85shA=;
	h=Date:To:From:Subject:From;
	b=BEpiGiBKrmPzxI7fv68aTcABFenLRHrggufUe36t/QIZe5aHZT1KBwZ70+aZM0Wox
	 N1LwY0fzybUaW0gzopCp5toNZL7lkVDPHyb0HAg//nr7wkEV+qum0e6xdttf7sg/xm
	 DgPZUQ0RfV485UeFs/WAcS7Z1Pnxmex+cXEpLYrU=
Date: Sun, 16 Mar 2025 22:32:09 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] thermal-core-allow-user-configuration-of-hardware-protection-action.patch removed from -mm tree
Message-Id: <20250317053209.A89C1C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: thermal: core: allow user configuration of hardware protection action
has been removed from the -mm tree.  Its filename was
     thermal-core-allow-user-configuration-of-hardware-protection-action.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -405,9 +405,12 @@ static struct thermal_zone_device *therm
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


