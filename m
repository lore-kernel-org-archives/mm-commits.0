Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D53C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243473AbhKXVPv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:15:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235268AbhKXVPv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:15:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE2C76101C;
        Wed, 24 Nov 2021 21:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637788361;
        bh=pHeDXOWyo4gW57CD/PtEQ3DU/igP3XMLn4qVJCw7MTw=;
        h=Date:From:To:Subject:From;
        b=RvLoo92Z8DRugJb6TCp5rg6lY71h0wLRtxHxKzSGcQQ68BN/nqGc3Sywz0amGnuiZ
         TBuV+9LNSmZkXV8l1W3ewdLgJr5bCzP6Isd/7qiyDfWHztkH3FeOSHDfI0tSJnd6OB
         V5NECxr9p8UI1XT/BDb0qA67Py4/U6fxNwv2lJDU=
Date:   Wed, 24 Nov 2021 13:12:40 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, crope@iki.fi, dave.hansen@linux.intel.com,
        hannes@cmpxchg.org, keescook@chromium.org, kernel@tuxforce.de,
        mcgrof@kernel.org, mchehab@kernel.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, rppt@kernel.org,
        surenb@google.com, vbabka@suse.cz, xi.fengfei@h3c.com,
        yi.zhang@huawei.com, yzaikin@google.com
Subject:  +
 sysctl-change-watermark_scale_factor-max-limit-to-30%.patch added to -mm
 tree
Message-ID: <20211124211240.TypSzpEuv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagealloc: sysctl: change watermark_scale_factor max limit to 30%
has been added to the -mm tree.  Its filename is
     sysctl-change-watermark_scale_factor-max-limit-to-30%.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-change-watermark_scale_factor-max-limit-to-30%25.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-change-watermark_scale_factor-max-limit-to-30%25.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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

mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
mm-add-anonymous-vma-name-refcounting.patch
sysctl-change-watermark_scale_factor-max-limit-to-30%.patch

