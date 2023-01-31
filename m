Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88F7C636D3
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjAaACK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjAaABw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:01:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0616D34323
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78830B8091E
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BF9C433EF;
        Tue, 31 Jan 2023 00:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675123284;
        bh=MgP3cdIdJE38c6Ybwvl6WVzxgZX2I0DjGit+Rxl2N/c=;
        h=Date:To:From:Subject:From;
        b=vlOBxHO7af5HafbyXoY8yy1NYrRGAQLaVvhS1TyKCZ+ORBNub6rimoBLZsYaDIXPD
         51pHRFKQYc1qs0tmZa2kymqHqAtI7C6RofYwEw+7sikssXN//PgJvKyuR3O6p7eHNs
         i2RrOM/0Pwkxwco2vYOy2WaoUrERssk+Ddh2n7Ec=
Date:   Mon, 30 Jan 2023 16:01:23 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sanan.hasanov@knights.ucf.edu, hughd@google.com, david@redhat.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-remove-__vma_adjust-fix.patch added to mm-unstable branch
Message-Id: <20230131000124.18BF9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix vma_merge() offset when expanding the next vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-remove-__vma_adjust-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-remove-__vma_adjust-fix.patch

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
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
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
madvise-use-split_vma-instead-of-__split_vma-fix.patch
mm-change-munmap-splitting-order-and-move_vma-fix.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch
mm-mmap-remove-__vma_adjust-fix.patch

