Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A674CC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbjHKXN6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbjHKXN3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B198E3A98
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B3167ADA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5A7C433C8;
        Fri, 11 Aug 2023 23:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794945;
        bh=/dce9E73H3PVpgtVLs0FWMxe+Ktc9fw6bm2YxlyEF3k=;
        h=Date:To:From:Subject:From;
        b=lGU9Sq8ckreOb2RCktCk1RT1fsk1DqY9rrzbqyssgxuo0VIcAd697Mp9yf1K1Sw5i
         1x02gScAOEUV7LC2LWQ+SxhaliTHeXiSf73WUnXDUZCPPauEKqPv+iK52JU3ENdDFp
         G4A3utONaoAFAvzgPlvO1Gkpy3zdd9CkYOV+5XRY=
Date:   Fri, 11 Aug 2023 16:02:24 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set.patch removed from -mm tree
Message-Id: <20230811230224.EA5A7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: avoid unneeded pageblock_end_pfn when no_set_skip_hint is set
has been removed from the -mm tree.  Its filename was
     mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huawei.com>
Subject: mm/compaction: avoid unneeded pageblock_end_pfn when no_set_skip_hint is set
Date: Fri, 21 Jul 2023 23:09:57 +0800

Move pageblock_end_pfn after no_set_skip_hint check to avoid unneeded
pageblock_end_pfn if no_set_skip_hint is set.

Link: https://lkml.kernel.org/r/20230721150957.2058634-3-shikemeng@huawei.com
Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set
+++ a/mm/compaction.c
@@ -463,12 +463,12 @@ static void update_cached_migrate(struct
 {
 	struct zone *zone = cc->zone;
 
-	pfn = pageblock_end_pfn(pfn);
-
 	/* Set for isolation rather than compaction */
 	if (cc->no_set_skip_hint)
 		return;
 
+	pfn = pageblock_end_pfn(pfn);
+
 	if (pfn > zone->compact_cached_migrate_pfn[0])
 		zone->compact_cached_migrate_pfn[0] = pfn;
 	if (cc->mode != MIGRATE_ASYNC &&
_

Patches currently in -mm which might be from shikemeng@huawei.com are

mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range.patch

