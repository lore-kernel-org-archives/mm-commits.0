Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3709C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiI0CyS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiI0Cwj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:52:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2F83AC
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF505B81982
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC70C433D6;
        Tue, 27 Sep 2022 02:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246979;
        bh=0W3vCOF6M0yXwqO3YQnAJgnkxWJSfJ1Mvl4nKhFQd1w=;
        h=Date:To:From:Subject:From;
        b=HZJU7rr1+TqfD8U8o0FEoqFtIcMzmWqec0ypx7mxDx6DKpn26irObLMkpGJE+FshP
         z2rf5yLB+Ak9qWsMfLaDbXzW1MlIqY2OfnR5Yxl8rSaXXDPdZfyiOwf9G3Yelo/kDu
         xcXvgamGgjoTv8tAhPgcsdh5zkMZ2EsZHoTnVcag=
Date:   Mon, 26 Sep 2022 19:49:38 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-use-maple-tree-navigation-instead-of-linked-list.patch removed from -mm tree
Message-Id: <20220927024939.7EC70C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: use maple tree navigation instead of linked list
has been removed from the -mm tree.  Its filename was
     mm-gup-use-maple-tree-navigation-instead-of-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/gup: use maple tree navigation instead of linked list
Date: Tue, 6 Sep 2022 19:49:00 +0000

Use find_vma_intersection() to locate the VMAs in __mm_populate() instead
of using find_vma() and the linked list.

Link: https://lkml.kernel.org/r/20220906194824.2110408-52-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-use-maple-tree-navigation-instead-of-linked-list
+++ a/mm/gup.c
@@ -1686,10 +1686,11 @@ int __mm_populate(unsigned long start, u
 		if (!locked) {
 			locked = 1;
 			mmap_read_lock(mm);
-			vma = find_vma(mm, nstart);
+			vma = find_vma_intersection(mm, nstart, end);
 		} else if (nstart >= vma->vm_end)
-			vma = vma->vm_next;
-		if (!vma || vma->vm_start >= end)
+			vma = find_vma_intersection(mm, vma->vm_end, end);
+
+		if (!vma)
 			break;
 		/*
 		 * Set [nstart; nend) to intersection of desired address
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


