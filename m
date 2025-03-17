Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65767218EA7
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189520; cv=none; b=KEf1Le3E+v1SDkd+1X/gJ6776HVjDmvL9pQD8Ia18XXMLeSo4yYe1m6f82Y0OpLYjA5EjsA81bm8V5xwH9t+nxUghiNRZ9elgHsMk1EWrDFfIs8bk1XDNSA0TaDkSd83iyQZeXIn49LfRv6T4nEtLsbasRK+5uvJmTtizbJ9Dxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189520; c=relaxed/simple;
	bh=PkLIFh1Pkj8bn2egevwMtQ9fCHZLjvz3iRoN6u9+eCs=;
	h=Date:To:From:Subject:Message-Id; b=eCo5DaA3ROPJMh7dQgtvAy5EAtZ1MOA3lKFfR+yMqH+t9GE4TUhKcSQStmAchnIojWoKtGfSdQO9FAnZ7zP3H+MWVGoVdprBUiM40ZBDWq7nLojkLKi80h7n6aQe0w1hASYu/xTF7JBeGer8D2TK/apXJO2+ueSehX+atpT+x1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SWDKk4SD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SWDKk4SD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A8EC4CEEC;
	Mon, 17 Mar 2025 05:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189520;
	bh=PkLIFh1Pkj8bn2egevwMtQ9fCHZLjvz3iRoN6u9+eCs=;
	h=Date:To:From:Subject:From;
	b=SWDKk4SDHNIL0b9ULFGATtl1vs/8Ga7iNUl8OvKGpYF4l8zLQL8A2GpqK4JBzfVIN
	 5BCWJJehfZbM9fwtBMC2iLY7NnIIkV8VMSJMRPMgHl6Vl/y8NL4mHVlTiTv3BrDV43
	 bI67It5TEyjw8lqrUAx5F115mYzg8wEcd5l8/xUM=
Date: Sun, 16 Mar 2025 22:31:59 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] reboot-rename-now-misleading-__hw_protection_shutdown-symbols.patch removed from -mm tree
Message-Id: <20250317053200.38A8EC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: reboot: rename now misleading __hw_protection_shutdown symbols
has been removed from the -mm tree.  Its filename was
     reboot-rename-now-misleading-__hw_protection_shutdown-symbols.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: reboot: rename now misleading __hw_protection_shutdown symbols
Date: Mon, 17 Feb 2025 21:39:45 +0100

The __hw_protection_shutdown function name has become misleading since it
can cause either a shutdown (poweroff) or a reboot depending on its
argument.

To avoid further confusion, let's rename it, so it doesn't suggest that a
poweroff is all it can do.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-5-e1c09b090c0c@pengutronix.de
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

 include/linux/reboot.h |    8 ++++----
 kernel/reboot.c        |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/reboot.h~reboot-rename-now-misleading-__hw_protection_shutdown-symbols
+++ a/include/linux/reboot.h
@@ -188,17 +188,17 @@ extern void orderly_reboot(void);
  */
 enum hw_protection_action { HWPROT_ACT_SHUTDOWN, HWPROT_ACT_REBOOT };
 
-void __hw_protection_shutdown(const char *reason, int ms_until_forced,
-			      enum hw_protection_action action);
+void __hw_protection_trigger(const char *reason, int ms_until_forced,
+			     enum hw_protection_action action);
 
 static inline void hw_protection_reboot(const char *reason, int ms_until_forced)
 {
-	__hw_protection_shutdown(reason, ms_until_forced, HWPROT_ACT_REBOOT);
+	__hw_protection_trigger(reason, ms_until_forced, HWPROT_ACT_REBOOT);
 }
 
 static inline void hw_protection_shutdown(const char *reason, int ms_until_forced)
 {
-	__hw_protection_shutdown(reason, ms_until_forced, HWPROT_ACT_SHUTDOWN);
+	__hw_protection_trigger(reason, ms_until_forced, HWPROT_ACT_SHUTDOWN);
 }
 
 /*
--- a/kernel/reboot.c~reboot-rename-now-misleading-__hw_protection_shutdown-symbols
+++ a/kernel/reboot.c
@@ -1008,7 +1008,7 @@ static void hw_failure_emergency_schedul
 }
 
 /**
- * __hw_protection_shutdown - Trigger an emergency system shutdown or reboot
+ * __hw_protection_trigger - Trigger an emergency system shutdown or reboot
  *
  * @reason:		Reason of emergency shutdown or reboot to be printed.
  * @ms_until_forced:	Time to wait for orderly shutdown or reboot before
@@ -1022,8 +1022,8 @@ static void hw_failure_emergency_schedul
  * pending even if the previous request has given a large timeout for forced
  * shutdown/reboot.
  */
-void __hw_protection_shutdown(const char *reason, int ms_until_forced,
-			      enum hw_protection_action action)
+void __hw_protection_trigger(const char *reason, int ms_until_forced,
+			     enum hw_protection_action action)
 {
 	static atomic_t allow_proceed = ATOMIC_INIT(1);
 
@@ -1043,7 +1043,7 @@ void __hw_protection_shutdown(const char
 	else
 		orderly_poweroff(true);
 }
-EXPORT_SYMBOL_GPL(__hw_protection_shutdown);
+EXPORT_SYMBOL_GPL(__hw_protection_trigger);
 
 static int __init reboot_setup(char *str)
 {
_

Patches currently in -mm which might be from a.fatoum@pengutronix.de are


