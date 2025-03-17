Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54225140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189518; cv=none; b=tteHeW2WkaiwmF8Ool6bnT1XIOF5JvQTVHYn3qIzagTtNmahnZuIGOjr5wPbr+TQYwYo5RBr9nOjDJqjRU3pqfLIf+wBPGLe02vGfNr8aaLloY3ABNxKpMWnQhB8aa9PYBsbMJPH8T214N1hwneNs3IXIEPGTuPV3wRy/yri7U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189518; c=relaxed/simple;
	bh=FTv+9NNW98mA3SrvKIEXnCvaJbiXPY/zOmOykiuQ4vI=;
	h=Date:To:From:Subject:Message-Id; b=GTKNAk+fnrt4wnmqBDoyCibRwQjj0dMaYL1FBktjiOBN1ogbre2aIYRqTxf9EjOVlpWpPLur4wARCROFOQDQUxe41igYuaHLx1ulpDQWmkohscN6miI5m5NGArM80yPLWCO3+8dLiYy24o78qHdfWZqkEnVyXC6/D/RgUlsE1GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PabCIITK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PabCIITK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E4CC4CEEC;
	Mon, 17 Mar 2025 05:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189517;
	bh=FTv+9NNW98mA3SrvKIEXnCvaJbiXPY/zOmOykiuQ4vI=;
	h=Date:To:From:Subject:From;
	b=PabCIITKqGquFwA/Vx3xdDu9bvuiM9c6H/VMUvnuMr6fRcTI+tvejatgsiH9BiD1K
	 5ZmX3Nx51s5mCVU/6PzWpXI0v9GkULmxA6y/c36QYtXqjoS2BK7vkwVq/oMLXF4tx6
	 9RtU0CBy8YhsU/pyK55QYXE1FpVtd9CC+fFVa6Mk=
Date: Sun, 16 Mar 2025 22:31:57 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] docs-thermal-sync-hardware-protection-doc-with-code.patch removed from -mm tree
Message-Id: <20250317053157.B2E4CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: thermal: sync hardware protection doc with code
has been removed from the -mm tree.  Its filename was
     docs-thermal-sync-hardware-protection-doc-with-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


