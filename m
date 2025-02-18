Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94BF1494CF
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847250; cv=none; b=Zvlp9rje32GTFyoFUpHUX+RfLpohHGeiS5eBtqH6YWTFK0QlFFJgY+BKKC8Yi2whW8otT7FZXTn4LFmO4HMt237ki99w10KgdkifVZhwXRkZvUNSOymVGvsghd1ONAEpsYAOf9hB41k2eQCK7aSQvRXzqNq25k1fXJ/NqHdaLy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847250; c=relaxed/simple;
	bh=dVGPC+PON3DO2sZ7q4RuAIXKoIfSrGfp8ghTPhnYUU4=;
	h=Date:To:From:Subject:Message-Id; b=Un0jL6uz+tfAYhim5XdAa9B6h+NsNrtHzcrI4oxuL25sd8ZEybwfCHNZlXUn/Z6000fAvGBhzHgjAFW3y5HQ9T4antWo9F9ytEOZwNhOoEXEIPP+CDe7IAdjA2Oyx/SzueoR3tlIghD3nLvYxG1qVzg88pyAbDMLChNUMPt7cxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zw8OkQix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zw8OkQix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CF2C4CED1;
	Tue, 18 Feb 2025 02:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847250;
	bh=dVGPC+PON3DO2sZ7q4RuAIXKoIfSrGfp8ghTPhnYUU4=;
	h=Date:To:From:Subject:From;
	b=zw8OkQixKlQWd8yLuu304FGj0Q3rmbPkYi8/CBxDGJ1BJfCY6xCHvkAx/Wm0D4Kii
	 qXAPLmfphTY+T+uxcbFIv/JGUtIjlt5ZtcFx2nPao5feXscYZ/O7Rpq3kaVkF19aVQ
	 FnRPCAMBXFWTKyDEH+Ynj7BhL5KWoK+s6Mw++/RU=
Date: Mon, 17 Feb 2025 18:54:09 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + platform-chrome-cros_ec_lpc-prepare-for-hw_protection_shutdown-removal.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025410.10CF2C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: platform/chrome: cros_ec_lpc: prepare for hw_protection_shutdown removal
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     platform-chrome-cros_ec_lpc-prepare-for-hw_protection_shutdown-removal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/platform-chrome-cros_ec_lpc-prepare-for-hw_protection_shutdown-removal.patch

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
Subject: platform/chrome: cros_ec_lpc: prepare for hw_protection_shutdown removal
Date: Mon, 17 Feb 2025 21:39:49 +0100

In the general case, a driver doesn't know which of system shutdown or
reboot is the better action to take to protect hardware in an emergency
situation.  For this reason, hw_protection_shutdown is going to be removed
in favor of hw_protection_trigger, which defaults to shutdown, but may be
configured at kernel runtime to be a reboot instead.

The ChromeOS EC situation is different as we do know that shutdown is the
correct action as the EC is programmed to force reset after the short
period, thus replace hw_protection_shutdown with __hw_protection_trigger
with HWPROT_ACT_SHUTDOWN as argument to maintain the same behavior.

No functional change.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-9-e1c09b090c0c@pengutronix.de
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Acked-by: Tzung-Bi Shih <tzungbi@kernel.org>
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

 drivers/platform/chrome/cros_ec_lpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/chrome/cros_ec_lpc.c~platform-chrome-cros_ec_lpc-prepare-for-hw_protection_shutdown-removal
+++ a/drivers/platform/chrome/cros_ec_lpc.c
@@ -454,7 +454,7 @@ static void cros_ec_lpc_acpi_notify(acpi
 		blocking_notifier_call_chain(&ec_dev->panic_notifier, 0, ec_dev);
 		kobject_uevent_env(&ec_dev->dev->kobj, KOBJ_CHANGE, (char **)env);
 		/* Begin orderly shutdown. EC will force reset after a short period. */
-		hw_protection_shutdown("CrOS EC Panic", -1);
+		__hw_protection_trigger("CrOS EC Panic", -1, HWPROT_ACT_SHUTDOWN);
 		/* Do not query for other events after a panic is reported */
 		return;
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

