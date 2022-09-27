Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A780C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiI0Cvp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiI0Ctl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B15B1BB4
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AAC5B81901
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586C3C433D7;
        Tue, 27 Sep 2022 02:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246930;
        bh=d44aHTpl0b/gwm63u4t1hRr7DWa/5gh7Q32az8qPaiY=;
        h=Date:To:From:Subject:From;
        b=qBCwIB3L3d8u9MKuAYYgsJR9I0WShJGQQgeD+El3FsdCU+eAkCNuyOY8TykJiNS9t
         rKwIO2zt5BojPpHsDPuAX+uzRhcYqMV7z0aqsJruFw/S4fQ9n3dbo3f98ZVaIzGrcD
         ejT26Q1VKms5RnOe0LGvteICN0dat2eOW95paxJ4=
Date:   Mon, 26 Sep 2022 19:48:49 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kernel-fork-use-maple-tree-for-dup_mmap-during-forking.patch removed from -mm tree
Message-Id: <20220927024850.586C3C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/fork: use maple tree for dup_mmap() during forking
has been removed from the -mm tree.  Its filename was
     kernel-fork-use-maple-tree-for-dup_mmap-during-forking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: kernel/fork: use maple tree for dup_mmap() during forking
Date: Tue, 6 Sep 2022 19:48:47 +0000

The maple tree was already tracking VMAs in this function by an earlier
commit, but the rbtree iterator was being used to iterate the list.
Change the iterator to use a maple tree native iterator and switch to the
maple tree advanced API to avoid multiple walks of the tree during insert
operations.  Unexport the now-unused vma_store() function.

For performance reasons we bulk allocate the maple tree nodes.  The node
calculations are done internally to the tree and use the VMA count and
assume the worst-case node requirements.  The VM_DONT_COPY flag does not
allow for the most efficient copy method of the tree and so a bulk loading
algorithm is used.

Link: https://lkml.kernel.org/r/20220906194824.2110408-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 kernel/fork.c      |   15 +++++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~kernel-fork-use-maple-tree-for-dup_mmap-during-forking
+++ a/include/linux/mm.h
@@ -2599,8 +2599,6 @@ extern bool arch_has_descending_max_zone
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
-/* mmap.c */
-void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas);
 
 /* interval_tree.c */
 void vma_interval_tree_insert(struct vm_area_struct *node,
--- a/kernel/fork.c~kernel-fork-use-maple-tree-for-dup_mmap-during-forking
+++ a/kernel/fork.c
@@ -583,8 +583,9 @@ static __latent_entropy int dup_mmap(str
 	struct vm_area_struct *mpnt, *tmp, *prev, **pprev;
 	struct rb_node **rb_link, *rb_parent;
 	int retval;
-	unsigned long charge;
+	unsigned long charge = 0;
 	LIST_HEAD(uf);
+	MA_STATE(old_mas, &oldmm->mm_mt, 0, 0);
 	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	uprobe_start_dup_mmap();
@@ -620,7 +621,12 @@ static __latent_entropy int dup_mmap(str
 		goto out;
 
 	prev = NULL;
-	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
+
+	retval = mas_expected_entries(&mas, oldmm->map_count);
+	if (retval)
+		goto out;
+
+	mas_for_each(&old_mas, mpnt, ULONG_MAX) {
 		struct file *file;
 
 		if (mpnt->vm_flags & VM_DONTCOPY) {
@@ -703,6 +709,8 @@ static __latent_entropy int dup_mmap(str
 		mas.index = tmp->vm_start;
 		mas.last = tmp->vm_end - 1;
 		mas_store(&mas, tmp);
+		if (mas_is_err(&mas))
+			goto fail_nomem_mas_store;
 
 		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
@@ -726,6 +734,9 @@ out:
 fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
+
+fail_nomem_mas_store:
+	unlink_anon_vmas(tmp);
 fail_nomem_anon_vma_fork:
 	mpol_put(vma_policy(tmp));
 fail_nomem_policy:
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


