Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95385C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76D3760FDB
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhGFTRc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231856AbhGFTRc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 866326008E;
        Tue,  6 Jul 2021 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598893;
        bh=V02dO5gBjzVSAFOtn+TFL/CSbEAndCIPCyKzKkbWr/8=;
        h=Date:From:To:Subject:From;
        b=CEHieTY8/++ldNQiYlVCvoIhoruUh9Fwh8ocLmpSyCVLQ6TZaEIyQ+m+s/uj5sipD
         hYVzgWRtLaCyrlTp/vqNZqeTDgprFZo2tCSnkPI42fMdwtY9+Ye5LxatVRVL+YWMeV
         m39zmv4udr48iYbrkL5gsW9QzLrY5AExVttw8J48=
Date:   Tue, 06 Jul 2021 12:14:53 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, joaodias@google.com, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, surenb@google.com
Subject:  [merged]
 mm-page_alloc-dump-migrate-failed-pages-only-at-ebusy.patch removed from
 -mm tree
Message-ID: <20210706191453.s3g0ZxGfU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: dump migrate-failed pages only at -EBUSY
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dump-migrate-failed-pages-only-at-ebusy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from minchan@kernel.org are


