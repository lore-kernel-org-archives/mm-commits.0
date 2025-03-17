Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C89140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189528; cv=none; b=NaaKoH2Hs/pCCutzhm+l3PELvm6D41vMly8uNVYSOMgrEEnkyvNWkgpx+5kK9HFPFUeQUckFX/Kl8wfxlxDEruN+LqAdPBPv7aDr7SVQBKNx75ZQTtdYM7ikjjoXAFRt0FqJRRermDZALVC3ogJU0mn/ss82hnE+kw2DCJd3cG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189528; c=relaxed/simple;
	bh=Dxw8XVjFsROxxGynea0aqYplmLOlTMJNu+6XklkSIzo=;
	h=Date:To:From:Subject:Message-Id; b=FhDw140t9142msubr6JPgAXcF89pAtr8BB6Pp8qXBy3OjAJOY+FS61jgDJOgMcznz5Z72KsgBHZiysY/F5pm78Fdyh3Dcrj3iX9qsPfAfKccx61q9aKZxLjyHCw8cYMi6HlecqkiOFErSn2T+Xo19uo/1xFCZqEXulsfCae9VV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ogf3hyjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ogf3hyjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C3BC4CEEC;
	Mon, 17 Mar 2025 05:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189528;
	bh=Dxw8XVjFsROxxGynea0aqYplmLOlTMJNu+6XklkSIzo=;
	h=Date:To:From:Subject:From;
	b=Ogf3hyjDIwueYDa1nksaLfWdrHpch7pcfH87oBBP4+6gPXqnPgeuKFhHk+dMdcdNi
	 kxTCMxZhQldfRwATDFO1GjEHb6sIE3ii9VskEn4CNL9gn6meVdAnK2tJteRKn5UwwT
	 PW92nMAl8bg8pECZyAFg7LVk5FEZmUMKIn1cn2b8=
Date: Sun, 16 Mar 2025 22:32:07 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] dt-bindings-thermal-give-os-some-leeway-in-absence-of-critical-action.patch removed from -mm tree
Message-Id: <20250317053208.63C3BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dt-bindings: thermal: give OS some leeway in absence of critical-action
has been removed from the -mm tree.  Its filename was
     dt-bindings-thermal-give-os-some-leeway-in-absence-of-critical-action.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


