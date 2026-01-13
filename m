Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2579A30AD0A;
	Tue, 13 Jan 2026 05:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280988; cv=none; b=T3TM6t7njrrckXBjPC7ea8a1NzTM5Xeu2YXnyVbz+l/xkIOUsp9cTP0Y/GWHoTlH5agXDacpbgnqcHGRHDxmPmfiYtzjUTXXhZn27mBb7IZBfIJoj5D7fSdFAh8LB1m86e3dKWRdZBLbCPPZEMncaDoUrlIeTMGQbRATYBICNq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280988; c=relaxed/simple;
	bh=Tfu8gLPvwd+2HB6/Nu1pWQeGgnRkLIakjoirVZifhRk=;
	h=Date:To:From:Subject:Message-Id; b=JccztclWkieIxDZWPzHl6oxNiS9ywF7erO/BFpat3JcL65rvn0HieQy1p1SP3IA9u/MF7JJCxhxoajyLI4/dAwuhG5ZZjIcTtfknUMmAkS49+b368R3AXOAuGOQ2H/fLHNSnIBeGkLR62+80q/ENXECBAVuSur92PAq3OK7CIhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1xwqvNsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1xwqvNsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0792C116C6;
	Tue, 13 Jan 2026 05:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280988;
	bh=Tfu8gLPvwd+2HB6/Nu1pWQeGgnRkLIakjoirVZifhRk=;
	h=Date:To:From:Subject:From;
	b=1xwqvNsuzXTyWgHAPcaxER/CZw/P0SCNHTzG2UzpDK2f1rfYOduZUQrMH/LDbk511
	 26QvushzRwpgIpv+ZNldEvQK4ZdwvbuGKskWwsk9iYtxuZKJL+METqJdvI3UaZPVol
	 DpH2YYRcUij1j+BHQ8FCLeBhuujVJNUq3S4pMfmU=
Date: Mon, 12 Jan 2026 21:09:47 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,pfalcato@suse.de,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,aha310510@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch removed from -mm tree
Message-Id: <20260113050947.F0792C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
has been removed from the -mm tree.  Its filename was
     mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
Date: Mon, 5 Jan 2026 20:11:49 +0000

The is_mergeable_anon_vma() function uses vmg->middle as the source VMA. 
However when merging a new VMA, this field is NULL.

In all cases except mremap(), the new VMA will either be newly established
and thus lack an anon_vma, or will be an expansion of an existing VMA thus
we do not care about whether VMA is CoW'd or not.

In the case of an mremap(), we can end up in a situation where we can
accidentally allow an unfaulted/faulted merge with a VMA that has been
forked, violating the general rule that we do not permit this for reasons
of anon_vma lock scalability.

Now we have the ability to be aware of the fact we are copying a VMA and
also know which VMA that is, we can explicitly check for this, so do so.

This is pertinent since commit 879bca0a2c4f ("mm/vma: fix incorrectly
disallowed anonymous VMA merges"), as this patch permits unfaulted/faulted
merges that were previously disallowed running afoul of this issue.

While we are here, vma_had_uncowed_parents() is a confusing name, so make
it simple and rename it to vma_is_fork_child().

Link: https://lkml.kernel.org/r/6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Jeongjun Park <aha310510@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/vma.c~mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too
+++ a/mm/vma.c
@@ -67,18 +67,13 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
-/*
- * If, at any point, the VMA had unCoW'd mappings from parents, it will maintain
- * more than one anon_vma_chain connecting it to more than one anon_vma. A merge
- * would mean a wider range of folios sharing the root anon_vma lock, and thus
- * potential lock contention, we do not wish to encourage merging such that this
- * scales to a problem.
- */
-static bool vma_had_uncowed_parents(struct vm_area_struct *vma)
+/* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
+static bool vma_is_fork_child(struct vm_area_struct *vma)
 {
 	/*
 	 * The list_is_singular() test is to avoid merging VMA cloned from
-	 * parents. This can improve scalability caused by anon_vma lock.
+	 * parents. This can improve scalability caused by the anon_vma root
+	 * lock.
 	 */
 	return vma && vma->anon_vma && !list_is_singular(&vma->anon_vma_chain);
 }
@@ -115,11 +110,19 @@ static bool is_mergeable_anon_vma(struct
 	VM_WARN_ON(src && src_anon != src->anon_vma);
 
 	/* Case 1 - we will dup_anon_vma() from src into tgt. */
-	if (!tgt_anon && src_anon)
-		return !vma_had_uncowed_parents(src);
+	if (!tgt_anon && src_anon) {
+		struct vm_area_struct *copied_from = vmg->copied_from;
+
+		if (vma_is_fork_child(src))
+			return false;
+		if (vma_is_fork_child(copied_from))
+			return false;
+
+		return true;
+	}
 	/* Case 2 - we will simply use tgt's anon_vma. */
 	if (tgt_anon && !src_anon)
-		return !vma_had_uncowed_parents(tgt);
+		return !vma_is_fork_child(tgt);
 	/* Case 3 - the anon_vma's are already shared. */
 	return src_anon == tgt_anon;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch

