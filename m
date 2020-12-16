Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1912C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 856942313B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgLPErp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgLPErp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:45 -0500
Date:   Tue, 15 Dec 2020 20:47:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094024;
        bh=5kN3OZnU4pcthwYVmgnzQX1BKNbruHBO9k1h3LNYzgI=;
        h=From:To:Subject:In-Reply-To:From;
        b=M9wCZyqjrgICArEMLMR8bo67pzUNejgVrFqGO1Di/9+lPcfb3c6DkGMePZ7P0GfyS
         Dz9n4DDFrtqKvd5dXNDHk5W5jTQe4tebt0ju9w6cMzvsdmGzRXBh42fEIHzpYJCLaT
         mPYGb6H+b1+wkbfDQjRRucqoNOksBV4NaV7gm01s=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mcroce@microsoft.com, mm-commits@vger.kernel.org, pmladek@suse.com,
        torvalds@linux-foundation.org
Subject:  [patch 86/95] reboot: allow to override reboot type if
 quirks are found
Message-ID: <20201216044704.nKpPeHcLz%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
