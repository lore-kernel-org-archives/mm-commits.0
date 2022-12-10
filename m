Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8AAC4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 02:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiLJCmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 21:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLJCmC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 21:42:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8355C7A192
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 18:42:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21547B82A35
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 02:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB10C433EF;
        Sat, 10 Dec 2022 02:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670640118;
        bh=vMJEAQqd2+UWOM/OkBLJ1cagpCwjcfX3W6L2lq5BL5U=;
        h=Date:To:From:Subject:From;
        b=KeLRXOeiA50mYW9M5Fy0IagVI5GyY1/IDEUJEvg/FIvBqJJXndgj+LhLos4dZIzuG
         F0FWXbtUuBV/gexZ6plbZPi76Mz1mRH8AbwaFFteQ4cE4Hc2WNw1PLVvyshSBeYK00
         SATbtdABa6vt3Sj5y6VvNtzLXsAzGPhvh0cL/Nns=
Date:   Fri, 09 Dec 2022 18:41:58 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, sj@kernel.org, Liam.Howlett@oracle.com,
        Jason@zx2c4.com, jannh@google.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmap-fix-do_brk_flags-modifying-obviously-incorrect-vmas.patch removed from -mm tree
Message-Id: <20221210024158.BEB10C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: fix do_brk_flags() modifying obviously incorrect VMAs
has been removed from the -mm tree.  Its filename was
     mmap-fix-do_brk_flags-modifying-obviously-incorrect-vmas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mmap: fix do_brk_flags() modifying obviously incorrect VMAs
Date: Mon, 5 Dec 2022 19:23:17 +0000

Add more sanity checks to the VMA that do_brk_flags() will expand.  Ensure
the VMA matches basic merge requirements within the function before
calling can_vma_merge_after().

Drop the duplicate checks from vm_brk_flags() since they will be enforced
later.

The old code would expand file VMAs on brk(), which is functionally
wrong and also dangerous in terms of locking because the brk() path
isn't designed for file VMAs and therefore doesn't lock the file
mapping.  Checking can_vma_merge_after() ensures that new anonymous
VMAs can't be merged into file VMAs.

See https://lore.kernel.org/linux-mm/CAG48ez1tJZTOjS_FjRZhvtDA-STFmdw8PEizPDwMGFd_ui0Nrw@mail.gmail.com/

Link: https://lkml.kernel.org/r/20221205192304.1957418-1-Liam.Howlett@oracle.com
Fixes: 2e7ce7d354f2 ("mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mmap-fix-do_brk_flags-modifying-obviously-incorrect-vmas
+++ a/mm/mmap.c
@@ -2948,9 +2948,9 @@ static int do_brk_flags(struct ma_state
 	 * Expand the existing vma if possible; Note that singular lists do not
 	 * occur after forking, so the expand will only happen on new VMAs.
 	 */
-	if (vma &&
-	    (!vma->anon_vma || list_is_singular(&vma->anon_vma_chain)) &&
-	    ((vma->vm_flags & ~VM_SOFTDIRTY) == flags)) {
+	if (vma && vma->vm_end == addr && !vma_policy(vma) &&
+	    can_vma_merge_after(vma, flags, NULL, NULL,
+				addr >> PAGE_SHIFT, NULL_VM_UFFD_CTX, NULL)) {
 		mas_set_range(mas, vma->vm_start, addr + len - 1);
 		if (mas_preallocate(mas, vma, GFP_KERNEL))
 			return -ENOMEM;
@@ -3037,11 +3037,6 @@ int vm_brk_flags(unsigned long addr, uns
 		goto munmap_failed;
 
 	vma = mas_prev(&mas, 0);
-	if (!vma || vma->vm_end != addr || vma_policy(vma) ||
-	    !can_vma_merge_after(vma, flags, NULL, NULL,
-				 addr >> PAGE_SHIFT, NULL_VM_UFFD_CTX, NULL))
-		vma = NULL;
-
 	ret = do_brk_flags(&mas, vma, addr, len, flags);
 	populate = ((mm->def_flags & VM_LOCKED) != 0);
 	mmap_write_unlock(mm);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch

