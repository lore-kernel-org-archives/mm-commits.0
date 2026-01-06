Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B095133DEFC
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721031; cv=none; b=poAdH0Vot8m2MoOuCFS4G+bNjtBFS0bi6gXEllfAS0ipYCBtsrMeccIFwxI6KfI94iHDyzybwTSFlllsJHKD33g2KGiQoPy7fpJA5IDUpzEMzdGxjLPBXD31IoDHCanTU3Q7I4bKycBzQqLcCuEMOSEU/peuhjBgtkpxnQ3ywHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721031; c=relaxed/simple;
	bh=r/Ww7FRlvvoXtL/dxRR1RFybm/RnhcLqizo5l5HHWGY=;
	h=Date:To:From:Subject:Message-Id; b=LNw8lIczTpV9KZZ79j1y+cOF3u3QTIfj7xQv6Tym7LLMnEq6YAfZGr+jnDtI+h+qQwYW4cEa7/5F8vbti6X+23Lb8k84i7nY7Q4mDeuGq1WpGhWgvHuY0NgkxbFpwzrbG9fusXAL6FkxmOn6vwpmkA9QKyvCYgniJhnf8Wf5+04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ghRP3w4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ghRP3w4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A002C116C6;
	Tue,  6 Jan 2026 17:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767721031;
	bh=r/Ww7FRlvvoXtL/dxRR1RFybm/RnhcLqizo5l5HHWGY=;
	h=Date:To:From:Subject:From;
	b=ghRP3w4x5nPTJ81NJLQ6fZc83vD68bC/IL0D/cBTlm2mYIh+z2kaUhdB2wHK4pR72
	 Z3Mm1qvKoi1XIMGkIRwvO/XbauMkaIw0vIkxBNxr0e0QItJiFDNB598mW5jtWj+LHQ
	 R+b2g95VJsSg5cjvXk57KuEb2Os4gANVOgj/sbJc=
Date: Tue, 06 Jan 2026 09:37:10 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap_lock-add-vma_is_attached-helper.patch added to mm-new branch
Message-Id: <20260106173711.6A002C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap_lock: add vma_is_attached() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-mmap_lock-add-vma_is_attached-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap_lock-add-vma_is_attached-helper.patch

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
Subject: mm/mmap_lock: add vma_is_attached() helper
Date: Tue, 6 Jan 2026 15:04:31 +0000

This makes it easy to explicitly check for VMA detachment, which is useful
for things like asserts.

Note that we intentionally do not allow this function to be available
should CONFIG_PER_VMA_LOCK be set - this is because vma_assert_attached()
and vma_assert_detached() are no-ops if !CONFIG_PER_VMA_LOCK, so there is
no correct state for vma_is_attached() to be in if this configuration
option is not specified.

Therefore users elsewhere must invoke this function only after checking
for CONFIG_PER_VMA_LOCK.

We rework the assert functions to utilise this.

Link: https://lkml.kernel.org/r/38f916c87fb873ba8866707d51f5da8ba10c5de9.1767711638.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h~mm-mmap_lock-add-vma_is_attached-helper
+++ a/include/linux/mmap_lock.h
@@ -251,6 +251,11 @@ static inline void vma_assert_locked(str
 		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -258,12 +263,12 @@ static inline void vma_assert_locked(str
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_mark_attached(struct vm_area_struct *vma)
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

