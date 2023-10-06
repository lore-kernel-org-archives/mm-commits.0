Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7F3E94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbjJFVqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbjJFVqq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:46:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80856BD;
        Fri,  6 Oct 2023 14:46:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB984C433C9;
        Fri,  6 Oct 2023 21:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628805;
        bh=dqE84yQW1hf//szjupMG01qhA06ookFdBeDwy8HCbHE=;
        h=Date:To:From:Subject:From;
        b=zPR1IQkIsOyF2lVR5nb8tF9TPye8pSMppYHER7msW7SPau0VRRId2lpjZWdh5lA/Z
         57z+9XkI0ifWDI8/0dblcPMHSRSoXcflSWpBYsAU1lDWvuGtS4FoTeK5BoQ7tySa/5
         TbOeBnD7P6Zgk9ZASVuTAnQXdPmb3cfgpNGuBsqY=
Date:   Fri, 06 Oct 2023 14:46:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, stable@vger.kernel.org, lstoakes@gmail.com,
        jannh@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmap-fix-vma_iterator-in-error-path-of-vma_merge.patch removed from -mm tree
Message-Id: <20231006214644.CB984C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: fix vma_iterator in error path of vma_merge()
has been removed from the -mm tree.  Its filename was
     mmap-fix-vma_iterator-in-error-path-of-vma_merge.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mmap: fix vma_iterator in error path of vma_merge()
Date: Fri, 29 Sep 2023 14:30:39 -0400

During the error path, the vma iterator may not be correctly positioned or
set to the correct range.  Undo the vma_prev() call by resetting to the
passed in address.  Re-walking to the same range will fix the range to the
area previously passed in.

Users would notice increased cycles as vma_merge() would be called an
extra time with vma == prev, and thus would fail to merge and return.

Link: https://lore.kernel.org/linux-mm/CAG48ez12VN1JAOtTNMY+Y2YnsU45yL5giS-Qn=ejtiHpgJAbdQ@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230929183041.2835469-2-Liam.Howlett@oracle.com
Fixes: 18b098af2890 ("vma_merge: set vma iterator to correct position.")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Closes: https://lore.kernel.org/linux-mm/CAG48ez12VN1JAOtTNMY+Y2YnsU45yL5giS-Qn=ejtiHpgJAbdQ@mail.gmail.com/
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mmap-fix-vma_iterator-in-error-path-of-vma_merge
+++ a/mm/mmap.c
@@ -975,7 +975,7 @@ struct vm_area_struct *vma_merge(struct
 
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
+	vma_iter_set(vmi, addr);
+	vma_iter_load(vmi);
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mmap-add-clarifying-comment-to-vma_merge-code.patch
radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk.patch

