Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292FA149E17
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847244; cv=none; b=UuYR0pIV8GgRQFxi/E01ejt5tXZGG7XTCxkHPqYJx5Hpj/F3tprBFVRf62kRbJ6RySuJTeuJjC++dHDEBKAJBLLwdagPqMfEnwJLk4+Pr8IKtKe2FNbkG53zB19F4DCbjOr0agdxZlM9DPj+Sn4QiPYuYL520ri+J3pQr3xZbA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847244; c=relaxed/simple;
	bh=I20PWn8S8qGruQhlzNiko/NK5ywo0vQN22dufIQrZBU=;
	h=Date:To:From:Subject:Message-Id; b=R/nrhssCEZFAXdEJK+albV44XhSroUorcnKn0/9X/zjRRHRm3KxZQEEjC1rIIjlNTh7DBdyGDQdOlQ14asaOlLdFGDE37SIni17zAjQTysh1idadgOjx7GJPGdAEMybtoyoLgTOio4IrmE2RzEJ1PZxbjKGsmPy6mg5rWSt1kI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNEXvu+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNEXvu+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5EAC4CEE7;
	Tue, 18 Feb 2025 02:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847243;
	bh=I20PWn8S8qGruQhlzNiko/NK5ywo0vQN22dufIQrZBU=;
	h=Date:To:From:Subject:From;
	b=jNEXvu+Xaf1K1BKdvqYdk9auZJEC5SrDMBJu1JzEsEFuYJnDMfjArdGRjCZLY+o5M
	 LVyMPgLpTUarfZR1CVg8tQ87ui8nk2Mq8cUmgPGWUgEbEOxaudWWVGrRrrkNYBXLRu
	 sYRxKZwFX1YZCfp+Rxwcnznz80woW/2v/kuBbTjY=
Date: Mon, 17 Feb 2025 18:54:03 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-add-support-for-configuring-emergency-hardware-protection-action.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025403.8F5EAC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: add support for configuring emergency hardware protection action
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-add-support-for-configuring-emergency-hardware-protection-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-add-support-for-configuring-emergency-hardware-protection-action.patch

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
Subject: reboot: add support for configuring emergency hardware protection action
Date: Mon, 17 Feb 2025 21:39:47 +0100

We currently leave the decision of whether to shutdown or reboot to
protect hardware in an emergency situation to the individual drivers.

This works out in some cases, where the driver detecting the critical
failure has inside knowledge: It binds to the system management controller
for example or is guided by hardware description that defines what to do.

In the general case, however, the driver detecting the issue can't know
what the appropriate course of action is and shouldn't be dictating the
policy of dealing with it.

Therefore, add a global hw_protection toggle that allows the user to
specify whether shutdown or reboot should be the default action when the
driver doesn't set policy.

This introduces no functional change yet as hw_protection_trigger() has no
callers, but these will be added in subsequent commits.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-7-e1c09b090c0c@pengutronix.de
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

 Documentation/ABI/testing/sysfs-kernel-reboot   |    8 ++
 Documentation/admin-guide/kernel-parameters.txt |    6 +
 include/linux/reboot.h                          |   22 ++++++
 include/uapi/linux/capability.h                 |    1 
 kernel/reboot.c                                 |   46 ++++++++++++++
 5 files changed, 82 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-kernel-reboot~reboot-add-support-for-configuring-emergency-hardware-protection-action
+++ a/Documentation/ABI/testing/sysfs-kernel-reboot
@@ -30,3 +30,11 @@ KernelVersion:	5.11
 Contact:	Matteo Croce <mcroce@microsoft.com>
 Description:	Don't wait for any other CPUs on reboot and
 		avoid anything that could hang.
+
+What:		/sys/kernel/reboot/hw_protection
+Date:		April 2025
+KernelVersion:	6.15
+Contact:	Ahmad Fatoum <a.fatoum@pengutronix.de>
+Description:	Hardware protection action taken on critical events like
+		overtemperature or imminent voltage loss.
+		Valid values are: reboot shutdown
--- a/Documentation/admin-guide/kernel-parameters.txt~reboot-add-support-for-configuring-emergency-hardware-protection-action
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1933,6 +1933,12 @@
 			which allow the hypervisor to 'idle' the guest
 			on lock contention.
 
+	hw_protection=	[HW]
+			Format: reboot | shutdown
+
+			Hardware protection action taken on critical events like
+			overtemperature or imminent voltage loss.
+
 	i2c_bus=	[HW]	Override the default board specific I2C bus speed
 				or register an additional I2C bus that is not
 				registered from board initialization code.
--- a/include/linux/reboot.h~reboot-add-support-for-configuring-emergency-hardware-protection-action
+++ a/include/linux/reboot.h
@@ -181,16 +181,36 @@ extern void orderly_reboot(void);
 /**
  * enum hw_protection_action - Hardware protection action
  *
+ * @HWPROT_ACT_DEFAULT:
+ *      The default action should be taken. This is HWPROT_ACT_SHUTDOWN
+ *      by default, but can be overridden.
  * @HWPROT_ACT_SHUTDOWN:
  *	The system should be shut down (powered off) for HW protection.
  * @HWPROT_ACT_REBOOT:
  *	The system should be rebooted for HW protection.
  */
-enum hw_protection_action { HWPROT_ACT_SHUTDOWN, HWPROT_ACT_REBOOT };
+enum hw_protection_action { HWPROT_ACT_DEFAULT, HWPROT_ACT_SHUTDOWN, HWPROT_ACT_REBOOT };
 
 void __hw_protection_trigger(const char *reason, int ms_until_forced,
 			     enum hw_protection_action action);
 
+/**
+ * hw_protection_trigger - Trigger default emergency system hardware protection action
+ *
+ * @reason:		Reason of emergency shutdown or reboot to be printed.
+ * @ms_until_forced:	Time to wait for orderly shutdown or reboot before
+ *			triggering it. Negative value disables the forced
+ *			shutdown or reboot.
+ *
+ * Initiate an emergency system shutdown or reboot in order to protect
+ * hardware from further damage. The exact action taken is controllable at
+ * runtime and defaults to shutdown.
+ */
+static inline void hw_protection_trigger(const char *reason, int ms_until_forced)
+{
+	__hw_protection_trigger(reason, ms_until_forced, HWPROT_ACT_DEFAULT);
+}
+
 static inline void hw_protection_reboot(const char *reason, int ms_until_forced)
 {
 	__hw_protection_trigger(reason, ms_until_forced, HWPROT_ACT_REBOOT);
--- a/include/uapi/linux/capability.h~reboot-add-support-for-configuring-emergency-hardware-protection-action
+++ a/include/uapi/linux/capability.h
@@ -275,6 +275,7 @@ struct vfs_ns_cap_data {
 /* Allow setting encryption key on loopback filesystem */
 /* Allow setting zone reclaim policy */
 /* Allow everything under CAP_BPF and CAP_PERFMON for backward compatibility */
+/* Allow setting hardware protection emergency action */
 
 #define CAP_SYS_ADMIN        21
 
--- a/kernel/reboot.c~reboot-add-support-for-configuring-emergency-hardware-protection-action
+++ a/kernel/reboot.c
@@ -36,6 +36,8 @@ enum reboot_mode reboot_mode DEFAULT_REB
 EXPORT_SYMBOL_GPL(reboot_mode);
 enum reboot_mode panic_reboot_mode = REBOOT_UNDEFINED;
 
+static enum hw_protection_action hw_protection_action = HWPROT_ACT_SHUTDOWN;
+
 /*
  * This variable is used privately to keep track of whether or not
  * reboot_type is still set to its default value (i.e., reboot= hasn't
@@ -1027,6 +1029,9 @@ void __hw_protection_trigger(const char
 {
 	static atomic_t allow_proceed = ATOMIC_INIT(1);
 
+	if (action == HWPROT_ACT_DEFAULT)
+		action = hw_protection_action;
+
 	pr_emerg("HARDWARE PROTECTION %s (%s)\n",
 		 hw_protection_action_str(action), reason);
 
@@ -1046,6 +1051,46 @@ void __hw_protection_trigger(const char
 }
 EXPORT_SYMBOL_GPL(__hw_protection_trigger);
 
+static bool hw_protection_action_parse(const char *str,
+				       enum hw_protection_action *action)
+{
+	if (sysfs_streq(str, "shutdown"))
+		*action = HWPROT_ACT_SHUTDOWN;
+	else if (sysfs_streq(str, "reboot"))
+		*action = HWPROT_ACT_REBOOT;
+	else
+		return false;
+
+	return true;
+}
+
+static int __init hw_protection_setup(char *str)
+{
+	hw_protection_action_parse(str, &hw_protection_action);
+	return 1;
+}
+__setup("hw_protection=", hw_protection_setup);
+
+static ssize_t hw_protection_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+			  hw_protection_action_str(hw_protection_action));
+}
+static ssize_t hw_protection_store(struct kobject *kobj,
+				   struct kobj_attribute *attr, const char *buf,
+				   size_t count)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!hw_protection_action_parse(buf, &hw_protection_action))
+		return -EINVAL;
+
+	return count;
+}
+static struct kobj_attribute hw_protection_attr = __ATTR_RW(hw_protection);
+
 static int __init reboot_setup(char *str)
 {
 	for (;;) {
@@ -1305,6 +1350,7 @@ static struct kobj_attribute reboot_cpu_
 #endif
 
 static struct attribute *reboot_attrs[] = {
+	&hw_protection_attr.attr,
 	&reboot_mode_attr.attr,
 #ifdef CONFIG_X86
 	&reboot_force_attr.attr,
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

