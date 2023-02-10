Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEF4C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjBJAwr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjBJAwh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25F16D8E1
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25C18CE270D
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE6BC4339C;
        Fri, 10 Feb 2023 00:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990353;
        bh=mdopme00rHzMW0h9oBZ/rMpWsfaw2CoIDcHu9DyHw3s=;
        h=Date:To:From:Subject:From;
        b=gP7cfb9r1qkuL8Q2+oFqvI3qcc4B9Pb2ZMLdrCTNbzGa1yfMUkqBvJXMUUXgnWvN3
         R6UvXmae+Um9nUzSL7F247PUcEGKDqFmBKnZIDDxrDcLna41buimrovwPapviCa8Y8
         AzNKDH8p0VUhJh6UPQti0oxVRLxkooLFX26z9kzU=
Date:   Thu, 09 Feb 2023 16:52:33 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kernel-fork-convert-forking-to-using-the-vmi-iterator.patch removed from -mm tree
Message-Id: <20230210005233.7BE6BC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/fork: convert forking to using the vmi iterator
has been removed from the -mm tree.  Its filename was
     kernel-fork-convert-forking-to-using-the-vmi-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: kernel/fork: convert forking to using the vmi iterator
Date: Fri, 20 Jan 2023 11:26:10 -0500

Avoid using the maple tree interface directly.  This gains type safety.

Link: https://lkml.kernel.org/r/20230120162650.984577-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/kernel/fork.c~kernel-fork-convert-forking-to-using-the-vmi-iterator
+++ a/kernel/fork.c
@@ -585,8 +585,8 @@ static __latent_entropy int dup_mmap(str
 	int retval;
 	unsigned long charge = 0;
 	LIST_HEAD(uf);
-	MA_STATE(old_mas, &oldmm->mm_mt, 0, 0);
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(old_vmi, oldmm, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	uprobe_start_dup_mmap();
 	if (mmap_write_lock_killable(oldmm)) {
@@ -613,11 +613,11 @@ static __latent_entropy int dup_mmap(str
 		goto out;
 	khugepaged_fork(mm, oldmm);
 
-	retval = mas_expected_entries(&mas, oldmm->map_count);
+	retval = vma_iter_bulk_alloc(&vmi, oldmm->map_count);
 	if (retval)
 		goto out;
 
-	mas_for_each(&old_mas, mpnt, ULONG_MAX) {
+	for_each_vma(old_vmi, mpnt) {
 		struct file *file;
 
 		if (mpnt->vm_flags & VM_DONTCOPY) {
@@ -683,11 +683,8 @@ static __latent_entropy int dup_mmap(str
 			hugetlb_dup_vma_private(tmp);
 
 		/* Link the vma into the MT */
-		mas.index = tmp->vm_start;
-		mas.last = tmp->vm_end - 1;
-		mas_store(&mas, tmp);
-		if (mas_is_err(&mas))
-			goto fail_nomem_mas_store;
+		if (vma_iter_bulk_store(&vmi, tmp))
+			goto fail_nomem_vmi_store;
 
 		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
@@ -702,7 +699,7 @@ static __latent_entropy int dup_mmap(str
 	/* a new mm has just been created */
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
-	mas_destroy(&mas);
+	vma_iter_free(&vmi);
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
@@ -712,7 +709,7 @@ fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
 
-fail_nomem_mas_store:
+fail_nomem_vmi_store:
 	unlink_anon_vmas(tmp);
 fail_nomem_anon_vma_fork:
 	mpol_put(vma_policy(tmp));
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


