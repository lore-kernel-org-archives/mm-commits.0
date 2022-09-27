Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EE0C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiI0C4N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiI0CyL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:54:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8969C183BC
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B56F7615B5
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABA7C433B5;
        Tue, 27 Sep 2022 02:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246995;
        bh=XvaS4QEwLhirV9g4szWp3LD7q1BBioWPocxhsog+sro=;
        h=Date:To:From:Subject:From;
        b=PtR6aYThazUf05tOlqauAoVBsDTnWvbZUcnNDyv5PPl1qMlMhQ+H7e66Fc0CbPtqi
         0qr3U2E1vAAu1XaOW9EIMhThNSA4QVuSL9HFRTI6lutdUQDuzQoMfBXN1zmMvuTuv4
         B0J3pPZmS7d1EaWetQrpMLb1g13bkPgLvooDVEBg=
Date:   Mon, 26 Sep 2022 19:49:54 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-use-vma-iterator-instead-of-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024955.1ABA7C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile: use vma iterator instead of vma linked list
has been removed from the -mm tree.  Its filename was
     mm-swapfile-use-vma-iterator-instead-of-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/swapfile: use vma iterator instead of vma linked list
Date: Tue, 6 Sep 2022 19:49:04 +0000

unuse_mm() no longer needs to reference the linked list.

Link: https://lkml.kernel.org/r/20220906194824.2110408-64-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-use-vma-iterator-instead-of-vma-linked-list
+++ a/mm/swapfile.c
@@ -1994,14 +1994,16 @@ static int unuse_mm(struct mm_struct *mm
 {
 	struct vm_area_struct *vma;
 	int ret = 0;
+	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_read_lock(mm);
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+	for_each_vma(vmi, vma) {
 		if (vma->anon_vma) {
 			ret = unuse_vma(vma, type);
 			if (ret)
 				break;
 		}
+
 		cond_resched();
 	}
 	mmap_read_unlock(mm);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


