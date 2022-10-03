Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3CCC43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJCVRW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiJCVPU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38C821269
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EAA2611F9
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0829C433D6;
        Mon,  3 Oct 2022 21:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831396;
        bh=UySdW2X4Ovm1x4SCtRC6icR1NJtO4HINzkrV23lBLDQ=;
        h=Date:To:From:Subject:From;
        b=wqYefD/y8Z5RUpo4PQBfJU/SdI7Uxt4HPWnkmDtv+lAjzSnIIYpJ/yhIYMiDovWot
         ToqUIfRh0NyoL8x7q1tLEhigLYKZPuLSMA6lPJlq9Wnpdzljh1TKe7mO/B5yfxjX5T
         n1mdvoXoGZhcPnj1ZV3uAkJ7N6VvGRAR23LHdhqw=
Date:   Mon, 03 Oct 2022 14:09:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch removed from -mm tree
Message-Id: <20221003210956.A0829C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: MADV_COLLAPSE return EAGAIN when page cannot be isolated
has been removed from the -mm tree.  Its filename was
     mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/madvise: MADV_COLLAPSE return EAGAIN when page cannot be isolated
Date: Thu, 22 Sep 2022 11:46:50 -0700

MADV_COLLAPSE is a best-effort request that attempts to set an actionable
errno value if the request cannot be fulfilled at the time.  EAGAIN should
be used to communicate that a resource was temporarily unavailable, but
that the user may try again immediately.

SCAN_DEL_PAGE_LRU is an internal result code used when a page cannot be
isolated from it's LRU list.  Since this, like SCAN_PAGE_LRU, is likely a
transitory state, make MADV_COLLAPSE return EAGAIN so that users know they
may reattempt the operation.

Another important scenario to consider is race with khugepaged. 
khugepaged might isolate a page while MADV_COLLAPSE is interested in it. 
Even though racing with khugepaged might mean that the memory has already
been collapsed, signalling an errno that is non-intrinsic to that memory
or arguments provided to madvise(2) lets the user know that future
attempts might (and in this case likely would) succeed, and avoids
false-negative assumptions by the user.

Link: https://lkml.kernel.org/r/20220922184651.1016461-1-zokeefe@google.com
Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/khugepaged.c~mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated
+++ a/mm/khugepaged.c
@@ -2372,6 +2372,7 @@ static int madvise_collapse_errno(enum s
 	/* Resource temporary unavailable - trying again might succeed */
 	case SCAN_PAGE_LOCK:
 	case SCAN_PAGE_LRU:
+	case SCAN_DEL_PAGE_LRU:
 		return -EAGAIN;
 	/*
 	 * Other: Trying again likely not to succeed / error intrinsic to
@@ -2454,6 +2455,7 @@ int madvise_collapse(struct vm_area_stru
 		case SCAN_PAGE_LOCK:
 		case SCAN_PAGE_COMPOUND:
 		case SCAN_PAGE_LRU:
+		case SCAN_DEL_PAGE_LRU:
 			last_fail = result;
 			break;
 		default:
_

Patches currently in -mm which might be from zokeefe@google.com are


