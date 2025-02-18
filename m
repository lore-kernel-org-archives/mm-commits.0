Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68CA1494CF
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847259; cv=none; b=PbHV200D7Mr0p8deVn6ozvlWpoNRf26YaxgoCGRI/0Hjf8Zc/nJByl0qS7xrWrOJ3nktNpxGtmS3WSJhYfswMZa5EJr8NgZFO/O5h8SakcByXsEx71d+/sLnAzXm/5bF3wykms3qOkdHscZEXRdY4CucrM7TCdIkSdsyp/1/YLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847259; c=relaxed/simple;
	bh=gdBaOwlFziUOdtrr/nZGuFYRAwAQhbnkygKNsOvx0H8=;
	h=Date:To:From:Subject:Message-Id; b=Xx45KRLxBh4vzBTZukd3ZWZiN3awBI01c27ezY4cmQNlXknmIxbkWgzoGH3I7ZmaWi4lhurrgDrnHd0I2+/C3RbvwmYw9JYHJtLs1ADPTRQgBAWtQi+9rCyCH6sQ3txB3z0Uum14w1/g7tszz1a3Embc8vlF92Fb5gKMftcp3NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zeyhRM71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zeyhRM71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C0CC4CED1;
	Tue, 18 Feb 2025 02:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847257;
	bh=gdBaOwlFziUOdtrr/nZGuFYRAwAQhbnkygKNsOvx0H8=;
	h=Date:To:From:Subject:From;
	b=zeyhRM71o/bDrkhZnBqKg+klchjykR9oeAYD698NstK/DxXT1YvalrW9zoL28CiuZ
	 rAOTnqruKNDc5gwlTb3ddSIOI/hwC6C2jerhNREREVV/x+iOqEiO96jsV4zGl+E7Es
	 I9KwP8X5srgCYMJcMsk68b/AQwVxHGjHfrKlVaOY=
Date: Mon, 17 Feb 2025 18:54:16 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-retire-hw_protection_reboot-and-hw_protection_shutdown-helpers.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025417.54C0CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: retire hw_protection_reboot and hw_protection_shutdown helpers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-retire-hw_protection_reboot-and-hw_protection_shutdown-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-retire-hw_protection_reboot-and-hw_protection_shutdown-helpers.patch

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
Subject: reboot: retire hw_protection_reboot and hw_protection_shutdown helpers
Date: Mon, 17 Feb 2025 21:39:52 +0100

The hw_protection_reboot and hw_protection_shutdown functions mix
mechanism with policy: They let the driver requesting an emergency action
for hardware protection also decide how to deal with it.

This is inadequate in the general case as a driver reporting e.g.  an
imminent power failure can't know whether a shutdown or a reboot would be
more appropriate for a given hardware platform.

With the addition of the hw_protection parameter, it's now possible to
configure at runtime the default emergency action and drivers are expected
to use hw_protection_trigger to have this parameter dictate policy.

As no current users of either hw_protection_shutdown or
hw_protection_shutdown helpers remain, remove them, as not to tempt driver
authors to call them.

Existing users now either defer to hw_protection_trigger or call
__hw_protection_trigger with a suitable argument directly when they have
inside knowledge on whether a reboot or shutdown would be more
appropriate.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-12-e1c09b090c0c@pengutronix.de
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

 include/linux/reboot.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/linux/reboot.h~reboot-retire-hw_protection_reboot-and-hw_protection_shutdown-helpers
+++ a/include/linux/reboot.h
@@ -211,16 +211,6 @@ static inline void hw_protection_trigger
 	__hw_protection_trigger(reason, ms_until_forced, HWPROT_ACT_DEFAULT);
 }
 
-static inline void hw_protection_reboot(const char *reason, int ms_until_forced)
-{
-	__hw_protection_trigger(reason, ms_until_forced, HWPROT_ACT_REBOOT);
-}
-
-static inline void hw_protection_shutdown(const char *reason, int ms_until_forced)
-{
-	__hw_protection_trigger(reason, ms_until_forced, HWPROT_ACT_SHUTDOWN);
-}
-
 /*
  * Emergency restart, callable from an interrupt handler.
  */
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

