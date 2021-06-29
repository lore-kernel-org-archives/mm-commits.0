Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEC7C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07F2861D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhF2Coe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231724AbhF2Coe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 050BE611AE;
        Tue, 29 Jun 2021 02:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934527;
        bh=dPHVTe5pFBgxCjc9cC/3A1EmkKKzjL1XyJ8voDvZjKs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AAkb0Hr30T6f7+YtTnIuPxlDxibC/SSdvk544dVVH/vcrIcd/yxf5NQOrqjTBeNyI
         CtE9RnuVDD4CytwEl9a0+sEZXwQ1XCXmoKBPWDX2fPhGkVpspzV3sdddXk8KGOp31x
         yWkgpSNqXv88oj+aIOOXkmTSl2hi4fQAuoXFT/k4=
Date:   Mon, 28 Jun 2021 19:42:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, joaodias@google.com,
        linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, surenb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 169/192] mm: page_alloc: dump migrate-failed pages
 only at -EBUSY
Message-ID: <20210629024206.C0aQfuEUf%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: page_alloc: dump migrate-failed pages only at -EBUSY

alloc_contig_dump_pages() aims for helping debugging page migration
failure by elevated page refcount compared to expected_count.  (for the
detail, please look at migrate_page_move_mapping)

However, -ENOMEM is just the case that system is under memory pressure
state, not relevant with page refcount at all.  Thus, the dumping page
list is not helpful for the debugging point of view.

Link: https://lkml.kernel.org/r/YKa2Wyo9xqIErpfa@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: John Dias <joaodias@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-dump-migrate-failed-pages-only-at-ebusy
+++ a/mm/page_alloc.c
@@ -8800,7 +8800,8 @@ static int __alloc_contig_migrate_range(
 
 	lru_cache_enable();
 	if (ret < 0) {
-		alloc_contig_dump_pages(&cc->migratepages);
+		if (ret == -EBUSY)
+			alloc_contig_dump_pages(&cc->migratepages);
 		putback_movable_pages(&cc->migratepages);
 		return ret;
 	}
_
