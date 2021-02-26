Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C20C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D18364F3D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhBZBWh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230049AbhBZBVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4B6B64F36;
        Fri, 26 Feb 2021 01:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302454;
        bh=oyZPH/378uVbvoK8vfByYvO5Iy0eOmnvv+E6tnIpvFs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qrr4ixKVYVeKHg/T1jyXF2cDuKW5s3qgDucbP++3/8FI89XTg5ve2VV6BIiD2/XD0
         ZjyysxyMkOjp1aIojgvNtAFAiR8FYFO/pdd5kkA0DJHS7C9UjszFV5sn4/VgbTQ1e8
         lyhFtdYQBMeVHf58uXpc7jPTzFn9vzU/p6WCA9F8=
Date:   Thu, 25 Feb 2021 17:20:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, linf@wangsu.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 085/118] sysctl.c: fix underflow value setting
 risk in vm_table
Message-ID: <20210226012053.XZUrfpiY2%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lin Feng <linf@wangsu.com>
Subject: sysctl.c: fix underflow value setting risk in vm_table

Apart from subsystem specific .proc_handler handler, all ctl_tables with
extra1 and extra2 members set should use proc_dointvec_minmax instead of
proc_dointvec, or the limit set in extra* never work and potentially echo
underflow values(negative numbers) is likely make system unstable.

Especially vfs_cache_pressure and zone_reclaim_mode, -1 is apparently not
a valid value, but we can set to them.  And then kernel may crash.

# echo -1 > /proc/sys/vm/vfs_cache_pressure

Link: https://lkml.kernel.org/r/20201223105535.2875-1-linf@wangsu.com
Signed-off-by: Lin Feng <linf@wangsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sysctl.c~sysctlc-fix-underflow-value-setting-risk-in-vm_table
+++ a/kernel/sysctl.c
@@ -2962,7 +2962,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
@@ -2970,7 +2970,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 #if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
@@ -2980,7 +2980,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 #endif
@@ -2990,7 +2990,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &node_reclaim_mode,
 		.maxlen		= sizeof(node_reclaim_mode),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
_
