Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30679157A5A
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 19:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767902398; cv=none; b=JPfP73afEz+W73qp7wvWG9/6xEjZf2AfoaSNv3OUxW5oOBgQREYKY1o4JI32cP+HXyy0Fh3qSA1QxAbv3zFGewuQLARoGMcbGO4wMhD3o7DZnJs+YUKO6a9h8/UFJEVllZtBQeZedKDuFKoI2HlcevFPPl9TCHQTsV+aOTsrWSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767902398; c=relaxed/simple;
	bh=XikobkF5W4zet5rWGF1zOLIlw+uzgjt+iegIqkJ0FF8=;
	h=Date:To:From:Subject:Message-Id; b=F20eohAo2tlzRVGmxzdyZwpSs6rCrdWvXh5tIw89pWNt8ttNhFfGiyh6GCOIMnC1l5Mmq20V9UCg6/plU1GIIQLSphCHQd/M8LkkvPAh/J6V/nPK87y8iGt5SkkXqNG4Iq87v9uusJiFbhEhxXntl/IrMpw4iIOjTsFj1yqfwDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rBDnvfoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rBDnvfoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A438DC16AAE;
	Thu,  8 Jan 2026 19:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767902397;
	bh=XikobkF5W4zet5rWGF1zOLIlw+uzgjt+iegIqkJ0FF8=;
	h=Date:To:From:Subject:From;
	b=rBDnvfoRlRPhU0Q8oVrmzw0qp9Iuba8LHsv29wpYSMr6rREQ14HvlgJ7cHji3F6kC
	 9fTpSmW12rsqXAI0aelI0aDcmQiqOKslYL2kaSRbt8mzNbJLDfIa9GDJaV9XmNo94B
	 3tPynDqY3Dv36BjF0OW2MQ1NP3o4CC5fwBBYv9AE=
Date: Thu, 08 Jan 2026 11:59:57 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch added to mm-new branch
Message-Id: <20260108195957.A438DC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch

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
Subject: mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix
Date: Thu, 8 Jan 2026 18:49:07 +0000

fix comment, per Suren

Link: https://lkml.kernel.org/r/f0fe73fd-cb23-4670-b5ba-c716edfd115f@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix
+++ a/mm/rmap.c
@@ -297,8 +297,10 @@ int anon_vma_clone(struct vm_area_struct
 	 * are not updating the anon_vma rbtree nor are we changing
 	 * anon_vma statistics.
 	 *
-	 * We hold the exclusive mmap write lock so there's no possibliity of
-	 * the unlinked AVC's being observed yet.
+	* Either src, dst have the same mm for which we hold an exclusive mmap
+	* write lock, or we are forking and we hold it on src->vm_mm and dst is
+	* not yet accessible to other threads so there's no possibliity of the
+	* unlinked AVC's being observed yet.
 	 */
 	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
 		avc = anon_vma_chain_alloc(GFP_KERNEL);
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
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch

