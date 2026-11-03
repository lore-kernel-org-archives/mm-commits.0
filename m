Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672149;
	b=0hHC6KnpA0Xpur/p1n8jqzU+DJUCzfMlqHamGPNsjtBOl8kiT6nY+Xa7lH/C3WRuIRIP
	 Ys8KBOSuuGZrFvPqF8KYUSzbVJd7xXrj2Rp6Piv4DzUMuHtCu31fZx7Jc6eceTimoojYG
	 7R/LSXVjZimHzmfQsc2fITq4ADM5GfGZnD4kDPFeOlikSu1tquIktF643bBl37zoxc+Mv
	 eMkwCwn+uxk+e30M/kwOYKO6s8DVwR2jLc7yPwOijYfwNjBV1SUrGf70UacckR+FIvaRl
	 Zp32AreRrXzywLJfKpb17NojgCo2g+SnJ37o3lmTlnvBYS3SzaC9hPWlvRwkkMVR+sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672149;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GSvchxImhsRADPyNd+fzKJyoCxm4mWzX2q0i13yjFgk=;
	b=uje911wlP/E7uaOWrf/FyxgChgYc1SeV9an9+n02dZkk4fxDpoPOq7XEB0vlBkkKIKu3
	 kysHqENJq5jo7BSyqN+YueF7zDjs5vx7/XdcMOa+x+1sOe7MnzcOo+vdX6FjKg4i2XItz
	 +BWg241arLZr5UKgVVtjtiRzT5pgohE87uf6095B5kF0yNou4eW+JizxWDnTode3r79sh
	 xBNb4RyPP6pAbmuQkqUF4Pz8//4mDgLm7Bgxs7dokNfXjQfGQK4yGGtIakK7ywuqydNm1
	 8qA5RP73dPQt+fh4nR53rcD/IefCJ3IjnCaO507kqNpTvBcIPDOWpBmuQzZ1LqcgSrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZsU29Ya8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D67606A33F;
	Tue,  3 Nov 2026 02:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZsU29Ya8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9883A1F00919;
	Tue,  3 Nov 2026 02:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672148;
	bh=GSvchxImhsRADPyNd+fzKJyoCxm4mWzX2q0i13yjFgk=;
	h=Date:To:From:Subject;
	b=ZsU29Ya8wjBcqKvSbKGu8QzAqKT9tBHHPzoTkCzOyAN2nOE6T4jjkjvyULwIGm88j
	 xa5Tgga58TelBFjIogEwirerF4CZdf8seXSrxgJJeqhElKJPUMHb2Q4cogY9MGWe27
	 GmKy77UQsWU84KWfrWrOLB5h/JGRhCO+c4FOwB8o=
Date: Mon, 02 Nov 2026 18:15:48 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	pfalcato@suse.de,liam@infradead.org,jinyue.li@linux.alibaba.com,
	jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-update-vma-iterator-state-on-error-in-new-vma-merge.patch removed from -mm tree
Message-Id: <20261103021548.9883A1F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: update VMA iterator state on error in new VMA merge
has been removed from the -mm tree.  Its filename was
     mm-vma-update-vma-iterator-state-on-error-in-new-vma-merge.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: update VMA iterator state on error in new VMA merge
Date: Tue, 27 Oct 2026 11:25:20 +0000

Commit cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs") shared
code between vma_merge_new_range() and vma_expand().

However in doing so, it failed to correctly restore the VMA iterator when
vma_expand() errors out.

This is a problem when the immediately preceding VMA is mergeable and
vmg->just_expand isn't specified, at which point the VMA iterator is moved
to the previous VMA.

(Note that vmg->just_expand is a special case for brk(), where the
iterator will already be positioned at the VMA to be expanded.)

Resolve things by restoring the VMA iterator on error. Use
vma_iter_next_range() to do this, so it will correctly stop on the gap
after the previous VMA, rather than skip to the next VMA after it (this is
a new VMA merge, so is being applied at a gap).

To isolate the error handling, return early when a merge isn't
possible (what the vmg->target check was doing before), then handle the
merge success/failure case explicitly.

While here, update vma_expand() to jump to the nomem case when
dup_anon_vma() fails, so vmg->state is correctly updated.

This doesn't impact anything in practice, but is the correct course and
since it's part of the error path that this patch addresses, it makes sense
to update it also.

Users are very unlikely to have observed the issue this patch addresses in
practice, as it is near-impossible to fail an allocation for an anon_vma,
but a process under memory pressure that receives a fatal signal could
trigger it.

This issue was originally reported by Li Jinyue for which I am grateful. He
indicated this was uncovered by a private syzkaller instance.

Link: https://lore.kernel.org/20261027-fix-new-merge-bug-v1-1-7023a787e6b9@kernel.org
Fixes: cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Li Jinyue <jinyue.li@linux.alibaba.com>
Closes: https://lore.kernel.org/all/20261025093921.1011927-1-jinyue.li@linux.alibaba.com/
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
---

 mm/vma.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/mm/vma.c~mm-vma-update-vma-iterator-state-on-error-in-new-vma-merge
+++ a/mm/vma.c
@@ -1141,6 +1141,7 @@ struct vm_area_struct *vma_merge_new_ran
 	struct vm_area_struct *next = vmg->next;
 	unsigned long end = vmg->end;
 	bool can_merge_left, can_merge_right;
+	bool move_iter_back = false;
 
 	mmap_assert_write_locked(vmg->mm);
 	VM_WARN_ON_VMG(vmg->middle, vmg);
@@ -1182,23 +1183,30 @@ struct vm_area_struct *vma_merge_new_ran
 			vmg->end = end;
 
 		/* In expand-only case we are already positioned at prev. */
-		if (!vmg->just_expand) {
-			/* Equivalent to going to the previous range. */
-			vma_prev(vmg->vmi);
-		}
+		if (!vmg->just_expand)
+			move_iter_back = true;
 	}
 
+	if (!can_merge_left && !can_merge_right)
+		return NULL;
+
+	if (move_iter_back)
+		vma_prev(vmg->vmi);
+
 	/*
 	 * Now try to expand adjacent VMA(s). This takes care of removing the
 	 * following VMA if we have VMAs on both sides.
 	 */
-	if (vmg->target && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
-		vmg->state = VMA_MERGE_SUCCESS;
-		return vmg->target;
+	if (vma_expand(vmg)) {
+		/* Error occurred, restore iterator. */
+		if (move_iter_back)
+			vma_iter_next_range(vmg->vmi);
+		return NULL;
 	}
 
-	return NULL;
+	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+	vmg->state = VMA_MERGE_SUCCESS;
+	return vmg->target;
 }
 
 /*
@@ -1288,7 +1296,7 @@ int vma_expand(struct vma_merge_struct *
 	if (!ret && vmg->copied_from)
 		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
 	if (ret)
-		return ret;
+		goto nomem;
 
 	if (remove_next) {
 		vma_start_write(next);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch

