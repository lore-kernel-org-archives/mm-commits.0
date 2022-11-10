Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0FDC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 03:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiKJD1q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbiKJD1k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 22:27:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DA325C61
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 19:27:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14DFC61D53
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 03:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8FAC433C1;
        Thu, 10 Nov 2022 03:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668050857;
        bh=cN29Xy23lSmlRQvdW6PC+PPfJ22uq9838JRrjgtETNg=;
        h=Date:To:From:Subject:From;
        b=IAUgwK5C7PIvDvit2Ypm7Jnj3YxkkWN87ZAAA3SswHayQY+4mU+QhG5Ji0rXx6jiZ
         fW9KXXj5yOBImy63WrXQJyuQahTZAotezeYn6J5bMts1/xnwqICwbQguCnUChMvbqj
         rKI1fPNFeNJQut+lGSu/XvTTbN6U6ifyPqtXeyOg=
Date:   Wed, 09 Nov 2022 19:27:36 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, shy828301@gmail.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, jhubbard@nvidia.com, david@redhat.com,
        almasrymina@google.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-use-folio-fields-in-second-tail-page-fix.patch added to mm-unstable branch
Message-Id: <20221110032737.6A8FAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: use folio fields in second tail page: fix
has been added to the -mm mm-unstable branch.  Its filename is
     mmhugetlb-use-folio-fields-in-second-tail-page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhugetlb-use-folio-fields-in-second-tail-page-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm,hugetlb: use folio fields in second tail page: fix
Date: Wed, 9 Nov 2022 18:13:50 -0800 (PST)

Per review comment from Sidhartha: prefix folio's page_1 and page_2 with
double underscore, to underscore that they are fillers for alignment
rather than directly usable members of the union (whereas the first
"struct page page" is important for folio<->page conversions).

Per review comment from Kirill: give folio's _flags_2 and _head_2 a line
of documentation each, though both of them "Do not use" (I think _flags_1
should be enough for now, and shouldn't recommend spilling to _flags_2).

Link: https://lkml.kernel.org/r/9e2cb6b-5b58-d3f2-b5ee-5f8a14e8f10@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/mm_types.h~mmhugetlb-use-folio-fields-in-second-tail-page-fix
+++ a/include/linux/mm_types.h
@@ -273,6 +273,8 @@ struct page {
  * @_total_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
  * @_folio_nr_pages: Do not use directly, call folio_nr_pages().
+ * @_flags_2: For alignment.  Do not use.
+ * @_head_2: Points to the folio.  Do not use.
  * @_hugetlb_subpool: Do not use directly, use accessor in hugetlb.h.
  * @_hugetlb_cgroup: Do not use directly, use accessor in hugetlb_cgroup.h.
  * @_hugetlb_cgroup_rsvd: Do not use directly, use accessor in hugetlb_cgroup.h.
@@ -327,7 +329,7 @@ struct folio {
 			unsigned int _folio_nr_pages;
 #endif
 		};
-		struct page page_1;
+		struct page __page_1;
 	};
 	union {
 		struct {
@@ -338,7 +340,7 @@ struct folio {
 			void *_hugetlb_cgroup_rsvd;
 			void *_hugetlb_hwpoison;
 		};
-		struct page page_2;
+		struct page __page_2;
 	};
 };
 
_

Patches currently in -mm which might be from hughd@google.com are

mmhugetlb-use-folio-fields-in-second-tail-page.patch
mmhugetlb-use-folio-fields-in-second-tail-page-fix.patch
mmthprmap-simplify-compound-page-mapcount-handling.patch
mmthprmap-lock_compound_mapcounts-on-thp-mapcounts.patch

