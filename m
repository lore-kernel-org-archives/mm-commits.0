Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B6914B086
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847239; cv=none; b=NXmtQHFtSufium6maPEst4eSSeHc2dPE2IG/GRvNUkkHiQAStg3A3JpVbcieOwPR8Nbw5MdZ5CaE469cGRSTEdIpmTisE8avnvG0QKdMxaMMSaR+e+QbyheAtlixeXBS3RaHM4xB7exwne1V6iAbDhx0rN+Q5FzVoRV+2C5FcHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847239; c=relaxed/simple;
	bh=0+pfRKzgisYUyQM9Ru2W8xenrbl8ms17D52mQb/m4/Q=;
	h=Date:To:From:Subject:Message-Id; b=sqCRkDg0SqNb5HSqL8QNZBVmA6bGI6gLLGu/5mu58dARX4b4oMRWxd8OvhJmbWFI3QjhW5kH21ZSp7d9KO9tN1RUgMqPVgE6qUovKKo2O3bJ6qqoPADrLp4PEaz+WyK/01vBl1gnZxlS5HIb3KqNjD3j1NfNcXBYc/CXVJzNGm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S1GsALTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S1GsALTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0139FC4CED1;
	Tue, 18 Feb 2025 02:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847239;
	bh=0+pfRKzgisYUyQM9Ru2W8xenrbl8ms17D52mQb/m4/Q=;
	h=Date:To:From:Subject:From;
	b=S1GsALTjSNDZUj5CYGMgZU1NBZ/cv/kJ6IOHCd21V9IWz+w2RuOxTue0h6RfRkIpb
	 XDcCAxne30jx8txSkNUq4VML3JAD1h4nffSuzxz706dn04OFrOSBb3Sb4HT0sAjPfz
	 AEIGEu60s4wII3kQky3YkQJj5GQwNFUPBMD+VA/c=
Date: Mon, 17 Feb 2025 18:53:58 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-rename-now-misleading-__hw_protection_shutdown-symbols.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025359.0139FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: rename now misleading __hw_protection_shutdown symbols
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-rename-now-misleading-__hw_protection_shutdown-symbols.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-rename-now-misleading-__hw_protection_shutdown-symbols.patch

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

