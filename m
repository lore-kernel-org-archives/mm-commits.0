Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624DA13BC35
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847235; cv=none; b=odLoJZmdTbvJsbZ9gKySgoMN/7UQXEaHn0JZeKUIjdwK1wbOpnUBAzqfY0WwAvuJn4RbrXlDb/fcfZ8Sh8QeysQr+Dsm0dFzPsyLEgY0HvDHBwmf3DDfQt5nZ2XMclGIFl5jtO9FwAZhL4wHpJhqw5Fzn0HsZJK6ZgYx3ZWjS+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847235; c=relaxed/simple;
	bh=HPx4r/SpSZt12JjaHLRHhdlmNaHJ5WfB0pUhwyHv3FQ=;
	h=Date:To:From:Subject:Message-Id; b=OfgRUdRaEWOPev1/R6562VgFDmdCLYC5czPOFAkRILCDfjpyc4IpFYyhei/nQ+n56phwyTkMTVzeVz93C4IdX301olbTV0LE56rdtvruAtV4JDgSmWBQFHR475bl7AzqPCjpMKOnlhZC6LmSBeOoYtco0i2dCaN1MA90c3g/+T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FigBGGpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FigBGGpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8B9C4CED1;
	Tue, 18 Feb 2025 02:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847234;
	bh=HPx4r/SpSZt12JjaHLRHhdlmNaHJ5WfB0pUhwyHv3FQ=;
	h=Date:To:From:Subject:From;
	b=FigBGGpSU+jtoGVAtvq8J99tA0j5h0DX3tm8ZBRt1C6Gk1qZf5Ra1sCRYUTTFCa8u
	 7EF6mdXwm0lOPoqpXgwig8LDcJe3QEH3l7JDbO32MJP3HYyxt5fIaenVRA9u5tMvvE
	 nDeA0FS9+lWKm/pM/hNHTQVNLm5oYgHk7d6NowSQ=
Date: Mon, 17 Feb 2025 18:53:54 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-thermal-sync-hardware-protection-doc-with-code.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025354.BF8B9C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: thermal: sync hardware protection doc with code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     docs-thermal-sync-hardware-protection-doc-with-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-thermal-sync-hardware-protection-doc-with-code.patch

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
Subject: docs: thermal: sync hardware protection doc with code
Date: Mon, 17 Feb 2025 21:39:43 +0100

Originally, the thermal framework's only hardware protection action was to
trigger a shutdown.  This has been changed a little over a year ago to
also support rebooting as alternative hardware protection action.

Update the documentation to reflect this.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-3-e1c09b090c0c@pengutronix.de
Fixes: 62e79e38b257 ("thermal/thermal_of: Allow rebooting after critical temp")
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

 Documentation/driver-api/thermal/sysfs-api.rst |   25 ++++++++-------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/Documentation/driver-api/thermal/sysfs-api.rst~docs-thermal-sync-hardware-protection-doc-with-code
+++ a/Documentation/driver-api/thermal/sysfs-api.rst
@@ -413,18 +413,21 @@ This function serves as an arbitrator to
 device. It sets the cooling device to the deepest cooling state if
 possible.
 
-5. thermal_emergency_poweroff
-=============================
+5. Critical Events
+==================
 
-On an event of critical trip temperature crossing the thermal framework
-shuts down the system by calling hw_protection_shutdown(). The
-hw_protection_shutdown() first attempts to perform an orderly shutdown
-but accepts a delay after which it proceeds doing a forced power-off
-or as last resort an emergency_restart.
+On an event of critical trip temperature crossing, the thermal framework
+will trigger a hardware protection power-off (shutdown) or reboot,
+depending on configuration.
+
+At first, the kernel will attempt an orderly power-off or reboot, but
+accepts a delay after which it proceeds to do a forced power-off or
+reboot, respectively. If this fails, ``emergency_restart()`` is invoked
+as last resort.
 
 The delay should be carefully profiled so as to give adequate time for
-orderly poweroff.
+orderly power-off or reboot.
 
-If the delay is set to 0 emergency poweroff will not be supported. So a
-carefully profiled non-zero positive value is a must for emergency
-poweroff to be triggered.
+If the delay is set to 0, the emergency action will not be supported. So a
+carefully profiled non-zero positive value is a must for the emergency
+action to be triggered.
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

