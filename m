Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C100C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357401AbiCYBd6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357432AbiCYBdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE6FBF024
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41B7E61937
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955E5C340EC;
        Fri, 25 Mar 2022 01:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171867;
        bh=xtUD++TStAE7Tb8sRC1T4i9va6PRB430ugjgxLUIYLg=;
        h=Date:To:From:Subject:From;
        b=Y153nP+1GZcQh57UTBJgfO4v8bxovAx8uK5H2pBmhUVApLxTsSx4q9jIs2fl19IG9
         ZaSHHT0McHgcGV4dvUp8NFuAThtaBmbqAyJO3FEBxaZ8KOr2K1MAUvxL7KjJnzLFrS
         1nYz/LW7bI+RcqgKxH3NLqoA094vS7Ga29YF4++U=
Date:   Thu, 24 Mar 2022 18:31:07 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mremap-use-vma_lookup-instead-of-find_vma.patch removed from -mm tree
Message-Id: <20220325013107.955E5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap:: use vma_lookup() instead of find_vma()
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-vma_lookup-instead-of-find_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mremap:: use vma_lookup() instead of find_vma()

Using vma_lookup() verifies the address is contained in the found vma. 
This results in easier to read code.

Link: https://lkml.kernel.org/r/20220312083118.48284-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-vma_lookup-instead-of-find_vma
+++ a/mm/mremap.c
@@ -942,8 +942,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
-	vma = find_vma(mm, addr);
-	if (!vma || vma->vm_start > addr) {
+	vma = vma_lookup(mm, addr);
+	if (!vma) {
 		ret = EFAULT;
 		goto out;
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

