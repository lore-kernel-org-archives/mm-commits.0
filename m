Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CABFC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67FF4206F2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194354;
	bh=Zf/5Hq9ffHWCpzyBNmFOSYX3ARWJzOLcFVU93Ol/UGA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oI7coGMADT1N1CH51P8HPmNaGa0ItfB99ECIahlpSafTmo3HqV/Odgn8b8PVADXU0
	 0TPAoqRBZIL/vz86ixQfTfv8Ig/LeIvsZuI4wtdhIxxZqbNcOYy00SsSrLxwBNpzr2
	 3IJad8EpyuXklb0qeJLxhKDOTGnsUMHJYbxjIXoc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgHLBFy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBFx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:05:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 313F2206B5;
        Wed, 12 Aug 2020 01:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194353;
        bh=Zf/5Hq9ffHWCpzyBNmFOSYX3ARWJzOLcFVU93Ol/UGA=;
        h=Date:From:To:Subject:From;
        b=cX0jCNKWwzRzZBgkmR87LJgXDThsbMHKxXo8QfNMbG+fEQOqOQ9bzBRozXyUE8lrv
         IpoxvK56oRVbXOhu8JvjzstL9+V653qjwkovPwuROg3lKp3f5wGTmOaOgcWB0B89LL
         pW4ls1DzE3pTo+t01vhX0fX4n7g6oLiDY7PlHyyg=
Date:   Tue, 11 Aug 2020 18:05:52 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-migrate-clear-=5F=5Fgfp=5Freclaim-to-make-the-migratio?=
 =?US-ASCII?Q?n-callback-consistent-with-regular-thp-allocations-fix.p?=
 =?US-ASCII?Q?atch?= removed from -mm tree
Message-ID: <20200812010552.kDR0XIegX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch

This patch was dropped because it was folded into mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix

fix comment typo, per Vlastimil

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix
+++ a/mm/migrate.c
@@ -1550,7 +1550,7 @@ struct page *new_page_nodemask(struct pa
 
 	if (PageTransHuge(page)) {
 		/*
-		 * clear __GFP_RECALIM to make the migration callback
+		 * clear __GFP_RECLAIM to make the migration callback
 		 * consistent with regular THP allocations.
 		 */
 		gfp_mask &= ~__GFP_RECLAIM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

