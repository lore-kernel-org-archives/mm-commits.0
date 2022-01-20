Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDFCC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377850AbiATV0Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347699AbiATV0W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2299C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:26:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA23AB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DF2C340E0;
        Thu, 20 Jan 2022 21:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713979;
        bh=wO0jj6UettgnTohjbmc3Pj78ntdGrQe5wALFK7sadG8=;
        h=Date:From:To:Subject:From;
        b=Ifk8LPxX849dBhASqr4Ul8jW0ga136Ph0COfIBexLmk+HSHfnAt5EzgutZHjkEHyH
         XdC0vYTeyIiGwc327QHoeOg4VoQFBbMPsX8fBd6wC5KEC9iXhKFBuFq+iVpNFe9znl
         +zGP/vdH0U8RwjuD4BD7AEgfBYzMvt8hF5dYhz2M=
Date:   Thu, 20 Jan 2022 13:26:18 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, crope@iki.fi, dave.hansen@linux.intel.com,
        hannes@cmpxchg.org, keescook@chromium.org, kernel@tuxforce.de,
        mcgrof@kernel.org, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, rppt@kernel.org, surenb@google.com,
        vbabka@suse.cz, xi.fengfei@h3c.com, yi.zhang@huawei.com,
        yzaikin@google.com
Subject:  [merged]
 sysctl-change-watermark_scale_factor-max-limit-to-30%.patch removed from
 -mm tree
Message-ID: <20220120212618.GPbcXHM4Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagealloc: sysctl: change watermark_scale_factor max limit to 30%
has been removed from the -mm tree.  Its filename was
     sysctl-change-watermark_scale_factor-max-limit-to-30%.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/pagealloc: sysctl: change watermark_scale_factor max limit to 30%

For embedded systems with low total memory, having to run applications
with relatively large memory requirements, 10% max limitation for
watermark_scale_factor poses an issue of triggering direct reclaim every
time such application is started.  This results in slow application
startup times and bad end-user experience.

By increasing watermark_scale_factor max limit we allow vendors more
flexibility to choose the right level of kswapd aggressiveness for their
device and workload requirements.

Link: https://lkml.kernel.org/r/20211124193604.2758863-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Fengfei Xi <xi.fengfei@h3c.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    2 +-
 kernel/sysctl.c                         |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~sysctl-change-watermark_scale_factor-max-limit-to-30%
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -948,7 +948,7 @@ how much memory needs to be free before
 
 The unit is in fractions of 10,000. The default value of 10 means the
 distances between watermarks are 0.1% of the available memory in the
-node/system. The maximum value is 1000, or 10% of memory.
+node/system. The maximum value is 3000, or 30% of memory.
 
 A high rate of threads entering direct reclaim (allocstall) or kswapd
 going to sleep prematurely (kswapd_low_wmark_hit_quickly) can indicate
--- a/kernel/sysctl.c~sysctl-change-watermark_scale_factor-max-limit-to-30%
+++ a/kernel/sysctl.c
@@ -122,6 +122,7 @@ static unsigned long long_max = LONG_MAX
 static int one_hundred = 100;
 static int two_hundred = 200;
 static int one_thousand = 1000;
+static int three_thousand = 3000;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
 #endif
@@ -2959,7 +2960,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= watermark_scale_factor_sysctl_handler,
 		.extra1		= SYSCTL_ONE,
-		.extra2		= &one_thousand,
+		.extra2		= &three_thousand,
 	},
 	{
 		.procname	= "percpu_pagelist_high_fraction",
_

Patches currently in -mm which might be from surenb@google.com are


