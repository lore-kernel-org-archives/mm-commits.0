Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB91C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 16:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbiGMQS5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 12:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiGMQS4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 12:18:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DDCE001
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 09:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D568FB8203D
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 16:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF7EC34114;
        Wed, 13 Jul 2022 16:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657729132;
        bh=dPvEI2rhdIGJ+7PwDNLokpvhxDmGbFoQpn98FckROkM=;
        h=Date:To:From:Subject:From;
        b=F5A5UcrRTukcipJIKa7NafOoHGVO4Bq+/0ymYd5f7uAHYE9V6J7VmlLBVLq+foA2N
         n6YJUI+/hYxn0nLUHYg8a1RxDK5bGzwQtQKga5tA3LyPWik9WvXFp1gpTOfH5bMm0+
         bE887A2mzYFOKdRwwOvmAGi1MJDdCXE6OWV69tL0=
Date:   Wed, 13 Jul 2022 09:18:51 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        hughd@google.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch added to mm-unstable branch
Message-Id: <20220713161852.6FF7EC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix return on maple tree expand fail in brk()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: fix return on maple tree expand fail in brk()
Date: Tue, 12 Jul 2022 14:51:08 +0000

When do_brk_flags() fails, ensure the necessary locking is undone.

Link: https://lkml.kernel.org/r/20220712145059.4191132-1-Liam.Howlett@oracle.com
Fixes: e9bad648fe05 (mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap())
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix
+++ a/mm/mmap.c
@@ -2965,7 +2965,7 @@ static int do_brk_flags(struct ma_state
 		vma->vm_end = addr + len;
 		vma->vm_flags |= VM_SOFTDIRTY;
 		if (mas_store_gfp(mas, vma, GFP_KERNEL))
-			return -ENOMEM;
+			goto mas_expand_failed;
 
 		if (vma->anon_vma) {
 			anon_vma_interval_tree_post_update_vma(vma);
@@ -3013,6 +3013,13 @@ mas_store_fail:
 vma_alloc_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
 	return -ENOMEM;
+
+mas_expand_failed:
+	if (vma->anon_vma) {
+		anon_vma_interval_tree_post_update_vma(vma);
+		anon_vma_unlock_write(vma->anon_vma);
+	}
+	return -ENOMEM;
 }
 
 int vm_brk_flags(unsigned long addr, unsigned long request, unsigned long flags)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-3.patch
mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch
mm-remove-the-vma-linked-list-fix-3.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

