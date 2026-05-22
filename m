Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BCB37B00C
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779478161; cv=none; b=n73DVN9BNyXwHC2H1Dx8PCKxutM6BUO7bvLjDNHBcH5T4uduGDpYZCyZ+1lMY3onaZIofJ51L8w7wUtQXxS76fYCcrdSJOAdHRIUMyrtMK5UPjGfJmh38B0NOhBKwlhLX2yBzJJ4q7UXvbkEVzBonHp7EkBNtfu2gMblXRxj0Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779478161; c=relaxed/simple;
	bh=t86SSg/dV2752SJQ0ng7cFhmrHpv6jTXeBOVFpUYjrs=;
	h=Date:To:From:Subject:Message-Id; b=XjVNWOEYNAbrKu49W6IsWGmCsAsWRor8OZCrwGTTrhsPhLvGD2H3XkqWeTlIDTO8rv0oxGhPKuRJx+iseIcKQK5tqvs9MYYcne1bIqk2/SxhRVBYx/ddw2p8VUhS4597a7EToxrP+MPJEPPE7GnxBkge1LLaYd4W/09mfZYqY8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gA7NDPUX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gA7NDPUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027911F000E9;
	Fri, 22 May 2026 19:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779478160;
	bh=FUGjC4yqJR0+54qIcJ914kHCFSf4OHcHPqb6aBnrg8E=;
	h=Date:To:From:Subject;
	b=gA7NDPUXT/G0dXlQQHWO2V+MV6q0UpLBWTSatM7xfgH/Oa49PzLz4UTzTvWoTdv36
	 eUr9P1R+ie71OEx9CMDqMVJFcv1FbkH2D/deIZhYHUqxxLtpLiyo0L7lUjOUJBsnMS
	 DDKNvOVs0q14haBQ/BIrzbMmwTklNNtLMwn2B2f4=
Date: Fri, 22 May 2026 12:29:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,gregkh@linuxfoundation.org,david@kernel.org,arnd@arndb.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-remove-mmap_action-success_hook.patch added to mm-new branch
Message-Id: <20260522192920.027911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: remove mmap_action->success_hook
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-remove-mmap_action-success_hook.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-remove-mmap_action-success_hook.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: remove mmap_action->success_hook
Date: Fri, 22 May 2026 17:00:10 +0100

This hook was introduced to work around code that seemed to absolutely
require access to a VMA pointer upon mmap().

However, providing this hook leaves a backdoor to drivers getting access
to the very thing mmap_prepare eliminates - a pointer to the VMA.

Let's solve this contradiction by removing it.  The key intended user was
hugetlb, however it seems that the best course now is to avoid allowing
all drivers the ability to work around mmap_prepare, and find a different
solution there.

Link: https://lore.kernel.org/2521c19866f3f10f9085d094cc4f06769042be71.1779462249.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h        |   10 ----------
 mm/util.c                       |    2 --
 tools/testing/vma/include/dup.h |   10 ----------
 3 files changed, 22 deletions(-)

--- a/include/linux/mm_types.h~mm-vma-remove-mmap_action-success_hook
+++ a/include/linux/mm_types.h
@@ -844,16 +844,6 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
-	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selected action.
 	 *
--- a/mm/util.c~mm-vma-remove-mmap_action-success_hook
+++ a/mm/util.c
@@ -1397,8 +1397,6 @@ static int mmap_action_finish(struct vm_
 
 	if (!err)
 		err = call_vma_mapped(vma);
-	if (!err && action->success_hook)
-		err = action->success_hook(vma);
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
--- a/tools/testing/vma/include/dup.h~mm-vma-remove-mmap_action-success_hook
+++ a/tools/testing/vma/include/dup.h
@@ -483,16 +483,6 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
-	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selection action.
 	 *
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-hugetlb-avoid-false-positive-lockdep-assertion.patch
mm-hugetlb-avoid-false-positive-lockdep-assertion-fix.patch
drivers-char-mem-eliminate-unnecessary-use-of-success_hook.patch
mm-vma-remove-mmap_action-success_hook.patch
mm-vma-eliminate-mmap_action-error_hook-introduce-error_filter.patch

