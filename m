Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3992FC00140
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 01:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiHKBZq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 21:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbiHKBZo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 21:25:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47AA65670
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 18:25:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A1B661199
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 01:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68CBC433D6;
        Thu, 11 Aug 2022 01:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660181142;
        bh=jNe1WGqGYBnM1Hk6Ex7L3F0Om4Ar59E6AZRIHUlHvnU=;
        h=Date:To:From:Subject:From;
        b=GuqV0+Y40SOyKxCy2eUBMuObqvs44bI3/TjqrX+TDARmVxpfHtu4ClKuqUZDXluid
         RaryrMh4D0Q05Cpv+lM753uWPJ+ZsJ3WkDUBwLeMNNU3Pymb5eAWnd9jFqq9ay/Jl6
         AdLbp4MPZztqj2Pa+lg4JgE/HP71jHGCIKgf8vkk=
Date:   Wed, 10 Aug 2022 18:25:41 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        shy828301@gmail.com, khlebnikov@openvz.org, david@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch added to mm-hotfixes-unstable branch
Message-Id: <20220811012542.A68CBC433D6@smtp.kernel.org>
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
Date: Fri, 5 Aug 2022 12:00:03 -0400

These bits should only be valid when the ptes are present.  Introducing
two booleans for it and set it to false when !pte_present() for both pte
and pmd accountings.

The bug is found during code reading and no real world issue reported, but
logically such an error can cause incorrect readings for either smaps or
smaps_rollup output on quite a few fields.

For example, it could cause over-estimate on values like Shared_Dirty,
Private_Dirty, Referenced.  Or it could also cause under-estimate on
values like LazyFree, Shared_Clean, Private_Clean.

Link: https://lkml.kernel.org/r/20220805160003.58929-1-peterx@redhat.com
Fixes: b1d4d9e0cbd0 ("proc/smaps: carefully handle migration entries")
Fixes: c94b6923fa0a ("/proc/PID/smaps: Add PMD migration entry parsing")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent
+++ a/fs/proc/task_mmu.c
@@ -527,10 +527,12 @@ static void smaps_pte_entry(pte_t *pte,
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
 
@@ -560,8 +562,7 @@ static void smaps_pte_entry(pte_t *pte,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
-		      locked, migration);
+	smaps_account(mss, page, false, young, dirty, locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -572,11 +573,13 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
-	bool migration = false;
+	bool migration = false, young = false, dirty = false;
 
 	if (pmd_present(*pmd)) {
 		/* FOLL_DUMP will return -EFAULT on huge zero page */
 		page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
+		young = pmd_young(*pmd);
+		dirty = pmd_dirty(*pmd);
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
@@ -596,8 +599,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
 
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
-		      locked, migration);
+	smaps_account(mss, page, true, young, dirty, locked, migration);
 }
 #else
 static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch

