Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F038815E5C2
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847242; cv=none; b=u+Egx5/TqlYLWdP5yAVuThPes/s2modMwZBRg/exdQMU7mqXxhCbLT+vQCEEpi5JgD9YXgvuinQQ0pCnXhJXAR4c0IvRgJL3wbOMFi4OtrVx8on5C1NQv5nBkTvkhz+S5fNyov2Q0EAAauEJ73YkCdd+FO0/Ch6nrG424Z9DbKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847242; c=relaxed/simple;
	bh=I8zYVdTfK37i14NMgta241pjYxjXLPg1mdgjOghxmnc=;
	h=Date:To:From:Subject:Message-Id; b=fL+nf60d4dqLiNp23zwcA0DRY6Jr507MxsF/2C2Trci8f+J0QstsWUcs/CPIzRo8DSq4+ueVPZQBGPx0USU00oNC9s11rF881TEx7eqhTvUdyscxUPrRiIFDNHDN4xJ2EFQrqqj84InIwSJelO92DeCp7uhPvCFW0KJIH2x5qTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yoA7yph0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yoA7yph0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6980EC4CEEC;
	Tue, 18 Feb 2025 02:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847241;
	bh=I8zYVdTfK37i14NMgta241pjYxjXLPg1mdgjOghxmnc=;
	h=Date:To:From:Subject:From;
	b=yoA7yph0S2JsFpLWbr49BCOROY1lX5O+5HnYYYF7mt5H1nIa+a/AiduqSum4WZAkv
	 2drNI1z8KPzctZk26A240cMKavRWw5n1bvcpb+UR/9BmpVlAmUdpJeFtJOEBV7I6uh
	 MRtrrs3xH/gvHwDKEh7c/KhaKPhCxs5DvYvpjLZg=
Date: Mon, 17 Feb 2025 18:54:00 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-indicate-whether-it-is-a-hardware-protection-reboot-or-shutdown.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025401.6980EC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: indicate whether it is a HARDWARE PROTECTION reboot or shutdown
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-indicate-whether-it-is-a-hardware-protection-reboot-or-shutdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-indicate-whether-it-is-a-hardware-protection-reboot-or-shutdown.patch

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
Subject: reboot: indicate whether it is a HARDWARE PROTECTION reboot or shutdown
Date: Mon, 17 Feb 2025 21:39:46 +0100

It currently depends on the caller, whether we attempt a hardware
protection shutdown (poweroff) or a reboot.  A follow-up commit will make
this partially user-configurable, so it's a good idea to have the
emergency message clearly state whether the kernel is going for a reboot
or a shutdown.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-6-e1c09b090c0c@pengutronix.de
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

 kernel/reboot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/reboot.c~reboot-indicate-whether-it-is-a-hardware-protection-reboot-or-shutdown
+++ a/kernel/reboot.c
@@ -1027,7 +1027,8 @@ void __hw_protection_trigger(const char
 {
 	static atomic_t allow_proceed = ATOMIC_INIT(1);
 
-	pr_emerg("HARDWARE PROTECTION shutdown (%s)\n", reason);
+	pr_emerg("HARDWARE PROTECTION %s (%s)\n",
+		 hw_protection_action_str(action), reason);
 
 	/* Shutdown should be initiated only once. */
 	if (!atomic_dec_and_test(&allow_proceed))
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

