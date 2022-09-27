Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A76EC32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiI0Cz3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiI0Cxr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:53:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A642C10565
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F30E9B81985
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E830C433C1;
        Tue, 27 Sep 2022 02:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246988;
        bh=lIPpksljzGzTxRrgiCT9QwSOg/W9ABi/Ayb4nJQ+WWM=;
        h=Date:To:From:Subject:From;
        b=H7jZHZP8M+rYnxY3AXUIHkiEts3Z++hK78CVXpeEIO12FW26nwTvJ4WAO8qtStWJW
         hqlfpf7mB+6SLmKDcDFKvaucAiDkPdLQVyBVezf9ZefGlkLGr1THWLWvWTfb2VP+ZX
         u/8SWRKwNFksw18UoYyi1ptaU9zup6pw9i7JUNcc=
Date:   Mon, 26 Sep 2022 19:49:47 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024948.9E830C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: use maple tree navigation instead of VMA linked list
has been removed from the -mm tree.  Its filename was
     mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mprotect: use maple tree navigation instead of VMA linked list
Date: Tue, 6 Sep 2022 19:49:02 +0000

Switch to navigating the VMA list with the maple tree operators in
preparation for removing the linked list.

Link: https://lkml.kernel.org/r/20220906194824.2110408-59-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list
+++ a/mm/mprotect.c
@@ -676,6 +676,7 @@ static int do_mprotect_pkey(unsigned lon
 	const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
 				(prot & PROT_READ);
 	struct mmu_gather tlb;
+	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 
 	start = untagged_addr(start);
 
@@ -707,7 +708,8 @@ static int do_mprotect_pkey(unsigned lon
 	if ((pkey != -1) && !mm_pkey_is_allocated(current->mm, pkey))
 		goto out;
 
-	vma = find_vma(current->mm, start);
+	mas_set(&mas, start);
+	vma = mas_find(&mas, ULONG_MAX);
 	error = -ENOMEM;
 	if (!vma)
 		goto out;
@@ -733,7 +735,7 @@ static int do_mprotect_pkey(unsigned lon
 	if (start > vma->vm_start)
 		prev = vma;
 	else
-		prev = vma->vm_prev;
+		prev = mas_prev(&mas, 0);
 
 	tlb_gather_mmu(&tlb, current->mm);
 	for (nstart = start ; ; ) {
@@ -796,7 +798,7 @@ static int do_mprotect_pkey(unsigned lon
 		if (nstart >= end)
 			break;
 
-		vma = prev->vm_next;
+		vma = find_vma(current->mm, prev->vm_end);
 		if (!vma || vma->vm_start != nstart) {
 			error = -ENOMEM;
 			break;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


