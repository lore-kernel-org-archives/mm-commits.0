Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177D3218EAB
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189522; cv=none; b=S+Eoj3oNuzZ9f2o2YOfsAkCyMqzDL2lD4Gc0qhTnKXsRjs8G+ksHzmisZ7wVSJC2pJrLHmD1rl42UlvwMThPjxmY6Dt24feiZLaTByJjZ7dswFjSxu37vFddSkNOSpjYxkoM/MJ35h+7jOKgsWz+COcip6hb7ruTlS7HKlZ42No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189522; c=relaxed/simple;
	bh=9xQlaRHDj9R2im0Dc4efMQomJ0AjrfWTFIFd4fzfSWY=;
	h=Date:To:From:Subject:Message-Id; b=nWjZQadnouvMTYszWtMPoobHpq2icfSrCiG+VGCaFumB1pUVi8q2VmzNIs8m0oL+U+AeTlnpyGAvsxoarmaRxx1nPbtGkrhwJDgJQsd13fFkh2UVMOoQ1zdOFyRD4OaGYRADdvlN21nZx5fVilobY/3eBDoyrXv6mEbcC0z1Rhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rxFYwK7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rxFYwK7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79906C4CEEC;
	Mon, 17 Mar 2025 05:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189521;
	bh=9xQlaRHDj9R2im0Dc4efMQomJ0AjrfWTFIFd4fzfSWY=;
	h=Date:To:From:Subject:From;
	b=rxFYwK7OHN/N2Sh64X0Tb7xVFgkhFlhz7UtQwFz7nMBa+0RXJRxyk93jx/j9LE7sU
	 MkVP0d1jDkBg7g0XofPo6PppFuoGaOtwPlI3V9tPdMKbp0DHEWynXjariOt9N0i+RQ
	 RccoOQ8zrR5KHzLjNgrKkHZuRtyWEBhwfM6wYOhQ=
Date: Sun, 16 Mar 2025 22:32:00 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] reboot-indicate-whether-it-is-a-hardware-protection-reboot-or-shutdown.patch removed from -mm tree
Message-Id: <20250317053201.79906C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: reboot: indicate whether it is a HARDWARE PROTECTION reboot or shutdown
has been removed from the -mm tree.  Its filename was
     reboot-indicate-whether-it-is-a-hardware-protection-reboot-or-shutdown.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


