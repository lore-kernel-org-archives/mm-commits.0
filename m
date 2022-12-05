Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A93C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 20:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLEUd5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 15:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiLEUd4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 15:33:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C5BBC2F
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 12:33:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91C8161389
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 20:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E6CC433C1;
        Mon,  5 Dec 2022 20:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670272434;
        bh=PrfkGun+kyliDHDJUqI4moikhNN/R3PMBA2JyA+MQWM=;
        h=Date:To:From:Subject:From;
        b=zmzj7wHzrkWzxuWOLkJy9Ajg9CpGCxXVvFIRRy28UekDchWG5V/L73EQIxwFMf85f
         Nh02KhcFdWrCjzA+QuJ0xyR7UnJmb0X9q09LuLa86jiWf8AmaKFEtf1d8a1yW8e9tE
         5XYfBt44/QXq1Vk2XG6C2wtLglBkTRpLDG9CEvUI=
Date:   Mon, 05 Dec 2022 12:33:53 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, sj@kernel.org, Liam.Howlett@oracle.com,
        Jason@zx2c4.com, jannh@google.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-fix-do_brk_flags-modifying-obviously-incorrect-vmas.patch added to mm-unstable branch
Message-Id: <20221205203353.E6E6CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: fix do_brk_flags() modifying obviously incorrect VMAs
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-fix-do_brk_flags-modifying-obviously-incorrect-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-fix-do_brk_flags-modifying-obviously-incorrect-vmas.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mmap: fix do_brk_flags() modifying obviously incorrect VMAs
Date: Mon, 5 Dec 2022 19:23:17 +0000

Add more sanity checks to the VMA that do_brk_flags() will expand.  Ensure
the VMA matches basic merge requirements within the function before
calling can_vma_merge_after().

Drop the duplicate checks from vm_brk_flags() since they will be enforced
later.

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
@@ -2945,9 +2945,9 @@ static int do_brk_flags(struct ma_state
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
 			goto unacct_fail;
@@ -3034,11 +3034,6 @@ int vm_brk_flags(unsigned long addr, uns
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

mmap-fix-do_brk_flags-modifying-obviously-incorrect-vmas.patch
maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch

