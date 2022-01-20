Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6593C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377904AbiATV3N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59238 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377902AbiATV3N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC05BB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D47C340E0;
        Thu, 20 Jan 2022 21:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714150;
        bh=RjZYLohMGeRQ/T4fTPG3MdjBtZ/sVy1jzEfAKIi7d9k=;
        h=Date:From:To:Subject:From;
        b=gih923QA5xbmNystrALi+NXa4+eAhPmLYhtylvVCHPX21vdiHTxhd5qIKb9Nb91Pa
         lBgdzTxRr0lQ7Fz7waXxBJVXgvths67E53x11gupQjaoEoeMQ/DsuDHmDzMdnbijKl
         Kz0zyNaXmc+8NPBcedqGwGy+N7MSRSCGNMuzR9sU=
Date:   Thu, 20 Jan 2022 13:29:10 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-damon-vaddr-hide-kernel-pointer-from-damon=5Fva=5Fthr?=
 =?US-ASCII?Q?ee=5Fregions-failure-log.patch?= removed from -mm tree
Message-ID: <20220120212910.cF1gTp_Uc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: hide kernel pointer from damon_va_three_regions() failure log
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: hide kernel pointer from damon_va_three_regions() failure log

The failure log message for 'damon_va_three_regions()' prints the target
id, which is a 'struct pid' pointer in the case.  To avoid exposing the
kernel pointer via the log, this commit makes the log to use the index of
the target in the context's targets list instead.

Link: https://lkml.kernel.org/r/20211229131016.23641-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log
+++ a/mm/damon/vaddr.c
@@ -232,13 +232,19 @@ static int damon_va_three_regions(struct
 static void __damon_va_init_regions(struct damon_ctx *ctx,
 				     struct damon_target *t)
 {
+	struct damon_target *ti;
 	struct damon_region *r;
 	struct damon_addr_range regions[3];
 	unsigned long sz = 0, nr_pieces;
-	int i;
+	int i, tidx = 0;
 
 	if (damon_va_three_regions(t, regions)) {
-		pr_debug("Failed to get three regions of target %lu\n", t->id);
+		damon_for_each_target(ti, ctx) {
+			if (ti == t)
+				break;
+			tidx++;
+		}
+		pr_debug("Failed to get three regions of %dth target\n", tidx);
 		return;
 	}
 
_

Patches currently in -mm which might be from sj@kernel.org are


