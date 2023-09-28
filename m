Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23223E732FD
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 17:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjI1RaN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 13:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjI1RaM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 13:30:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C9BCC4;
        Thu, 28 Sep 2023 10:30:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7DAC433BC;
        Thu, 28 Sep 2023 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695922205;
        bh=Xxz7s3+A+nPwhjnLCtTjJrpa053TuUxRS9LfK7GcWKw=;
        h=Date:To:From:Subject:From;
        b=c2m0scU3EVE20G0+QwqSEPcI/K4xGr+DJ8pqc7jjpX7PFzyD3Qyj1nEZxkJHRk5kO
         W4+ELZrISX3LEgWyTficZZ8/6Sn1qdAnb3X7EJzInyitgtENXkDxeG8jU12kk1N3Yw
         B2zmvR6FL7lTHUPcJCXZQTFUF/QJGktToNchRRUU=
Date:   Thu, 28 Sep 2023 10:30:05 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        jannh@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mmap-fix-vma_iterator-in-error-path-of-vma_merge.patch removed from -mm tree
Message-Id: <20230928173005.BC7DAC433BC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: fix vma_iterator in error path of vma_merge()
has been removed from the -mm tree.  Its filename was
     mmap-fix-vma_iterator-in-error-path-of-vma_merge.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mmap: fix vma_iterator in error path of vma_merge()
Date: Wed, 27 Sep 2023 12:07:44 -0400

When merging of the previous VMA fails after the vma iterator has been
moved to the previous entry, the vma iterator must be advanced to ensure
the caller takes the correct action on the next vma iterator event.  Fix
this by adding a vma_next() call to the error path.

Users may experience higher CPU usage, most likely in very low memory
situations.

Link: https://lore.kernel.org/linux-mm/CAG48ez12VN1JAOtTNMY+Y2YnsU45yL5giS-Qn=ejtiHpgJAbdQ@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230927160746.1928098-2-Liam.Howlett@oracle.com
Fixes: 18b098af2890 ("vma_merge: set vma iterator to correct position.")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Closes: https://lore.kernel.org/linux-mm/CAG48ez12VN1JAOtTNMY+Y2YnsU45yL5giS-Qn=ejtiHpgJAbdQ@mail.gmail.com/
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mmap-fix-vma_iterator-in-error-path-of-vma_merge
+++ a/mm/mmap.c
@@ -968,14 +968,14 @@ struct vm_area_struct *vma_merge(struct
 				vma_pgoff = curr->vm_pgoff;
 				vma_start_write(curr);
 				remove = curr;
-				err = dup_anon_vma(next, curr);
+				err = dup_anon_vma(next, curr, &anon_dup);
 			}
 		}
 	}
 
 	/* Error in anon_vma clone. */
 	if (err)
-		return NULL;
+		goto anon_vma_fail;
 
 	if (vma_start < vma->vm_start || vma_end > vma->vm_end)
 		vma_expanded = true;
@@ -988,7 +988,7 @@ struct vm_area_struct *vma_merge(struct
 	}
 
 	if (vma_iter_prealloc(vmi, vma))
-		return NULL;
+		goto prealloc_fail;
 
 	init_multi_vma_prep(&vp, vma, adjust, remove, remove2);
 	VM_WARN_ON(vp.anon_vma && adjust && adjust->anon_vma &&
@@ -1016,6 +1016,12 @@ struct vm_area_struct *vma_merge(struct
 	vma_complete(&vp, vmi, mm);
 	khugepaged_enter_vma(res, vm_flags);
 	return res;
+
+prealloc_fail:
+anon_vma_fail:
+	if (merge_prev)
+		vma_next(vmi);
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-mas_active-to-detect-in-tree-walks.patch
maple_tree-add-mas_underflow-and-mas_overflow-states.patch
mmap-fix-error-paths-with-dup_anon_vma.patch
mmap-add-clarifying-comment-to-vma_merge-code.patch

