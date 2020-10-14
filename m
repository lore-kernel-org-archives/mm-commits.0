Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3366BC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA0B0221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709377;
	bh=GCcnGS/nJy6/Bgc6Vwuz8a726WMQ9rIcHEqGPySuB8M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cc7ERqr4Cc8WO/WXa7U1LvvPAnyMRjfhUUL9o6U8oob/OaVac231V4imHguqBSXrt
	 PMNQ2XW6MifjwQ7D29w7H2Gv4spjSauu+Y7Jdrz6tcrqGn4K568gVjaOQDUrE3V3Q1
	 FiwRRP/h83wvTzB9vu2bDSR3QEhMx+fAgWHo99xI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388209AbgJNVC5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVC5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84AB2214D8;
        Wed, 14 Oct 2020 21:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709376;
        bh=GCcnGS/nJy6/Bgc6Vwuz8a726WMQ9rIcHEqGPySuB8M=;
        h=Date:From:To:Subject:From;
        b=pLfgRZysXmxjuIJJVYabzwMPzrYCzZEejzx+s3eX6RyqGaKRmDfdbJ0SBZ6q5i5Ws
         vyRMG6u7AxtxNWbZ+avdTMPgFEU19od2F2a9nBylmjkMgY6U2e8rO6i8tAHxOBG4O1
         LqV5aprCkW6ttkebDRi/9cEFkkYagwAWlMx12qMs=
Date:   Wed, 14 Oct 2020 14:02:56 -0700
From:   akpm@linux-foundation.org
To:     mateusznosek0@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mmzone-clean-code-by-removing-unused-macro-parameter.patch removed from -mm
 tree
Message-ID: <20201014210256.A7odLCl_p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmzone: clean code by removing unused macro parameter
has been removed from the -mm tree.  Its filename was
     mmzone-clean-code-by-removing-unused-macro-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mmzone: clean code by removing unused macro parameter

Previously 'for_next_zone_zonelist_nodemask' macro parameter 'zlist' was
unused so this patch removes it.

Link: https://lkml.kernel.org/r/20200917211906.30059-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/page_alloc.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mmzone-clean-code-by-removing-unused-macro-parameter
+++ a/include/linux/mmzone.h
@@ -1116,7 +1116,7 @@ static inline struct zoneref *first_zone
 		z = next_zones_zonelist(++z, highidx, nodemask),	\
 			zone = zonelist_zone(z))
 
-#define for_next_zone_zonelist_nodemask(zone, z, zlist, highidx, nodemask) \
+#define for_next_zone_zonelist_nodemask(zone, z, highidx, nodemask) \
 	for (zone = z->zone;	\
 		zone;							\
 		z = next_zones_zonelist(++z, highidx, nodemask),	\
--- a/mm/page_alloc.c~mmzone-clean-code-by-removing-unused-macro-parameter
+++ a/mm/page_alloc.c
@@ -3741,8 +3741,8 @@ retry:
 	 */
 	no_fallback = alloc_flags & ALLOC_NOFRAGMENT;
 	z = ac->preferred_zoneref;
-	for_next_zone_zonelist_nodemask(zone, z, ac->zonelist,
-					ac->highest_zoneidx, ac->nodemask) {
+	for_next_zone_zonelist_nodemask(zone, z, ac->highest_zoneidx,
+					ac->nodemask) {
 		struct page *page;
 		unsigned long mark;
 
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-page_poisonc-replace-bool-variable-with-static-key.patch

