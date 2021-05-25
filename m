Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1BAC2B9F7
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 00:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01A261420
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 00:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhEYAFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 20:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229780AbhEYAFN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 20:05:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C56D5613E6;
        Tue, 25 May 2021 00:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621901024;
        bh=XGLKq6Xu91sEJjLaeli7hUY2xynuq2oTfRRAt6cGuug=;
        h=Date:From:To:Subject:From;
        b=kVIldslfmGTlomJCTh7jd/lxKKSKmufisgLSQAMbMzRD+if9mTgnGjbOSLehSIneA
         Zon3hLJKVhO0SSysIw9ClQ+JkxTy0YkWdNubG/IQbQcP2RDDPE6jKjPDjbOrB1OEeT
         M3FBcuEwaCKvZMEc7B+8P/s+6kHFayNvMxwS9aPs=
Date:   Mon, 24 May 2021 17:03:43 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, joaodias@google.com, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, surenb@google.com
Subject:  +
 mm-page_alloc-dump-migrate-failed-pages-only-at-ebusy.patch added to -mm
 tree
Message-ID: <20210525000343.YBEWQU38O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: dump migrate-failed pages only at -EBUSY
has been added to the -mm tree.  Its filename is
     mm-page_alloc-dump-migrate-failed-pages-only-at-ebusy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-dump-migrate-failed-pages-only-at-ebusy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-dump-migrate-failed-pages-only-at-ebusy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -8763,7 +8763,8 @@ static int __alloc_contig_migrate_range(
 
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

mm-page_alloc-dump-migrate-failed-pages-only-at-ebusy.patch

