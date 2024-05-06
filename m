Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D047374C3
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957125; cv=none; b=l4zgHF6m8KrMBWBJDaMm+6mHb5nIE/B8aMeStw2tV5ZNQKwX9MHke+/3sZTpTYr+ZgIfA/W4xUMeJo43LHZfyAvk3VoEmBcog+DGDNQMrLgl/Eng949vQ4BpbGvR/W9S+WOnQ581dETKvmuu/mJeZNOpvv4WZxZhkLEJ8MY/PCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957125; c=relaxed/simple;
	bh=mfZhW5bOgBJzW5wb3i6N6mqv7VXMeXGF/1/rNGEvfs4=;
	h=Date:To:From:Subject:Message-Id; b=aczA0TdXNq2f2tRnsfusu7ChjPNmYc6Raaq+H3d0uO6Yz1BQJuZ0vqGeisE/UcEn9OkuLz/d9WtV/LuSR2ub1SqhdGZ+lNXhljMWn7g6ZkVy4TqFcYyS1ex6NtodXaQlMyHYrZCzPofnmjPERC0wDj6vwzdx71A6a11fm4zNwPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O7fO3xEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O7fO3xEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621D8C116B1;
	Mon,  6 May 2024 00:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957125;
	bh=mfZhW5bOgBJzW5wb3i6N6mqv7VXMeXGF/1/rNGEvfs4=;
	h=Date:To:From:Subject:From;
	b=O7fO3xEaSFB9EaLxRxBNWiPa6uUKU3haAXGNLhNgmjzcWkP6Lm3t5gSTOgU4t5dvK
	 3W5aS0l9r1pz5FFHwo5pChz1XrIzJt1/fRuD9IaaPjdtTLY0cxZAsfcd35MemxM2pu
	 HLSm0yN7Rw9h6M6jnC+FR/b+s8fhDOh22OUsori8=
Date: Sun, 05 May 2024 17:58:44 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,jannh@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch removed from -mm tree
Message-Id: <20240506005845.621D8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: assert the mmap_lock is held in __anon_vma_prepare()
has been removed from the -mm tree.  Its filename was
     mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: assert the mmap_lock is held in __anon_vma_prepare()
Date: Fri, 26 Apr 2024 15:45:00 +0100

Patch series "Improve anon_vma scalability for anon VMAs".

We have a 3x throughput improvement reported by Intel's kernel test robot:
https://lore.kernel.org/all/202404261055.c5e24608-oliver.sang@intel.com/

This is from delaying taking the mmap_lock for page faults until we
actually need the mmap_lock in order to assign an anon_vma to the vma.  It
cleans up the page fault path a little by making the anon fault handler
more similar to the file fault handler.


This patch (of 4):

Convert the comment into an assertion.

Link: https://lkml.kernel.org/r/20240426144506.1290619-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240426144506.1290619-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/rmap.c~mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare
+++ a/mm/rmap.c
@@ -182,8 +182,6 @@ static void anon_vma_chain_link(struct v
  * for the new allocation. At the same time, we do not want
  * to do any locking for the common case of already having
  * an anon_vma.
- *
- * This must be called with the mmap_lock held for reading.
  */
 int __anon_vma_prepare(struct vm_area_struct *vma)
 {
@@ -191,6 +189,7 @@ int __anon_vma_prepare(struct vm_area_st
 	struct anon_vma *anon_vma, *allocated;
 	struct anon_vma_chain *avc;
 
+	mmap_assert_locked(mm);
 	might_sleep();
 
 	avc = anon_vma_chain_alloc(GFP_KERNEL);
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

