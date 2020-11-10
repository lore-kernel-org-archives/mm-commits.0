Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FE2C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F7542074B
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIZkRHPd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgKJVIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 16:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJVIM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 16:08:12 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DD67206D8;
        Tue, 10 Nov 2020 21:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605042490;
        bh=nFkb+1rgMKdIqVQ66m5ufGVNWa45KbiiMt/0XBmW0aI=;
        h=Date:From:To:Subject:From;
        b=UIZkRHPda61sDDjCfPyrppXEbF3lRf6sOGkHiS/tFGYsGgeHuSWLKQQkCHnf5+X49
         3ikSGdlY3vHMCniL4O6/Ij4JvryP0gokHCZlx10iveDEt4QE3RW24AbK14xwcp/9cv
         lLFAFfOW4e2/Lehi+xzddXXWX+TeO1kxRhew+JDY=
Date:   Tue, 10 Nov 2020 13:08:09 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, keescook@chromium.org, linux@roeck-us.net,
        mcroce@microsoft.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, pmladek@suse.com, rppt@kernel.org,
        tyhicks@linux.microsoft.com
Subject:  + reboot-allow-to-specify-reboot-mode-via-sysfs.patch
 added to -mm tree
Message-ID: <20201110210809.wa0u0gm_C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: allow to specify reboot mode via sysfs
has been added to the -mm tree.  Its filename is
     reboot-allow-to-specify-reboot-mode-via-sysfs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/reboot-allow-to-specify-reboot-mode-via-sysfs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/reboot-allow-to-specify-reboot-mode-via-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matteo Croce <mcroce@microsoft.com>
Subject: reboot: allow to specify reboot mode via sysfs

The kernel cmdline reboot= option offers some sort of control on how the
reboot is issued.  Add handles in sysfs to allow setting these reboot
options, so they can be changed when the system is booted, other than at
boot time.

The handlers are under <sysfs>/kernel/reboot, can be read to get the
current configuration and written to alter it.

	# cd /sys/kernel/reboot/

	# grep . *
	cpu:0
	force:0
	mode:cold
	type:acpi

	# echo 2 >cpu
	# echo yes >force
	# echo soft >mode
	# echo bios >type

	# grep . *
	cpu:2
	force:1
	mode:soft
	type:bios

Before setting anything, check for CAP_SYS_BOOT capability, so it's
possible to allow an unpriviledged process to change these settings simply
by relaxing the handles permissions, without opening them to the world.

Link: https://lkml.kernel.org/r/20201110202746.9690-1-mcroce@linux.microsoft.com
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-reboot |   32 ++
 kernel/reboot.c                               |  206 ++++++++++++++++
 2 files changed, 238 insertions(+)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-reboot
@@ -0,0 +1,32 @@
+What:		/sys/kernel/reboot
+Date:		November 2020
+KernelVersion:	5.11
+Contact:	Matteo Croce <mcroce@microsoft.com>
+Description:	Interface to set the kernel reboot behavior, similarly to
+		what can be done via the reboot= cmdline option.
+		(see Documentation/admin-guide/kernel-parameters.txt)
+
+What:		/sys/kernel/reboot/mode
+Date:		November 2020
+KernelVersion:	5.11
+Contact:	Matteo Croce <mcroce@microsoft.com>
+Description:	Reboot mode. Valid values are: cold warm hard soft gpio
+
+What:		/sys/kernel/reboot/type
+Date:		November 2020
+KernelVersion:	5.11
+Contact:	Matteo Croce <mcroce@microsoft.com>
+Description:	Reboot type. Valid values are: bios acpi kbd triple efi pci
+
+What:		/sys/kernel/reboot/cpu
+Date:		November 2020
+KernelVersion:	5.11
+Contact:	Matteo Croce <mcroce@microsoft.com>
+Description:	CPU number to use to reboot.
+
+What:		/sys/kernel/reboot/force
+Date:		November 2020
+KernelVersion:	5.11
+Contact:	Matteo Croce <mcroce@microsoft.com>
+Description:	Don't wait for any other CPUs on reboot and
+		avoid anything that could hang.
--- a/kernel/reboot.c~reboot-allow-to-specify-reboot-mode-via-sysfs
+++ a/kernel/reboot.c
@@ -598,3 +598,209 @@ static int __init reboot_setup(char *str
 	return 1;
 }
 __setup("reboot=", reboot_setup);
+
+#ifdef CONFIG_SYSFS
+
+#define REBOOT_COLD_STR		"cold"
+#define REBOOT_WARM_STR		"warm"
+#define REBOOT_HARD_STR		"hard"
+#define REBOOT_SOFT_STR		"soft"
+#define REBOOT_GPIO_STR		"gpio"
+#define REBOOT_UNDEFINED_STR	"undefined"
+
+#define BOOT_TRIPLE_STR		"triple"
+#define BOOT_KBD_STR		"kbd"
+#define BOOT_BIOS_STR		"bios"
+#define BOOT_ACPI_STR		"acpi"
+#define BOOT_EFI_STR		"efi"
+#define BOOT_CF9_FORCE_STR	"cf9_force"
+#define BOOT_CF9_SAFE_STR	"cf9_safe"
+
+static ssize_t mode_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	const char *val;
+
+	switch (reboot_mode) {
+	case REBOOT_COLD:
+		val = REBOOT_COLD_STR;
+		break;
+	case REBOOT_WARM:
+		val = REBOOT_WARM_STR;
+		break;
+	case REBOOT_HARD:
+		val = REBOOT_HARD_STR;
+		break;
+	case REBOOT_SOFT:
+		val = REBOOT_SOFT_STR;
+		break;
+	case REBOOT_GPIO:
+		val = REBOOT_GPIO_STR;
+		break;
+	default:
+		val = REBOOT_UNDEFINED_STR;
+	}
+
+	return sprintf(buf, "%s\n", val);
+}
+static ssize_t mode_store(struct kobject *kobj, struct kobj_attribute *attr,
+			  const char *buf, size_t count)
+{
+	if (!capable(CAP_SYS_BOOT))
+		return -EPERM;
+
+	if (!strncmp(buf, REBOOT_COLD_STR, strlen(REBOOT_COLD_STR)))
+		reboot_mode = REBOOT_COLD;
+	else if (!strncmp(buf, REBOOT_WARM_STR, strlen(REBOOT_WARM_STR)))
+		reboot_mode = REBOOT_WARM;
+	else if (!strncmp(buf, REBOOT_HARD_STR, strlen(REBOOT_HARD_STR)))
+		reboot_mode = REBOOT_HARD;
+	else if (!strncmp(buf, REBOOT_SOFT_STR, strlen(REBOOT_SOFT_STR)))
+		reboot_mode = REBOOT_SOFT;
+	else if (!strncmp(buf, REBOOT_GPIO_STR, strlen(REBOOT_GPIO_STR)))
+		reboot_mode = REBOOT_GPIO;
+	else
+		return -EINVAL;
+
+	return count;
+}
+static struct kobj_attribute reboot_mode_attr = __ATTR_RW(mode);
+
+static ssize_t type_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	const char *val;
+
+	switch (reboot_type) {
+	case BOOT_TRIPLE:
+		val = BOOT_TRIPLE_STR;
+		break;
+	case BOOT_KBD:
+		val = BOOT_KBD_STR;
+		break;
+	case BOOT_BIOS:
+		val = BOOT_BIOS_STR;
+		break;
+	case BOOT_ACPI:
+		val = BOOT_ACPI_STR;
+		break;
+	case BOOT_EFI:
+		val = BOOT_EFI_STR;
+		break;
+	case BOOT_CF9_FORCE:
+		val = BOOT_CF9_FORCE_STR;
+		break;
+	case BOOT_CF9_SAFE:
+		val = BOOT_CF9_SAFE_STR;
+		break;
+	default:
+		val = REBOOT_UNDEFINED_STR;
+	}
+
+	return sprintf(buf, "%s\n", val);
+}
+static ssize_t type_store(struct kobject *kobj, struct kobj_attribute *attr,
+			  const char *buf, size_t count)
+{
+	if (!capable(CAP_SYS_BOOT))
+		return -EPERM;
+
+	if (!strncmp(buf, BOOT_TRIPLE_STR, strlen(BOOT_TRIPLE_STR)))
+		reboot_mode = BOOT_TRIPLE;
+	else if (!strncmp(buf, BOOT_KBD_STR, strlen(BOOT_KBD_STR)))
+		reboot_mode = BOOT_KBD;
+	else if (!strncmp(buf, BOOT_BIOS_STR, strlen(BOOT_BIOS_STR)))
+		reboot_mode = BOOT_BIOS;
+	else if (!strncmp(buf, BOOT_ACPI_STR, strlen(BOOT_ACPI_STR)))
+		reboot_mode = BOOT_ACPI;
+	else if (!strncmp(buf, BOOT_EFI_STR, strlen(BOOT_EFI_STR)))
+		reboot_mode = BOOT_EFI;
+	else if (!strncmp(buf, BOOT_CF9_FORCE_STR, strlen(BOOT_CF9_FORCE_STR)))
+		reboot_mode = BOOT_CF9_FORCE;
+	else if (!strncmp(buf, BOOT_CF9_SAFE_STR, strlen(BOOT_CF9_SAFE_STR)))
+		reboot_mode = BOOT_CF9_SAFE;
+	else
+		return -EINVAL;
+
+	return count;
+}
+static struct kobj_attribute reboot_type_attr = __ATTR_RW(type);
+
+static ssize_t cpu_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", reboot_cpu);
+}
+static ssize_t cpu_store(struct kobject *kobj, struct kobj_attribute *attr,
+			  const char *buf, size_t count)
+{
+	unsigned int cpunum;
+	int rc;
+
+	if (!capable(CAP_SYS_BOOT))
+		return -EPERM;
+
+	rc = kstrtouint(buf, 0, &cpunum);
+
+	if (rc)
+		return rc;
+
+	if (cpunum >= num_possible_cpus())
+		return -ERANGE;
+
+	reboot_cpu = cpunum;
+
+	return count;
+}
+static struct kobj_attribute reboot_cpu_attr = __ATTR_RW(cpu);
+
+static ssize_t force_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", reboot_force);
+}
+static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
+			  const char *buf, size_t count)
+{
+	bool res;
+
+	if (!capable(CAP_SYS_BOOT))
+		return -EPERM;
+
+	if (kstrtobool(buf, &res))
+		return -EINVAL;
+
+	reboot_force = res;
+
+	return count;
+}
+static struct kobj_attribute reboot_force_attr = __ATTR_RW(force);
+
+static struct attribute *reboot_attrs[] = {
+	&reboot_mode_attr.attr,
+	&reboot_type_attr.attr,
+	&reboot_cpu_attr.attr,
+	&reboot_force_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group reboot_attr_group = {
+	.attrs = reboot_attrs,
+};
+
+static int __init reboot_ksysfs_init(void)
+{
+	struct kobject *reboot_kobj;
+	int ret;
+
+	reboot_kobj = kobject_create_and_add("reboot", kernel_kobj);
+	if (!reboot_kobj)
+		return -ENOMEM;
+
+	ret = sysfs_create_group(reboot_kobj, &reboot_attr_group);
+	if (ret) {
+		kobject_put(reboot_kobj);
+		return ret;
+	}
+
+	return 0;
+}
+late_initcall(reboot_ksysfs_init);
+
+#endif
_

Patches currently in -mm which might be from mcroce@microsoft.com are

revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
reboot-fix-overflow-parsing-reboot-cpu-number.patch
reboot-refactor-and-comment-the-cpu-selection-code.patch
reboot-allow-to-specify-reboot-mode-via-sysfs.patch

