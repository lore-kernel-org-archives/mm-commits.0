Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B26C2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E487223355
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgLPErX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPErX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:23 -0500
Date:   Tue, 15 Dec 2020 20:47:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094028;
        bh=3OZFxDB5ln04JrvsDPVHJbs+kOSzR8FGT81jju8Rmmg=;
        h=From:To:Subject:In-Reply-To:From;
        b=C4AK8nIyr+lhcXWkWTlfnMxNoErLNmifKYzx8qBc+J4kI0FvWr7Yw30IACjL44Jym
         A9RltwoiAVuWy9e59BcqcygalTNiQFuEPrpKfz3KrmISWnEIVimsBaxjT+nBTUy3sq
         cJRa2aSKNo+YQg0tGrcTD13OOR+CPQYEmJs/dyBU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mcroce@microsoft.com, mm-commits@vger.kernel.org, pmladek@suse.com,
        torvalds@linux-foundation.org
Subject:  [patch 87/95] reboot: hide from sysfs not applicable
 settings
Message-ID: <20201216044707.FGhzp4lH4%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   54 ++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

--- a/kernel/reboot.c~reboot-hide-from-sysfs-not-applicable-settings
+++ a/kernel/reboot.c
@@ -668,6 +668,29 @@ static ssize_t mode_store(struct kobject
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
@@ -723,7 +746,9 @@ static ssize_t type_store(struct kobject
 	return count;
 }
 static struct kobj_attribute reboot_type_attr = __ATTR_RW(type);
+#endif
 
+#ifdef CONFIG_SMP
 static ssize_t cpu_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%d\n", reboot_cpu);
@@ -751,34 +776,17 @@ static ssize_t cpu_store(struct kobject
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
