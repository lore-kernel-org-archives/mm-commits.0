Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41439C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B2D206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195971;
	bh=IniJVm/Zr76ENqDSnFp9q59uLjstfd66nQjMW7AE1Zc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0aLZvuz6/ykGwq1TuV5v6U+NeRK7ZPrgC67zcOvFqJO7xYPHqoP8Gi7ngC7WI8ZNa
	 2g0oelMQs7RIFugmMe7Oqma6zrG9g9MA+YPGuyR0uN12I4/TbscAq8oDGvIGkfLWmv
	 tc04TQ4NgrXHssthFA8p0Ic+WMYjJj7LxzFmbECw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgHLBcu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBcu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F9E1207DA;
        Wed, 12 Aug 2020 01:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195970;
        bh=IniJVm/Zr76ENqDSnFp9q59uLjstfd66nQjMW7AE1Zc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DtxELXKO4Z/WyCQIYaKTD7uXDtnsvJrccRBXd5G/MPR8SkDj2Xxhcuz1IsCnyIbIb
         GXC+SmDU0MXmPKS4X6imazQg/y36n5Ymv0iJCHRTnDvaZ5+5030H6HlhwVBaS2ZNAN
         bYnQ4N0ZR0S3ttMg5Ja5K4BfNt/3oTMyQiqK7VWo=
Date:   Tue, 11 Aug 2020 18:32:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 048/165] mm/compaction.c: delete duplicated word
Message-ID: <20200812013249.IBGHUjZ4P%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/compaction.c: delete duplicated word

Drop the repeated word "a".

Link: http://lkml.kernel.org/r/20200801173822.14973-2-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compactionc-delete-duplicated-word
+++ a/mm/compaction.c
@@ -1477,7 +1477,7 @@ static void isolate_freepages(struct com
 	 * this pfn aligned down to the pageblock boundary, because we do
 	 * block_start_pfn -= pageblock_nr_pages in the for loop.
 	 * For ending point, take care when isolating in last pageblock of a
-	 * a zone which ends in the middle of a pageblock.
+	 * zone which ends in the middle of a pageblock.
 	 * The low boundary is the end of the pageblock the migration scanner
 	 * is using.
 	 */
_
