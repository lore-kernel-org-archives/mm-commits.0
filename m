Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA8EC43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 01:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A10C21D7F
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 01:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600477740;
	bh=vX3HCV+21fp4GPB3yFY0gUkHnIsSQ+JSeZKUNtMmdtM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WtGFC1J1G/Cz85vLny2ND4REZziZL6D/076duKCPVRfUgVqf/oYWXHzOB/ufHriKe
	 HWDpj/7me54F7hjXRAkLSqIM7BEiMRBznvGceeKMzb49VQw3eDAl6SOZ6GfsLw44tR
	 pw6aD0iZK3wCU3dsjeI7LKy9U88bzz9bdWuYw1B8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgISBI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 21:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISBI7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 21:08:59 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21CCF21D43;
        Sat, 19 Sep 2020 01:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600477739;
        bh=vX3HCV+21fp4GPB3yFY0gUkHnIsSQ+JSeZKUNtMmdtM=;
        h=Date:From:To:Subject:From;
        b=ocVpLlDWJRVYC3pooC8c5xvMXS4seqKW8kfzSukBKOS5K0hcOMZ2eA/q52ijLji37
         WN1RogvG6eoKzSET43TdGJqRodT4e0NEip/BCEmlNptCPUDYoZBuX6uKeUOo0ny2+t
         6uGqVgH4L9UodxACn/AYqkxgThzbW9oU/zTgPS7M=
Date:   Fri, 18 Sep 2020 18:08:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mateusznosek0@gmail.com
Subject:  +
 mmzone-clean-code-by-removing-unused-macro-parameter.patch added to -mm tree
Message-ID: <20200919010858.gTewu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmzone: clean code by removing unused macro parameter
has been added to the -mm tree.  Its filename is
     mmzone-clean-code-by-removing-unused-macro-parameter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmzone-clean-code-by-removing-unused-macro-parameter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmzone-clean-code-by-removing-unused-macro-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3727,8 +3727,8 @@ retry:
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

mm-slabc-clean-code-by-removing-redundant-if-condition.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
mm-page_allocc-micro-optimization-remove-unnecessary-branch.patch
mm-page_allocc-fix-early-params-garbage-value-accesses.patch
mm-page_allocc-clean-code-by-merging-two-functions.patch
mmzone-clean-code-by-removing-unused-macro-parameter.patch
mm-compactionc-micro-optimization-remove-unnecessary-branch.patch

