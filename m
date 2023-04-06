Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71C7C77B73
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbjDFCpU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbjDFCow (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C3086B6
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A9A16429F
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A468CC433EF;
        Thu,  6 Apr 2023 02:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749090;
        bh=G95W1TEvxEGQnG1XQE4r4BsicL/qcklTfTVtuT/KkKg=;
        h=Date:To:From:Subject:From;
        b=UEwElKCacNNSF+QWGOb0XlL1xhpUJdSN7u72w5biMoKJQ9HXUHNiPYlOl9hFvgnGm
         lokiPdxMSx2E0el+AUp2nRNba7+kCtuPJEOlCEeCLjOJxtUuOOWvTySJsNFVTp6net
         d3VTWWVmsOOYl5F5WZmhckqg9jWgr/9qek9lDEqw=
Date:   Wed, 05 Apr 2023 19:44:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch removed from -mm tree
Message-Id: <20230406024450.A468CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: use the proper vma pointers in cases 1 and 6
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: use the proper vma pointers in cases 1 and 6
Date: Thu, 9 Mar 2023 12:12:51 +0100

Case 1 is now shown in the comment as next vma being merged with prev, so
use 'next' instead of 'mid'.  In case 1 they both point to the same vma.

As a consequence, in case 6, the dup_anon_vma() is now tried first on
'next' and then on 'mid', before it was the opposite order.  This is not a
functional change, as those two vma's cannnot have a different anon_vma,
as that would have prevented the merging in the first place.

Link: https://lkml.kernel.org/r/20230309111258.24079-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6
+++ a/mm/mmap.c
@@ -605,7 +605,7 @@ again:
 
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
-		 * we must remove the one after next as well.
+		 * we are removing both mid and next vmas
 		 */
 		if (vp->remove2) {
 			vp->remove = vp->remove2;
@@ -948,13 +948,14 @@ struct vm_area_struct *vma_merge(struct
 	/* Can we merge both the predecessor and the successor? */
 	if (merge_prev && merge_next &&
 	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
-		remove = mid;				/* case 1 */
+		remove = next;				/* case 1 */
 		vma_end = next->vm_end;
-		err = dup_anon_vma(prev, mid);
+		err = dup_anon_vma(prev, next);
 		if (mid != next) {			/* case 6 */
+			remove = mid;
 			remove2 = next;
-			if (!mid->anon_vma)
-				err = dup_anon_vma(prev, next);
+			if (!next->anon_vma)
+				err = dup_anon_vma(prev, mid);
 		}
 	} else if (merge_prev) {
 		err = 0;				/* case 2 */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

