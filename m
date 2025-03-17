Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490E3140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189527; cv=none; b=tjkrSno1NLsntckzc81S/Eha0+kkdiunGTBskuqYkMn98d2pBTb0rgKuLnfNVSuLSFR5pBtOrG1GW+GmSj+jSgTeXaw2XJiF72V0xblXKlJ8FjAuq58eU3x4iB3eW8Pt/7myWOqcHZHkDePGBcKsMP6KHXCz4t7R0YKiUZFDk4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189527; c=relaxed/simple;
	bh=n1NNMkg7C3bx7TsLTdHr6aSquDNPmvnWY/C5tvUXAqg=;
	h=Date:To:From:Subject:Message-Id; b=kBLQ2wNMr1YdUJsB6iCcFe5OHDQdjqFeMji7kqwBd5KAq/rI0E6XDHS2SY+/qGH5NoYK73sEo5b+fkLkcAP6dJpMn76FYE1mBQlHvJpXbkzsYNcW/FFc0rDI49eWwCf7TUG0pU4mTw1FO8zeOTzYz2OdnTAWFupL/R2IpPHLnjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vy9uSLbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vy9uSLbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5CDC4CEEC;
	Mon, 17 Mar 2025 05:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189527;
	bh=n1NNMkg7C3bx7TsLTdHr6aSquDNPmvnWY/C5tvUXAqg=;
	h=Date:To:From:Subject:From;
	b=vy9uSLbMKqNhOvNNzSPf/h0uhSLG5SWYQd3H1WkPaFupbvfIBUdHZiXOIxT3zqhTg
	 EE+blPogPhJoxU/NXvWJ+3y4rRe8x4RmTX3qkyPoJCYtIzUb8j9z7NZ55HeuWVG/Yf
	 TqXHaDn9jEOw3zQqsmpQMtjhePipC/J/CDRAilW4=
Date: Sun, 16 Mar 2025 22:32:06 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] platform-chrome-cros_ec_lpc-prepare-for-hw_protection_shutdown-removal.patch removed from -mm tree
Message-Id: <20250317053207.1D5CDC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: platform/chrome: cros_ec_lpc: prepare for hw_protection_shutdown removal
has been removed from the -mm tree.  Its filename was
     platform-chrome-cros_ec_lpc-prepare-for-hw_protection_shutdown-removal.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


