Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05745C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF74B233EB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgLPRMG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgLPRMG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:06 -0500
Date:   Wed, 16 Dec 2020 09:11:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138710;
        bh=Xu7G1vnKcnzs1h+0OgVB2QlavjZR1udSiiB3LD5alLU=;
        h=From:To:Subject:From;
        b=AiWZXDCijD1X+A5/Dp/h/ao03Dvh9B0XGUVuoOLL48l4A5RjYsllwYaSOpOdgFZT6
         8zq89aoVJUYsukuF/ht0PCRX2n4AtiTXk6D6+2OC+mWurspXLhPSL5XVE1a+Ul+xL2
         v1640tIQRx/+SrGpiJtt32/hEEAXJReU36GruW7U=
From:   akpm@linux-foundation.org
To:     mcroce@microsoft.com, mm-commits@vger.kernel.org, pmladek@suse.com
Subject:  [merged]
 reboot-allow-to-override-reboot-type-if-quirks-are-found.patch removed from
 -mm tree
Message-ID: <20201216171150.c-DtWf0uG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: allow to override reboot type if quirks are found
has been removed from the -mm tree.  Its filename was
     reboot-allow-to-override-reboot-type-if-quirks-are-found.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matteo Croce <mcroce@microsoft.com>
Subject: reboot: allow to override reboot type if quirks are found

Patch series "reboot: sysfs improvements".

Some improvements to the sysfs reboot interface: hide not working settings
and support machines with known reboot quirks.


This patch (of 2):

On some machines a quirk can force a specific reboot type.  Quirks are
found during a DMI scan, the list of machines which need special reboot
handling is defined in reboot_dmi_table.

The kernel command line reboot= option overrides this via a global
variable `reboot_default`, so that the reboot type requested in the
command line is really performed.

This was not true when setting the reboot type via the new sysfs
interface.  Fix this by setting reboot_default upon the first change, like
reboot_setup() does for the command line.

Link: https://lkml.kernel.org/r/20201130173717.198952-1-mcroce@linux.microsoft.com
Link: https://lkml.kernel.org/r/20201130173717.198952-2-mcroce@linux.microsoft.com
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/reboot.c~reboot-allow-to-override-reboot-type-if-quirks-are-found
+++ a/kernel/reboot.c
@@ -662,6 +662,8 @@ static ssize_t mode_store(struct kobject
 	else
 		return -EINVAL;
 
+	reboot_default = 0;
+
 	return count;
 }
 static struct kobj_attribute reboot_mode_attr = __ATTR_RW(mode);
@@ -716,6 +718,8 @@ static ssize_t type_store(struct kobject
 	else
 		return -EINVAL;
 
+	reboot_default = 0;
+
 	return count;
 }
 static struct kobj_attribute reboot_type_attr = __ATTR_RW(type);
@@ -741,6 +745,7 @@ static ssize_t cpu_store(struct kobject
 	if (cpunum >= num_possible_cpus())
 		return -ERANGE;
 
+	reboot_default = 0;
 	reboot_cpu = cpunum;
 
 	return count;
@@ -762,6 +767,7 @@ static ssize_t force_store(struct kobjec
 	if (kstrtobool(buf, &res))
 		return -EINVAL;
 
+	reboot_default = 0;
 	reboot_force = res;
 
 	return count;
_

Patches currently in -mm which might be from mcroce@microsoft.com are


