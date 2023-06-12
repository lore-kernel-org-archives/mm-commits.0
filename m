Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87898C88CB7
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 19:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbjFLT5V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 15:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbjFLT5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 15:57:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5C810CE
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 12:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D864C620F6
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 19:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D6BC433D2;
        Mon, 12 Jun 2023 19:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686599838;
        bh=Iu5owEqSIqYFG0NtnltKXI01iZ3Yi0jEgi71ufkWkZc=;
        h=Date:To:From:Subject:From;
        b=G8W/0dkmvVsx7Q2AdvY5c3OgedRusO5TIF9TOpkRkBQ7Lc1Q2gqJBfaWtRarHl9xn
         EapBXT3THdpd+WD5sxnF9q0/IWygOGJqpCIh/6x3yfUxBlnFFEszI2G0AxOQTRaTAw
         UBh0r/60DjuGmoQAQdJynwSEjYOS6ISqqFe9lyhc=
Date:   Mon, 12 Jun 2023 12:57:17 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-pgtable-lock-on-pmd-sharing.patch added to mm-unstable branch
Message-Id: <20230612195718.32D6BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: Fix pgtable lock on pmd sharing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-pgtable-lock-on-pmd-sharing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-pgtable-lock-on-pmd-sharing.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: Fix pgtable lock on pmd sharing
Date: Mon, 12 Jun 2023 12:04:20 -0400

Huge pmd sharing operates on PUD not PMD, huge_pte_lock() is not suitable
in this case because it should only work for last level pte changes, while
pmd sharing is always one level higher.

Meanwhile, here we're locking over the spte pgtable lock which is even not
a lock for current mm but someone else's.

It seems even racy on operating on the lock, as after put_page() of the
spte pgtable page logically the page can be released, so at least the
spin_unlock() needs to be done after the put_page().

No report I am aware, I'm not even sure whether it'll just work on taking
the spte pmd lock, because while we're holding i_mmap read lock it probably
means the vma interval tree is frozen, all pte allocators over this pud
entry could always find the specific svma and spte page, so maybe they'll
serialize on this spte page lock?  Even so, doesn't seem to be expected.
It just seems to be an accident of cb900f412154.

Fix it with the proper pud lock (which is the mm's page_table_lock).

Link: https://lkml.kernel.org/r/20230612160420.809818-1-peterx@redhat.com
Fixes: cb900f412154 ("mm, hugetlb: convert hugetlbfs to use split pmd lock")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-pgtable-lock-on-pmd-sharing
+++ a/mm/hugetlb.c
@@ -7130,7 +7130,6 @@ pte_t *huge_pmd_share(struct mm_struct *
 	unsigned long saddr;
 	pte_t *spte = NULL;
 	pte_t *pte;
-	spinlock_t *ptl;
 
 	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
@@ -7151,7 +7150,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (!spte)
 		goto out;
 
-	ptl = huge_pte_lock(hstate_vma(vma), mm, spte);
+	spin_lock(&mm->page_table_lock);
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
@@ -7159,7 +7158,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	} else {
 		put_page(virt_to_page(spte));
 	}
-	spin_unlock(ptl);
+	spin_unlock(&mm->page_table_lock);
 out:
 	pte = (pte_t *)pmd_alloc(mm, pud, addr);
 	i_mmap_unlock_read(mapping);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-pgtable-lock-on-pmd-sharing.patch

