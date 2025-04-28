Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82BD15748F
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745881667; cv=none; b=JGuproT48b25Nnb7U2xchto/DUNJ3v4SJAsai4HasEgplpWbusZ43Lakvo3DOS3qkIXSlaS8bmOmayMQ3PMj14XXLBTiVTA2aR35DfG7rQ3O6hC2ZXwnk3dkSWKVSIttKaWZ6qUScD+NHfY01KXnvGPu1emrBO9wfhYTcezDwYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745881667; c=relaxed/simple;
	bh=5KVI9nZUuWcbYDFfN1yyPD+dIXQqsVlpGCa9XHTpiyw=;
	h=Date:To:From:Subject:Message-Id; b=kvl5Tjt3ebN2xj6da0QrLGfKSfU8fchjlZZ1iUoBC0L42+gwb+aipsQhfLsMxsfNqRXlWSHMEzOCQtLRjzfLEUduZI/we3ecL+TR0pWahMekJ/81NXW/MKD30YhQ2/GToR/8jYPRgr/wmcwlEV7QhLaIsFbvFsWDDCMYgOfw49g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BQ0Jtca1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BQ0Jtca1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2DDC4CEE4;
	Mon, 28 Apr 2025 23:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745881667;
	bh=5KVI9nZUuWcbYDFfN1yyPD+dIXQqsVlpGCa9XHTpiyw=;
	h=Date:To:From:Subject:From;
	b=BQ0Jtca191c6zhDS0U/LEWdWkL3YkA/fCet9hrcqZmIWFM2zslx9OwqyRPorm//49
	 1oQqdtXYcey+jyQANWKYIb/rkeneNDOH8Xf1zAbHpD/TcEVjpkpaUOVZ0rl6nlzA6b
	 /g4HDEiSs5rxxw58VvAdq6zVAY+N+X6dO4rflUn0=
Date: Mon, 28 Apr 2025 16:07:46 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch added to mm-new branch
Message-Id: <20250428230747.7C2DDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix
Date: Mon Apr 28 04:06:02 PM PDT 2025

fix comment typo

Link: https://lkml.kernel.org/r/80f0d0c6-0b68-47f9-ab78-0ab7f74677fc@lucifer.local
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.h~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix
+++ a/mm/vma.h
@@ -548,7 +548,7 @@ int expand_downwards(struct vm_area_stru
 
 int __vm_munmap(unsigned long start, size_t len, bool unlock);
 
-/* vma_exec.h */
+/* vma_exec.c */
 #ifdef CONFIG_MMU
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-zblock-allocator-fix.patch
mm-zblock-avoid-failing-the-build-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch

