Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2E12973CE
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745870046; cv=none; b=dI+v4gEaEeLj5GT2ipq8Uei7FzCG/10g6JW7N2htdAaKAAbt9HszEIiL1NbvjxNfuIdY15mj3gCPSr9onBw21TFuT4d1b+CBB5rBuHFkb1JK2V6PsfTH/ADER5fhuRcGCpqCtDTy9YQae8bTkfTRUDm6UWSn2vMx0f8M/nurPK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745870046; c=relaxed/simple;
	bh=eHC7SqB6lasT6O5ZiLueMD/VK4IdZvYqqAF0KMHfn4o=;
	h=Date:To:From:Subject:Message-Id; b=FMtKV9QJIF0MGpEWivpy1ksKC9tsjFjG5xJVTBPZ+EaH9Ug09B+Q57Rwjbp4QhRRfAd0HZ87+OFYGDCv7wXWvS3vuyXfBZIM+rqcYXQjM74mKSLrRJpqEn+75ifLA+duYpvWwcXn9sJ0HMXzb11wL65HSzgzomQDny3TPA03sE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cXAkBYw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cXAkBYw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47077C4CEE4;
	Mon, 28 Apr 2025 19:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745870046;
	bh=eHC7SqB6lasT6O5ZiLueMD/VK4IdZvYqqAF0KMHfn4o=;
	h=Date:To:From:Subject:From;
	b=cXAkBYw84v0Yvk43eqX1+q9g/53Q8QJCAMYTyFXhGhVDQQeUhickF+CHmlEdleGFq
	 hdqcN/U9ccREEzdH8ZDSCn14MnTpujwE5ogdhfd2NPlV4KaXdS3b/2HeAvRSuHqOIn
	 IPia3Cyo8+pN3DwGUCUnAB1xtTZKxiuTLPDCZa3w=
Date: Mon, 28 Apr 2025 12:54:05 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch added to mm-new branch
Message-Id: <20250428195406.47077C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-perform-vma-allocation-freeing-duplication-in-mm-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch

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
Subject: mm-perform-vma-allocation-freeing-duplication-in-mm-fix
Date: Mon Apr 28 12:52:37 PM PDT 2025

remove stray newline, per Liam

Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vma.h~mm-perform-vma-allocation-freeing-duplication-in-mm-fix
+++ a/mm/vma.h
@@ -548,7 +548,6 @@ int expand_downwards(struct vm_area_stru
 
 int __vm_munmap(unsigned long start, size_t len, bool unlock);
 
-
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma);
 
 /* vma_init.h, shared between CONFIG_MMU and nommu. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-zblock-allocator-fix.patch
mm-zblock-avoid-failing-the-build-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch

