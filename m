Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D0C270EAB
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646598; cv=none; b=ZUeLjGAHovHvXzEida049TN+9bhpUBAp8zSlI9+W17wp2LLu6LUlDamVwAhdp8xeqP5tIFSLwhmDTItJSCj1Ixb9TFFAthwyONLx0v94KBLDOLbk1M/z309R1uQ25ltUoUbyKsPeQgrKHJfugWDuo4Nmuei4qrdvM6f0PkeaBhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646598; c=relaxed/simple;
	bh=BqeRXyYG0h8TssUNb4pNjMnJGkUzBJ7TAv78RGdxOhI=;
	h=Date:To:From:Subject:Message-Id; b=JSp0FfzjEMmILYoV3yzZ7xgFeaeqque1NGO58oXgXttJOwQ/WRvlNqOMr2j8qDhuzvCdGguy4MvzvAFboiuFyIZQkIyS82I0/5QwF9it675fISmnSzXkGNMMShGPkf+vLKtUORb9gdq4u7XdfmpdppffKQqg43BcRQ98F4/cMFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DG6SpN80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DG6SpN80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FCFC4CEF1;
	Tue, 19 Aug 2025 23:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646597;
	bh=BqeRXyYG0h8TssUNb4pNjMnJGkUzBJ7TAv78RGdxOhI=;
	h=Date:To:From:Subject:From;
	b=DG6SpN80ztiqLg2PfKN5N7edmIIchvAGBZCouQEhQD9ZaWPv3CLXHYEbwnYf/ek1/
	 sG+W64f5FkR6hzj94tRBtBuExxEoXOriI8i/c8wRQjEwgaAdQrJ9DMptqeSe9ZebPi
	 Q879tGOjsu8dcRwHmVM5hJqOH4zsRk9PD3XJmyUc=
Date: Tue, 19 Aug 2025 16:36:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-catch-invalid-multi-vma-moves-earlier.patch removed from -mm tree
Message-Id: <20250819233637.D3FCFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: catch invalid multi VMA moves earlier
has been removed from the -mm tree.  Its filename was
     mm-mremap-catch-invalid-multi-vma-moves-earlier.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: catch invalid multi VMA moves earlier
Date: Sun, 3 Aug 2025 12:11:22 +0100

Previously, any attempt to solely move a VMA would require that the
span specified reside within the span of that single VMA, with no gaps
before or afterwards.

After commit d23cb648e365 ("mm/mremap: permit mremap() move of multiple
VMAs"), the multi VMA move permitted a gap to exist only after VMAs. 
This was done to provide maximum flexibility.

However, We have consequently permitted this behaviour for the move of
a single VMA including those not eligible for multi VMA move.

The change introduced here means that we no longer permit non-eligible
VMAs from being moved in this way.

This is consistent, as it means all eligible VMA moves are treated the
same, and all non-eligible moves are treated as they were before.

This change does not break previous behaviour, which equally would have
disallowed such a move (only in all cases).

[lorenzo.stoakes@oracle.com: do not incorrectly reference invalid VMA in VM_WARN_ON_ONCE()]
  Link: https://lkml.kernel.org/r/b6dbda20-667e-4053-abae-8ed4fa84bb6c@lucifer.local
Link: https://lkml.kernel.org/r/2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/mremap.c~mm-mremap-catch-invalid-multi-vma-moves-earlier
+++ a/mm/mremap.c
@@ -1820,10 +1820,11 @@ static unsigned long remap_move(struct v
 	unsigned long start = vrm->addr;
 	unsigned long end = vrm->addr + vrm->old_len;
 	unsigned long new_addr = vrm->new_addr;
-	bool allowed = true, seen_vma = false;
 	unsigned long target_addr = new_addr;
 	unsigned long res = -EFAULT;
 	unsigned long last_end;
+	bool seen_vma = false;
+
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	/*
@@ -1836,9 +1837,7 @@ static unsigned long remap_move(struct v
 		unsigned long addr = max(vma->vm_start, start);
 		unsigned long len = min(end, vma->vm_end) - addr;
 		unsigned long offset, res_vma;
-
-		if (!allowed)
-			return -EFAULT;
+		bool multi_allowed;
 
 		/* No gap permitted at the start of the range. */
 		if (!seen_vma && start < vma->vm_start)
@@ -1867,9 +1866,15 @@ static unsigned long remap_move(struct v
 		vrm->new_addr = target_addr + offset;
 		vrm->old_len = vrm->new_len = len;
 
-		allowed = vma_multi_allowed(vma);
-		if (seen_vma && !allowed)
-			return -EFAULT;
+		multi_allowed = vma_multi_allowed(vma);
+		if (!multi_allowed) {
+			/* This is not the first VMA, abort immediately. */
+			if (seen_vma)
+				return -EFAULT;
+			/* This is the first, but there are more, abort. */
+			if (vma->vm_end < end)
+				return -EFAULT;
+		}
 
 		res_vma = check_prep_vma(vrm);
 		if (!res_vma)
@@ -1878,7 +1883,7 @@ static unsigned long remap_move(struct v
 			return res_vma;
 
 		if (!seen_vma) {
-			VM_WARN_ON_ONCE(allowed && res_vma != new_addr);
+			VM_WARN_ON_ONCE(multi_allowed && res_vma != new_addr);
 			res = res_vma;
 		}
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch

