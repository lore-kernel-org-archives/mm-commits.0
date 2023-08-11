Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA05C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbjHKW6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbjHKW6q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E711AE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AFE465BD7
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C85C433C8;
        Fri, 11 Aug 2023 22:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794724;
        bh=sBTaEBAuEDR6d4uQQMRtoxlRqhNI16aiksWrUWiLmwU=;
        h=Date:To:From:Subject:From;
        b=i2NT+0+VxaFmIa740xphL4oP2ElEt62PRZbQukhDle9P1o0jpjiOU8eNvJGJSmqIy
         OCZPWVEaZmi2AfrMmCHhuXqVxhdwAq4p/4z6srO3jFcSNVf97xtox9Xl6p0moLLlQL
         zTaO+We55Q9+s7F7seHlOwAde7zzEF7ZDo6A0Bn0=
Date:   Fri, 11 Aug 2023 15:58:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-cleanup-next_page-handling.patch removed from -mm tree
Message-Id: <20230811225844.C3C85C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: cleanup next_page handling
has been removed from the -mm tree.  Its filename was
     mm-gup-cleanup-next_page-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: cleanup next_page handling
Date: Wed, 28 Jun 2023 17:53:06 -0400

The only path that doesn't use generic "**pages" handling is the gate vma.
Make it use the same path, meanwhile tune the next_page label upper to
cover "**pages" handling.  This prepares for THP handling for "**pages".

Link: https://lkml.kernel.org/r/20230628215310.73782-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-cleanup-next_page-handling
+++ a/mm/gup.c
@@ -1207,7 +1207,7 @@ static long __get_user_pages(struct mm_s
 			if (!vma && in_gate_area(mm, start)) {
 				ret = get_gate_page(mm, start & PAGE_MASK,
 						gup_flags, &vma,
-						pages ? &pages[i] : NULL);
+						pages ? &page : NULL);
 				if (ret)
 					goto out;
 				ctx.page_mask = 0;
@@ -1277,19 +1277,18 @@ retry:
 				ret = PTR_ERR(page);
 				goto out;
 			}
-
-			goto next_page;
 		} else if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
 		}
+next_page:
 		if (pages) {
 			pages[i] = page;
 			flush_anon_page(vma, page, start);
 			flush_dcache_page(page);
 			ctx.page_mask = 0;
 		}
-next_page:
+
 		page_increm = 1 + (~(start >> PAGE_SHIFT) & ctx.page_mask);
 		if (page_increm > nr_pages)
 			page_increm = nr_pages;
_

Patches currently in -mm which might be from peterx@redhat.com are


