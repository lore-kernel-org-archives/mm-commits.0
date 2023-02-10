Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13067C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjBJAqQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBJAqP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:46:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB691714
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:46:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65B12B82397
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D1FC433D2;
        Fri, 10 Feb 2023 00:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675989968;
        bh=Lvt9c5X1DipJaArg1P2CEdwOi6wu2CX7F9R5XhcHPfw=;
        h=Date:To:From:Subject:From;
        b=xcDLU07Ui+f79FARt8HtWHPZQiYD5xk/u3J8DzFvI0i3Z8CJDrkxOb3GBj24lOy4i
         xiL5n8V/KeW6VROxDRVv/r34jEC4XzeFDRHbpCvL48bYBloazfs7Mks5hIQ1ckB9t8
         kDShUMxO0Imo1U71oEg92rB9Dbcvm4CyEe6+2SNA=
Date:   Thu, 09 Feb 2023 16:46:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sanan.hasanov@knights.ucf.edu, hughd@google.com, david@redhat.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mmap-remove-__vma_adjust-fix.patch removed from -mm tree
Message-Id: <20230210004608.14D1FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: fix vma_merge() offset when expanding the next vma
has been removed from the -mm tree.  Its filename was
     mm-mmap-remove-__vma_adjust-fix.patch

This patch was dropped because it was folded into mm-mmap-remove-__vma_adjust.patch

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: fix vma_merge() offset when expanding the next vma
Date: Mon, 30 Jan 2023 14:57:13 -0500

The vm_pgoff was being set incorrectly when expanding the next VMA to a
lower address.  Fix the issue by using the mid->vm_pgoff value for this
merge case (aka case 8).  Note that this does not change case 3's vm_pgoff
as next and mid are the same VMA.

Link: https://lkml.kernel.org/r/20230130195713.2881766-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Sanan Hasanov <sanan.hasanov@knights.ucf.edu>
  Link: https://lore.kernel.org/linux-mm/IA1PR07MB983017D2FBA174D2FF78CEB6ABCE9@IA1PR07MB9830.namprd07.prod.outlook.com/
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-remove-__vma_adjust-fix
+++ a/mm/mmap.c
@@ -977,7 +977,7 @@ struct vm_area_struct *vma_merge(struct
 			vma = next;			/* case 3 */
 			vma_start = addr;
 			vma_end = next->vm_end;
-			vma_pgoff = next->vm_pgoff;
+			vma_pgoff = mid->vm_pgoff;
 			err = 0;
 			if (mid != next) {		/* case 8 */
 				remove = mid;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch
maple_tree-fix-mas_prev-and-mas_find-state-handling.patch
ipc-shm-introduce-new-do_vma_munmap-to-munmap.patch
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch
mm-mmap-remove-__vma_adjust.patch

