Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE8E217447;
	Thu,  7 Nov 2024 22:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017727; cv=none; b=QMZr8JcWhri0+/JwkY3F7xyOuChJnffGKHq6pUTmJ0PYCEV7NofPAMv5TPK4fkm/x142IuH5Kmu1OHX8wbC4DXDyoKiTBNeTB6GnQLkKJQurUOy8sQdISyrjkNk8CIWziUHMDzhoBBDnMREoqM7CRj7wtTOIMUC3M0n9wUvasas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017727; c=relaxed/simple;
	bh=uJc4C/47j7E5Xqkgw44LmQywUlBjlezpwo+5+ONbFeM=;
	h=Date:To:From:Subject:Message-Id; b=YIgUUBlrEJ4ANuAt9PyG31Jycv6XJkjHcZFE8CttsenWenMNqNc5C0L72iEL6UE5U176FaYehgkhBCX51MbcCL55W6NoeK0KBNTJ41+7IjyOgKpzMnrzJR+4oGMnS0BBDrIj0aTVMVgZGXemg3xLe63TqyBnandYu3MLxvDta1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kbNLKp2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kbNLKp2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316FEC4CECC;
	Thu,  7 Nov 2024 22:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017727;
	bh=uJc4C/47j7E5Xqkgw44LmQywUlBjlezpwo+5+ONbFeM=;
	h=Date:To:From:Subject:From;
	b=kbNLKp2L8DfmGSnr9xpO9MOTRo0H1Y69+ocz9iiUZeEe3esGB1ETi9PO31QKFl1D3
	 27eFJ+aZAY86vAI64QHSO3qd5ElC8YKyWtQXuqGwGQ+VmCT3Ebb/WmAhpLLsA0op7s
	 9GaKOBt7kfwKLnAv4px8v3pOr6HHZIM/Q25HFrpc=
Date: Thu, 07 Nov 2024 14:15:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mlock-set-the-correct-prev-on-failure.patch removed from -mm tree
Message-Id: <20241107221527.316FEC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mlock: set the correct prev on failure
has been removed from the -mm tree.  Its filename was
     mm-mlock-set-the-correct-prev-on-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mlock: set the correct prev on failure
Date: Sun, 27 Oct 2024 12:33:21 +0000

After commit 94d7d9233951 ("mm: abstract the vma_merge()/split_vma()
pattern for mprotect() et al."), if vma_modify_flags() return error, the
vma is set to an error code.  This will lead to an invalid prev be
returned.

Generally this shouldn't matter as the caller should treat an error as
indicating state is now invalidated, however unfortunately
apply_mlockall_flags() does not check for errors and assumes that
mlock_fixup() correctly maintains prev even if an error were to occur.

This patch fixes that assumption.

[lorenzo.stoakes@oracle.com: provide a better fix and rephrase the log]
Link: https://lkml.kernel.org/r/20241027123321.19511-1-richard.weiyang@gmail.com
Fixes: 94d7d9233951 ("mm: abstract the vma_merge()/split_vma() pattern for mprotect() et al.")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/mlock.c~mm-mlock-set-the-correct-prev-on-failure
+++ a/mm/mlock.c
@@ -725,14 +725,17 @@ static int apply_mlockall_flags(int flag
 	}
 
 	for_each_vma(vmi, vma) {
+		int error;
 		vm_flags_t newflags;
 
 		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
 		newflags |= to_add;
 
-		/* Ignore errors */
-		mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
-			    newflags);
+		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
+				    newflags);
+		/* Ignore errors, but prev needs fixing up. */
+		if (error)
+			prev = vma;
 		cond_resched();
 	}
 out:
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

