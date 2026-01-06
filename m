Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B377633D4E6
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721021; cv=none; b=gDocfy2DoQ1JaNzrrrM2k/pp8hTZINTRxxX/7Cfkhusrd3xFebYgHmZYhNpBodnOScEzjyS0aZI/i9dayO/exhfz1n6ozM9253cnPkUHAB5Wf6NGPMWyUr9CvZY9Z1jN/FplYcAtxt8SkhmKpK2AyzYMiXEC5AAaoQna8RIHFdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721021; c=relaxed/simple;
	bh=xa0GJzSs5p6FPbhkAt5hhzzl/RbfQjV2kUm3JjWH1xw=;
	h=Date:To:From:Subject:Message-Id; b=FPH8539Iz4K3tG1tfynX1wDRTUzZ9M5tnBYJr4KubjlzPE8yH855rbJiAvyjPAxFlL3uomTA9/XMcEgr29c0bhrWpI/ro+9EcMKUzwv/UEm+NjeJ8fYOzf7N8ARZg3CqDmPlCxMi5c5xfhw5XhmmaHRU0o9GbzgZ4LAj0RIW3Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DuARXxaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DuARXxaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF27C16AAE;
	Tue,  6 Jan 2026 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767721021;
	bh=xa0GJzSs5p6FPbhkAt5hhzzl/RbfQjV2kUm3JjWH1xw=;
	h=Date:To:From:Subject:From;
	b=DuARXxaOvssFT30hh6GWjLu1j3FmZoo6S91xMkSJw9egwAU6cW3YWzNmKDxuLkNKI
	 SpHnao0yEXs+r8HfPPeBSp19tpc+A3Wg35z++dER/FPrw8ylZzJip3KzV/yur8ZNSo
	 cpCNYSW8UZD1RbUrwiQyizUGFcia94qLkAjp0/jA=
Date: Tue, 06 Jan 2026 09:37:00 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch added to mm-new branch
Message-Id: <20260106173701.6DF27C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
Date: Tue, 6 Jan 2026 15:04:27 +0000

For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
VMA to be linked are unfaulted (e.g.  !vma->anon_vma), then the functions
do nothing.  Simply exit early in these cases.

In the unlink_anon_vmas() case we can also remove a conditional that
checks whether vma->anon_vma is set.

Link: https://lkml.kernel.org/r/f0855a0b4e68d877baa222a636a8a14c4e820bf0.1767711638.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/rmap.c~mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink
+++ a/mm/rmap.c
@@ -314,6 +314,9 @@ int anon_vma_clone(struct vm_area_struct
 
 	check_anon_vma_clone(dst, src);
 
+	if (!src->anon_vma)
+		return 0;
+
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
@@ -474,7 +477,10 @@ void unlink_anon_vmas(struct vm_area_str
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
+	if (!vma->anon_vma) {
+		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
+		return;
+	}
 
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
@@ -498,15 +504,13 @@ void unlink_anon_vmas(struct vm_area_str
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	if (vma->anon_vma) {
-		vma->anon_vma->num_active_vmas--;
 
-		/*
-		 * vma would still be needed after unlink, and anon_vma will be prepared
-		 * when handle fault.
-		 */
-		vma->anon_vma = NULL;
-	}
+	vma->anon_vma->num_active_vmas--;
+	/*
+	 * vma would still be needed after unlink, and anon_vma will be prepared
+	 * when handle fault.
+	 */
+	vma->anon_vma = NULL;
 	unlock_anon_vma_root(root);
 
 	/*
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch
tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch

