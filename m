Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9733C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiANWHV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59538 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiANWHV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FECBB82630
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F13C36AE5;
        Fri, 14 Jan 2022 22:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198039;
        bh=tDLobOzau0oLIqILsdj8C88xEKH5BlBa+zweQA20Hdo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XLun85IaBvyCf0H/FHqSejGKIpmNBsqyXaD/wel/3F4CSpp/0eC9yxw/1a0veuZjn
         8OkqfZ+gvH0D56kcFGloHKhLaOPLkkFtPtkiMxpVHRK2kLLimeQRXhVO/wIoTtclVZ
         1oDGWuKORyynJD3kf7EieaxhTZx5m9qIsN04AcOI=
Date:   Fri, 14 Jan 2022 14:07:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, crope@iki.fi,
        dave.hansen@linux.intel.com, hannes@cmpxchg.org,
        keescook@chromium.org, kernel@tuxforce.de, linux-mm@kvack.org,
        mcgrof@kernel.org, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, rppt@kernel.org, surenb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, xi.fengfei@h3c.com,
        yi.zhang@huawei.com, yzaikin@google.com
Subject:  [patch 079/146] mm/pagealloc: sysctl: change
 watermark_scale_factor max limit to 30%
Message-ID: <20220114220717.gRYVbnFKZ%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
