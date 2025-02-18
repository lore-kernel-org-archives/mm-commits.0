Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594001494CF
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847252; cv=none; b=gZe6MxNxh/QPgqmtTwYmx86s8pd+Q5HAMcgNnmowidgXWuL8NobZOhw3uX7B/veBWg8ALyz8Pv5KyY8H9q7FZloOoXyURTe23esl74jixIahX3RLW0WVc3Ve+Ujdv1g3hWhkyMJfkYTvbgTzLAPHgxYi5TD1mpIX3NAJyfYP9rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847252; c=relaxed/simple;
	bh=IZ942bFXct0MECo6zyHca/n9iyVBXIcXqSnLLriPnCQ=;
	h=Date:To:From:Subject:Message-Id; b=KDcXwcMbAaggktui7/HXNH0jBaHzFI1zGgSjRqWSHwfJBa4r/Kd59PUuSbrMYehjWanmaLg4rk5BK52YQXcS82KXF96lo3E3ZczJgWf9oAMAkn3jZ8vIrFEqhaSN3XOEmLO2wJqKopB4D5rTNThjopEcRkdo/B10Figxa5Hd9tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eL9a45Qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eL9a45Qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2A4C4CED1;
	Tue, 18 Feb 2025 02:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847252;
	bh=IZ942bFXct0MECo6zyHca/n9iyVBXIcXqSnLLriPnCQ=;
	h=Date:To:From:Subject:From;
	b=eL9a45QusfYoaz72a9mGAvyYzU++C0o9rLooBJ4N4EUXb+OF0rJ/pirTdTQiUfNei
	 yaZREWQiXJHMVDQA9bfEWiyGtauEpvj3PQIgdh6UReLXGFN3ohq/EEBXpCDArHvK70
	 Q66OyndiK1gmzZa9L11Zr+Pz/rkD0A2GXLfq7DQw=
Date: Mon, 17 Feb 2025 18:54:11 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dt-bindings-thermal-give-os-some-leeway-in-absence-of-critical-action.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025412.2C2A4C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dt-bindings: thermal: give OS some leeway in absence of critical-action
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dt-bindings-thermal-give-os-some-leeway-in-absence-of-critical-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dt-bindings-thermal-give-os-some-leeway-in-absence-of-critical-action.patch

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
Subject: dt-bindings: thermal: give OS some leeway in absence of critical-action
Date: Mon, 17 Feb 2025 21:39:50 +0100

An operating system may allow its user to configure the action to be
undertaken on critical overtemperature events.

However, the bindings currently mandate an absence of the critical-action
property to be equal to critical-action = "shutdown", which would mean any
differing user configuration would violate the bindings.

Resolve this by documenting the absence of the property to mean that the
OS gets to decide.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-10-e1c09b090c0c@pengutronix.de
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
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
Cc: Rui Zhang <rui.zhang@intel.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/thermal/thermal-zones.yaml |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/Documentation/devicetree/bindings/thermal/thermal-zones.yaml~dt-bindings-thermal-give-os-some-leeway-in-absence-of-critical-action
+++ a/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
@@ -82,9 +82,8 @@ patternProperties:
         $ref: /schemas/types.yaml#/definitions/string
         description: |
           The action the OS should perform after the critical temperature is reached.
-          By default the system will shutdown as a safe action to prevent damage
-          to the hardware, if the property is not set.
-          The shutdown action should be always the default and preferred one.
+          If the property is not set, it is up to the system to select the correct
+          action. The recommended and preferred default is shutdown.
           Choose 'reboot' with care, as the hardware may be in thermal stress,
           thus leading to infinite reboots that may cause damage to the hardware.
           Make sure the firmware/bootloader will act as the last resort and take
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

