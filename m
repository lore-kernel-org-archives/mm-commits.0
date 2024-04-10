Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E831DFC7;
	Wed, 10 Apr 2024 20:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712780459; cv=none; b=PB58VKs+MI8BBwOZi5dL9KsDUTe9M0FQbf0zat5e7BSoVQnGbU4VrnMKan6Ixut+BZvsj/FFNRD1ESTewj7tx7lZYtPcoK4Dd7pc2t4fAqwjry4eWXx9xr0qyzfadxDMRtA2gM9EfDwZnTntikNBfky4HLmNOEkCy1OhQziyNVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712780459; c=relaxed/simple;
	bh=x+u0sZaPD3FIAjuBF4ZC5Hl9+7I5kNg2LpJKIORwZWc=;
	h=Date:To:From:Subject:Message-Id; b=Ne/zW67vscXOi4T2szCRdJ7bm9qyzyC0IFHQf5BSjRweBHDgWzWndXS6g1bj34TIkhpKAeSrkoGt0G8FN4cDHaDG/b2BlADScuDUFB+pjdSvE3OrZOcgQ+lMiClrRmR0WH+REGp6uF98qhs5670t211iq0ZJnmhmdD0NqbKen08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JiMnAAqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JiMnAAqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5A4C433F1;
	Wed, 10 Apr 2024 20:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712780459;
	bh=x+u0sZaPD3FIAjuBF4ZC5Hl9+7I5kNg2LpJKIORwZWc=;
	h=Date:To:From:Subject:From;
	b=JiMnAAqrpEuGR0zVPmDsCtGNlSxUZ9btsaNvZt12an5Ief+ZlXFCtBwmFlUD34Ryf
	 pEMo3nB92jSGB0HgEWhbtqYmVwUs9vVLUiPsah2/bwaBUKMojTg2rlnFmdhKv3UTU1
	 Xm6aXouUbRmRmUng5wekEPnLVC/BWe7sgQLK1yNI=
Date: Wed, 10 Apr 2024 13:20:58 -0700
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,willy@infradead.org,thorvald@google.com,tandersen@netflix.com,stable@vger.kernel.org,oleg@redhat.com,muchun.song@linux.dev,mjguzik@gmail.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,jane.chu@oracle.com,hca@linux.ibm.com,brauner@kernel.org,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-defer-linking-file-vma-until-vma-is-fully-initialized.patch added to mm-hotfixes-unstable branch
Message-Id: <20240410202059.1E5A4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: defer linking file vma until vma is fully initialized
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fork-defer-linking-file-vma-until-vma-is-fully-initialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-defer-linking-file-vma-until-vma-is-fully-initialized.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: fork: defer linking file vma until vma is fully initialized
Date: Wed, 10 Apr 2024 17:14:41 +0800

Thorvald reported a WARNING [1]. And the root cause is below race:

 CPU 1					CPU 2
 fork					hugetlbfs_fallocate
  dup_mmap				 hugetlbfs_punch_hole
   i_mmap_lock_write(mapping);
   vma_interval_tree_insert_after -- Child vma is visible through i_mmap tree.
   i_mmap_unlock_write(mapping);
   hugetlb_dup_vma_private -- Clear vma_lock outside i_mmap_rwsem!
					 i_mmap_lock_write(mapping);
   					 hugetlb_vmdelete_list
					  vma_interval_tree_foreach
					   hugetlb_vma_trylock_write -- Vma_lock is cleared.
   tmp->vm_ops->open -- Alloc new vma_lock outside i_mmap_rwsem!
					   hugetlb_vma_unlock_write -- Vma_lock is assigned!!!
					 i_mmap_unlock_write(mapping);

hugetlb_dup_vma_private() and hugetlb_vm_op_open() are called outside
i_mmap_rwsem lock while vma lock can be used in the same time.  Fix this
by deferring linking file vma until vma is fully initialized.  Those vmas
should be initialized first before they can be used.

Link: https://lkml.kernel.org/r/20240410091441.3539905-1-linmiaohe@huawei.com
Fixes: 8d9bfb260814 ("hugetlb: add vma based lock for pmd sharing")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: Thorvald Natvig <thorvald@google.com>
Closes: https://lore.kernel.org/linux-mm/20240129161735.6gmjsswx62o4pbja@revolver/T/ [1]
Cc: Christian Brauner <brauner@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Tycho Andersen <tandersen@netflix.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/kernel/fork.c~fork-defer-linking-file-vma-until-vma-is-fully-initialized
+++ a/kernel/fork.c
@@ -714,6 +714,23 @@ static __latent_entropy int dup_mmap(str
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		vm_flags_clear(tmp, VM_LOCKED_MASK);
+		/*
+		 * Copy/update hugetlb private vma information.
+		 */
+		if (is_vm_hugetlb_page(tmp))
+			hugetlb_dup_vma_private(tmp);
+
+		/*
+		 * Link the vma into the MT. After using __mt_dup(), memory
+		 * allocation is not necessary here, so it cannot fail.
+		 */
+		vma_iter_bulk_store(&vmi, tmp);
+
+		mm->map_count++;
+
+		if (tmp->vm_ops && tmp->vm_ops->open)
+			tmp->vm_ops->open(tmp);
+
 		file = tmp->vm_file;
 		if (file) {
 			struct address_space *mapping = file->f_mapping;
@@ -730,25 +747,9 @@ static __latent_entropy int dup_mmap(str
 			i_mmap_unlock_write(mapping);
 		}
 
-		/*
-		 * Copy/update hugetlb private vma information.
-		 */
-		if (is_vm_hugetlb_page(tmp))
-			hugetlb_dup_vma_private(tmp);
-
-		/*
-		 * Link the vma into the MT. After using __mt_dup(), memory
-		 * allocation is not necessary here, so it cannot fail.
-		 */
-		vma_iter_bulk_store(&vmi, tmp);
-
-		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
 			retval = copy_page_range(tmp, mpnt);
 
-		if (tmp->vm_ops && tmp->vm_ops->open)
-			tmp->vm_ops->open(tmp);
-
 		if (retval) {
 			mpnt = vma_next(&vmi);
 			goto loop_out;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch
fork-defer-linking-file-vma-until-vma-is-fully-initialized.patch

