Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3404C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiI0CzL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiI0CxP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:53:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A685F12767
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B8B5615B8
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECECCC433D7;
        Tue, 27 Sep 2022 02:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246990;
        bh=yOkec6wKUS8Vic8sScNSs0bkw7kFLZJBnjEZ0e9cHS4=;
        h=Date:To:From:Subject:From;
        b=EBcNxG7oDc6OunwZjDjllq00e/PLxnv51oPyQquSu6mi3tMDPQkVru/yfCqp7vpKl
         wMQp5XLabJvguKLeDMmth/7oZ99dLxTAKeMWslf/6rQMmec9yxACxFqx3Q/umzjMna
         iEOpK3VmX7jecelJ6qmX59iJ6aDfy/QNSxygbjok=
Date:   Mon, 26 Sep 2022 19:49:49 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-use-vma_find_intersection-instead-of-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024949.ECECCC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mremap: use vma_find_intersection() instead of vma linked list
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-vma_find_intersection-instead-of-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mremap: use vma_find_intersection() instead of vma linked list
Date: Tue, 6 Sep 2022 19:49:03 +0000

Using the vma_find_intersection() call allows for cleaner code and
removes linked list users in preparation of the linked list removal.

Also remove one user of the linked list at the same time in favour of
find_vma().

Link: https://lkml.kernel.org/r/20220906194824.2110408-60-Liam.Howlett@oracle.com
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

 mm/mremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-vma_find_intersection-instead-of-vma-linked-list
+++ a/mm/mremap.c
@@ -716,7 +716,7 @@ static unsigned long move_vma(struct vm_
 	if (excess) {
 		vma->vm_flags |= VM_ACCOUNT;
 		if (split)
-			vma->vm_next->vm_flags |= VM_ACCOUNT;
+			find_vma(mm, vma->vm_end)->vm_flags |= VM_ACCOUNT;
 	}
 
 	return new_addr;
@@ -866,9 +866,10 @@ out:
 static int vma_expandable(struct vm_area_struct *vma, unsigned long delta)
 {
 	unsigned long end = vma->vm_end + delta;
+
 	if (end < vma->vm_end) /* overflow */
 		return 0;
-	if (vma->vm_next && vma->vm_next->vm_start < end) /* intersection */
+	if (find_vma_intersection(vma->vm_mm, vma->vm_end, end))
 		return 0;
 	if (get_unmapped_area(NULL, vma->vm_start, end - vma->vm_start,
 			      0, MAP_FIXED) & ~PAGE_MASK)
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


