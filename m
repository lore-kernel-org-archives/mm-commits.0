Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CB5C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbjDFCpW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbjDFCou (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DDF7ED3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88BA6429F
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA64C4339B;
        Thu,  6 Apr 2023 02:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749088;
        bh=MzWnre/VY8sU/cgHVyCt3XaUJqeGun3mJRABCaLTLXE=;
        h=Date:To:From:Subject:From;
        b=D6cRy53Cu7qZCYr25JeAxbDKRH1LXb2ACg5BjRJZ2V/gLoIxHWcJOTYIgAPLo90cf
         FMyNqyGbvEHsdsxRpNnjWnNiCW6E45fdv1VbH1TUN1nLIBkLfLgRYyHq8VHDhrT5+b
         Gyh7HoQ2SDxEMwmCH+DPR5dqrRdSg8Vr2LXCcr10=
Date:   Wed, 05 Apr 2023 19:44:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch removed from -mm tree
Message-Id: <20230406024448.2EA64C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: use only primary pointers for preparing merge
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: use only primary pointers for preparing merge
Date: Thu, 9 Mar 2023 12:12:49 +0100

Patch series "cleanup vma_merge() and improve mergeability tests".

My initial goal here was to try making the check for vm_ops->close in
is_mergeable_vma() only be applied for vma's that would be truly removed
as part of the merge (see Patch 9).  This would then allow reverting the
quick fix d014cd7c1c35 ("mm, mremap: fix mremap() expanding for vma's with
vm_ops->close()").  This was successful enough to allow the revert (Patch
10).  Checks using can_vma_merge_before() are still pessimistic about
possible vma removal, and making them precise would probably complicate
the vma_merge() code too much.

Liam's 6.3-rc1 simplification of vma_merge() and removal of __vma_adjust()
was very much helpful in understanding the vma_merge() implementation and
especially when vma removals can happen, which is now very obvious.  While
studing the code, I've found ways to make it hopefully even more easy to
follow, so that's the patches 1-8.  That made me also notice a bug that's
now already fixed in 6.3-rc1.


This patch (of 10):

In the merging preparation part of vma_merge(), some vma pointer variables
are assigned for later execution of the merge, but also read from in the
block itself.  The code is easier follow and check against the cases
diagram in the comment if the code reads only from the "primary" vma
variables prev, mid, next instead.  No functional change.

Link: https://lkml.kernel.org/r/20230309111258.24079-1-vbabka@suse.cz
Link: https://lkml.kernel.org/r/20230309111258.24079-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>]
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge
+++ a/mm/mmap.c
@@ -950,16 +950,16 @@ struct vm_area_struct *vma_merge(struct
 	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
 		remove = mid;				/* case 1 */
 		vma_end = next->vm_end;
-		err = dup_anon_vma(res, remove);
+		err = dup_anon_vma(prev, mid);
 		if (mid != next) {			/* case 6 */
 			remove2 = next;
-			if (!remove->anon_vma)
-				err = dup_anon_vma(res, remove2);
+			if (!mid->anon_vma)
+				err = dup_anon_vma(prev, next);
 		}
 	} else if (merge_prev) {
 		err = 0;				/* case 2 */
 		if (mid && end > mid->vm_start) {
-			err = dup_anon_vma(res, mid);
+			err = dup_anon_vma(prev, mid);
 			if (end == mid->vm_end) {	/* case 7 */
 				remove = mid;
 			} else {			/* case 5 */
@@ -972,8 +972,8 @@ struct vm_area_struct *vma_merge(struct
 		if (prev && addr < prev->vm_end) {	/* case 4 */
 			vma_end = addr;
 			adjust = mid;
-			adj_next = -(vma->vm_end - addr);
-			err = dup_anon_vma(adjust, prev);
+			adj_next = -(prev->vm_end - addr);
+			err = dup_anon_vma(mid, prev);
 		} else {
 			vma = next;			/* case 3 */
 			vma_start = addr;
@@ -982,7 +982,7 @@ struct vm_area_struct *vma_merge(struct
 			err = 0;
 			if (mid != next) {		/* case 8 */
 				remove = mid;
-				err = dup_anon_vma(res, remove);
+				err = dup_anon_vma(next, mid);
 			}
 		}
 	}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

