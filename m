Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCCBC43467
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FB8C22244
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633359;
	bh=gppJfXm8tXvYgVQkHp0/LDAwKxabyBPqOCX8rZXGBsY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LUqO1s027NGgjVgS5pmYb/XhQpqRJvF049Zm9Z5fe7cv/Ip1A7y5u2xhb6PxoBDxP
	 nzdGrnxvL5wesgcZ8yPcNwG2v3QB3u+/s6M1FQKLTqOGVPuRhh4fdfx6AQel8KzGV4
	 A6Wpb/b0/CnYo0r0wMTtemi7b0LOjh/W2sMicqyQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388569AbgJMXz6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXz6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3134B2222F;
        Tue, 13 Oct 2020 23:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633358;
        bh=gppJfXm8tXvYgVQkHp0/LDAwKxabyBPqOCX8rZXGBsY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LjcG/g/CZDYx5NMFPGqg9tQ6pmUiRjniTh0kxD50Hi/9g4ctHE4gFXHo2MUD0jBu4
         rqIuXWq5pm80JpL2zHGmTT5i7Ag8b6AzTctDxaIZwsgu1rfl5A+qoVTHcctGoeakcq
         HFZDrz7v49oepaQLLXWffAwqK810AkajHi5lQHgY=
Date:   Tue, 13 Oct 2020 16:55:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mateusznosek0@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 137/181] mmzone: clean code by removing unused
 macro parameter
Message-ID: <20201013235557.p5yFMSG1D%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
