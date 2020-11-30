Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22E7C63777
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 21:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A44220674
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 21:09:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fmm7dBfd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgK3VJX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 16:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbgK3VJX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Nov 2020 16:09:23 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA622076A;
        Mon, 30 Nov 2020 21:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606770522;
        bh=UhbCWahUp4xo+UVlINscSydM23kZvSImQn1QnKBuiPI=;
        h=Date:From:To:Subject:From;
        b=Fmm7dBfdguVbmNfi1TyLO5KN0RkY+TWN5PnjKjxQDFPVy2lbwV2k0iSFYnsDGCpAc
         MwzmIeQDlTnhpJyeHh/sGT968V7mFDjPiBqm9Za60stqBBncA0fl9B71lFKID1pDzT
         7FD4N3KupVS8U5ttwDGm8hXdDlIVJJ6L2ypyxj1c=
Date:   Mon, 30 Nov 2020 13:08:41 -0800
From:   akpm@linux-foundation.org
To:     mcroce@microsoft.com, mm-commits@vger.kernel.org, pmladek@suse.com
Subject:  + reboot-hide-from-sysfs-not-applicable-settings.patch
 added to -mm tree
Message-ID: <20201130210841.OuhTrq02z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: hide from sysfs not applicable settings
has been added to the -mm tree.  Its filename is
     reboot-hide-from-sysfs-not-applicable-settings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/reboot-hide-from-sysfs-not-applicable-settings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/reboot-hide-from-sysfs-not-applicable-settings.patch

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
Subject: reboot: hide from sysfs not applicable settings

Not all the reboot settings from both the kernel command line or sysfs
interface are available to all platforms.

Filter out reboot_type and reboot_force which are x86 only, and also
remove reboot_cpu on kernels without SMP support.

This saves some space, and avoid confusing the user with settings which
will have no effect.

Link: https://lkml.kernel.org/r/20201130173717.198952-3-mcroce@linux.microsoft.com
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   54 ++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

--- a/kernel/reboot.c~reboot-hide-from-sysfs-not-applicable-settings
+++ a/kernel/reboot.c
@@ -666,6 +666,29 @@ static ssize_t mode_store(struct kobject
 }
 static struct kobj_attribute reboot_mode_attr = __ATTR_RW(mode);
 
+#ifdef CONFIG_X86
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
+	reboot_default = 0;
+	reboot_force = res;
+
+	return count;
+}
+static struct kobj_attribute reboot_force_attr = __ATTR_RW(force);
+
 static ssize_t type_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	const char *val;
@@ -721,7 +744,9 @@ static ssize_t type_store(struct kobject
 	return count;
 }
 static struct kobj_attribute reboot_type_attr = __ATTR_RW(type);
+#endif
 
+#ifdef CONFIG_SMP
 static ssize_t cpu_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%d\n", reboot_cpu);
@@ -749,34 +774,17 @@ static ssize_t cpu_store(struct kobject
 	return count;
 }
 static struct kobj_attribute reboot_cpu_attr = __ATTR_RW(cpu);
-
-static ssize_t force_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%d\n", reboot_force);
-}
-static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
-			  const char *buf, size_t count)
-{
-	bool res;
-
-	if (!capable(CAP_SYS_BOOT))
-		return -EPERM;
-
-	if (kstrtobool(buf, &res))
-		return -EINVAL;
-
-	reboot_default = 0;
-	reboot_force = res;
-
-	return count;
-}
-static struct kobj_attribute reboot_force_attr = __ATTR_RW(force);
+#endif
 
 static struct attribute *reboot_attrs[] = {
 	&reboot_mode_attr.attr,
+#ifdef CONFIG_X86
+	&reboot_force_attr.attr,
 	&reboot_type_attr.attr,
+#endif
+#ifdef CONFIG_SMP
 	&reboot_cpu_attr.attr,
-	&reboot_force_attr.attr,
+#endif
 	NULL,
 };
 
_

Patches currently in -mm which might be from mcroce@microsoft.com are

reboot-refactor-and-comment-the-cpu-selection-code.patch
reboot-allow-to-specify-reboot-mode-via-sysfs.patch
reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch
reboot-allow-to-override-reboot-type-if-quirks-are-found.patch
reboot-hide-from-sysfs-not-applicable-settings.patch

