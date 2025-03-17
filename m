Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F8C140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189531; cv=none; b=aoilACLPiZYlzwHZ0Mp2MnvhVc4N2T1EFxMn0LKAsI3mxzyEu5sTFgSDg0MLqA/KLemJGxb0eGaDmIDX4zpcNiT+bCPONr4x/GkyqDwCeBZolUr5avKppg9OZm0Gtl71nru8QHLSRCtu1SE+PaxZ2OIbWk4XjEbmpxjW+wY36yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189531; c=relaxed/simple;
	bh=ZSIDaeJK7DvwhhgG9wn23lFm9GG7Qz7gSS0yYCMQd3g=;
	h=Date:To:From:Subject:Message-Id; b=LpSQP15kVnoBrYTPppH4RK30NRnzC4rlQTNyTl73As3zKKvRpNhc0BhHYQ7TrrwH7hgTwE45jE+BLbFRe0q/cyLy9jDAMzc+1MuIU1E1a4OQNFOOV1aQUOB2tLKlax1XN8qlKWir5k/SZ75DfDQnywiI6U3cG5HX5QBhtdkiV8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=afH9FQA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="afH9FQA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8FAC4CEEC;
	Mon, 17 Mar 2025 05:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189531;
	bh=ZSIDaeJK7DvwhhgG9wn23lFm9GG7Qz7gSS0yYCMQd3g=;
	h=Date:To:From:Subject:From;
	b=afH9FQA3/4jjYp4EEYpr25eI7btMeKbZMFQR2UU/ajSa+teBOeWaAj/1tkPdLEHWo
	 k4cxmp+Dk3j48sWeYx58W971gzfzbp1srAw1OB1RWiboqAXWN0KvHqsNPVXmO2jqTy
	 bfN51/01WMne3dL4L4HYTrEXvSuVAVp909HREiJw=
Date: Sun, 16 Mar 2025 22:32:10 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] reboot-retire-hw_protection_reboot-and-hw_protection_shutdown-helpers.patch removed from -mm tree
Message-Id: <20250317053210.EC8FAC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: reboot: retire hw_protection_reboot and hw_protection_shutdown helpers
has been removed from the -mm tree.  Its filename was
     reboot-retire-hw_protection_reboot-and-hw_protection_shutdown-helpers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


