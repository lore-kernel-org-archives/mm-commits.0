Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01FDC25B06
	for <mm-commits@archiver.kernel.org>; Thu,  4 Aug 2022 22:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiHDWm0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Aug 2022 18:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiHDWmZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2022 18:42:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF0B248F2
        for <mm-commits@vger.kernel.org>; Thu,  4 Aug 2022 15:42:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDA3EB82768
        for <mm-commits@vger.kernel.org>; Thu,  4 Aug 2022 22:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95991C433D7;
        Thu,  4 Aug 2022 22:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659652941;
        bh=pkunLvX73aRsVmhEKC4y/q3oE9ELqgM38K9NrA4IUeo=;
        h=Date:To:From:Subject:From;
        b=KM2FsbGTMGcdqzYWG6iL8y0EBWKuvy2XbtjE5RkwB56TPAUfiO/fneMwHcMVqQKa+
         j7PgWZODqnE7sCOXgcnW67xE4gBacCJ9WO5RcGOOkd3XuqoncaMRw1JiydmVo12cxN
         JrjNWOC/8fXJFjvyGCjMkd1q+it9zJviZcNTk74w=
Date:   Thu, 04 Aug 2022 15:42:20 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shy828301@gmail.com,
        nadav.amit@gmail.com, khlebnikov@openvz.org, david@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch added to mm-hotfixes-unstable branch
Message-Id: <20220804224221.95991C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/smaps: don't access young/dirty bit if pte unpresent
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Peter Xu <peterx@redhat.com>
Subject: mm/smaps: don't access young/dirty bit if pte unpresent
Date: Wed, 3 Aug 2022 18:03:29 -0400

These bits should only be valid when the ptes are present.  Introduce two
booleans for it and set it to false when !pte_present().

Link: https://lkml.kernel.org/r/20220803220329.46299-1-peterx@redhat.com
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Fixes: b1d4d9e0cbd0 ("proc/smaps: carefully handle migration entries", 2012-05-31)
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent
+++ a/fs/proc/task_mmu.c
@@ -525,10 +525,12 @@ static void smaps_pte_entry(pte_t *pte,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
-	bool migration = false;
+	bool migration = false, young = false, dirty = false;
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
+		young = pte_young(*pte);
+		dirty = pte_dirty(*pte);
 	} else if (is_swap_pte(*pte)) {
 		swp_entry_t swpent = pte_to_swp_entry(*pte);
 
@@ -558,8 +560,7 @@ static void smaps_pte_entry(pte_t *pte,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
-		      locked, migration);
+	smaps_account(mss, page, false, young, dirty, locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch

