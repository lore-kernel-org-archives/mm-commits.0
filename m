Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFD0EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjFSXYX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjFSXWX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498681726
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D41D860F60
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391D9C433C0;
        Mon, 19 Jun 2023 23:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216932;
        bh=hMUVVN5KJlFlXiagPk2zJ8bA6mD0U5OK9yO5xgUoDW4=;
        h=Date:To:From:Subject:From;
        b=KTJOlN+3qGR6mpSKta4ruURVgAdqXd/tp82rtArJnDtRlA8nHuHr3aCLVmrTAmw/N
         Zi6bjCio+CD/sFUTJMmO5MZ7RRyg7ZkQ+0iFi6qji8xIRYGQ4sZJ2RZJcelQglpjW1
         gGzDCdbCfTG+/0hmG3a07CRLE0bncCAk/AVqsC3k=
Date:   Mon, 19 Jun 2023 16:22:11 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-pgtable-lock-on-pmd-sharing.patch removed from -mm tree
Message-Id: <20230619232212.391D9C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix pgtable lock on pmd sharing
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-pgtable-lock-on-pmd-sharing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix pgtable lock on pmd sharing
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
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
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


