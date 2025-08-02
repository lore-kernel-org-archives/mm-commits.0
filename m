Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CB019597F;
	Sat,  2 Aug 2025 18:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754159915; cv=none; b=p2QbvY50vwqhoKNkfceQhHZxgMB1uXDqYiVx2/LXU+seVa7SY924SUJ9TT8GZvN7G/Urmykyv5TX+/IzKJtkPrfRN5xElfIWxNiMigHi1W9XLd6dH5amCOhECxbWLoDi327K5ScnsY6mCG+yHa6YWf2ATqOVxcVfE6sdt8ZrxDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754159915; c=relaxed/simple;
	bh=45wEDMcEM9Xp6bYHF7XrqXuBSuChVRDLBhexj4WA+xc=;
	h=Date:To:From:Subject:Message-Id; b=TouNU+PGwtLS9Id47grOvYPmfcZ0XlgAbKd2N6ZsG6Myfe330gmAJhzkEXqNcswZLKq92FAkNXNXb/dEax1Z4QuQ062rKATBtomaig8WHHyT1D+HF6YuJZbyDTx3dUxVjIi7eLQLm2HG6ISjOh8/LNZ7/cW4vEHE3Z6Vk5B6viM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zZSryEHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zZSryEHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79BCC4CEEF;
	Sat,  2 Aug 2025 18:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754159914;
	bh=45wEDMcEM9Xp6bYHF7XrqXuBSuChVRDLBhexj4WA+xc=;
	h=Date:To:From:Subject:From;
	b=zZSryEHTdUBDfCC7eytHTWdldxQ+pdv6qjQLVjOaWkT0c8nw0kDTXwJmrQ+bBPipw
	 gLUj4sHWsRoZ2xD+EEPXAHqQMud4vDLATHgAQlRfEDzKghZW1gfWS6hlLButVt6feu
	 FP1UpxKN3Atg8p8r2zy78UzP7pGUnV2AYUvw4EvQ=
Date: Sat, 02 Aug 2025 11:38:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3.patch removed from -mm tree
Message-Id: <20250802183834.B79BCC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3
has been removed from the -mm tree.  Its filename was
     mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3.patch

This patch was dropped because it was folded into mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3
Date: Tue, 29 Jul 2025 07:57:09 -0700

- Addressed Lorenzo's nits, per Lorenzo Stoakes
- Added a warning comment for vma_start_read()
- Added Reviewed-by and Acked-by, per Vlastimil Babka and Lorenzo Stoakes

Link: https://lkml.kernel.org/r/20250729145709.2731370-1-surenb@google.com
Fixes: 3104138517fc ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
Reported-by: Jann Horn <jannh@google.com>
Closes: https://lore.kernel.org/all/CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    7 +++++++
 mm/mmap_lock.c            |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/mmap_lock.h~mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3
+++ a/include/linux/mmap_lock.h
@@ -155,6 +155,10 @@ static inline void vma_refcount_put(stru
  * reused and attached to a different mm before we lock it.
  * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
  * detached.
+ *
+ * WARNING! The vma passed to this function cannot be used if the function
+ * fails to lock it because in certain cases RCU lock is dropped and then
+ * reacquired. Once RCU lock is dropped the vma can be concurently freed.
  */
 static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 						    struct vm_area_struct *vma)
@@ -194,9 +198,12 @@ static inline struct vm_area_struct *vma
 	if (unlikely(vma->vm_mm != mm)) {
 		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
 		struct mm_struct *other_mm = vma->vm_mm;
+
 		/*
 		 * __mmdrop() is a heavy operation and we don't need RCU
 		 * protection here. Release RCU lock during these operations.
+		 * We reinstate the RCU read lock as the caller expects it to
+		 * be held when this function returns even on error.
 		 */
 		rcu_read_unlock();
 		mmgrab(other_mm);
--- a/mm/mmap_lock.c~mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3
+++ a/mm/mmap_lock.c
@@ -235,7 +235,7 @@ retry:
 		goto fallback;
 	}
 
-	/* Verify the vma is not behind of the last search position. */
+	/* Verify the vma is not behind the last search position. */
 	if (unlikely(from_addr >= vma->vm_end))
 		goto fallback_unlock;
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped.patch

