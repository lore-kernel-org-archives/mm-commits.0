Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5324A4A0F;
	Mon,  2 Sep 2024 00:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238781; cv=none; b=VJb4kJLpsg2eozUpl/NdpVGJGmSZvipxTL8zr3BQOtaKarVhP9OqtMRLelrEYmTdA8wi1U1s/EBuHsJWhqTvp6jjRyxuv+xh/ujHjB+btgeOEDxqBA83YCHlLX6qDLzPHFNIzI3CxAQ+awtEaLbJ+Wc1keYNzjwuy+iX280rf4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238781; c=relaxed/simple;
	bh=b0JEExeUuZQnI7NbAF4xnU+o5Z+3doOmj9zHBQ0EWvY=;
	h=Date:To:From:Subject:Message-Id; b=IJ0MA7h1S7NU4Y9Uk6V8Dw2xkbgzWE+sMZWHfQldDKMStDSraN4o7hAYrYhEZqjeU7b4urgZ1qCWA8TP1KVPsFO8TljCT+GPTNDYZpZXIfCpr1tGXSlpPEfwC9aLCCOmyNlb+hJLlTr5qiqBxJ4hnStVFCV0fDtW0rkxXLdFPv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HjQ5vh3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HjQ5vh3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95ADC4CEC3;
	Mon,  2 Sep 2024 00:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238780;
	bh=b0JEExeUuZQnI7NbAF4xnU+o5Z+3doOmj9zHBQ0EWvY=;
	h=Date:To:From:Subject:From;
	b=HjQ5vh3tCf64Q8aKwH2avaRz+G6w9MRFukyBlF6ae4uLfnOuRptiJ5Ru59uwS8GYz
	 SmlC8ttI7oXVNZcLl2yH/nzMX5cWuW2NQRXfatxZCtAu1vAJeiC5TR6AR+ZZaMQTed
	 ZP0qGxZqymHMQ4/vnrIPTn+iavqAe5WwPFVta1jU=
Date: Sun, 01 Sep 2024 17:59:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,paulmck@kernel.org,hdanton@sina.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-remove-rcu_read_lock-from-mt_validate.patch removed from -mm tree
Message-Id: <20240902005940.B95ADC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove rcu_read_lock() from mt_validate()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-rcu_read_lock-from-mt_validate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: remove rcu_read_lock() from mt_validate()
Date: Tue, 20 Aug 2024 13:54:17 -0400

The write lock should be held when validating the tree to avoid updates
racing with checks.  Holding the rcu read lock during a large tree
validation may also cause a prolonged rcu read window and "rcu_preempt
detected stalls" warnings.

Link: https://lore.kernel.org/all/0000000000001d12d4062005aea1@google.com/
Link: https://lkml.kernel.org/r/20240820175417.2782532-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reported-by: syzbot+036af2f0c7338a33b0cd@syzkaller.appspotmail.com
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-rcu_read_lock-from-mt_validate
+++ a/lib/maple_tree.c
@@ -7566,14 +7566,14 @@ static void mt_validate_nulls(struct map
  * 2. The gap is correctly set in the parents
  */
 void mt_validate(struct maple_tree *mt)
+	__must_hold(mas->tree->ma_lock)
 {
 	unsigned char end;
 
 	MA_STATE(mas, mt, 0, 0);
-	rcu_read_lock();
 	mas_start(&mas);
 	if (!mas_is_active(&mas))
-		goto done;
+		return;
 
 	while (!mte_is_leaf(mas.node))
 		mas_descend(&mas);
@@ -7594,9 +7594,6 @@ void mt_validate(struct maple_tree *mt)
 		mas_dfs_postorder(&mas, ULONG_MAX);
 	}
 	mt_validate_nulls(mt);
-done:
-	rcu_read_unlock();
-
 }
 EXPORT_SYMBOL_GPL(mt_validate);
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-extract-validate_mm-from-vma_complete.patch
mm-vma-inline-munmap-operation-in-mmap_region.patch
mm-vma-expand-mmap_region-munmap-call.patch
mm-vma-support-vma-==-null-in-init_vma_munmap.patch
mm-mmap-reposition-vma-iterator-in-mmap_region.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch
mm-clean-up-unmap_region-argument-list.patch
mm-mmap-avoid-zeroing-vma-tree-in-mmap_region.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch
mm-mmap-use-phys_pfn-in-mmap_region.patch
mm-mmap-use-vms-accounted-pages-in-mmap_region.patch
ipc-shm-mm-drop-do_vma_munmap.patch
mm-move-may_expand_vm-check-in-mmap_region.patch
mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch
mm-vmah-optimise-vma_munmap_struct.patch

