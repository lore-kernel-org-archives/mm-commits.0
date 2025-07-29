Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9682E2550C2;
	Tue, 29 Jul 2025 19:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753818698; cv=none; b=oUUQUGb4VQrmIZamKs5W8U2ap+6zTpBt3E7BikB0fEBfPh8HdOq8F7ATui5BOn7vAqe9pMhdCoeRY1i17FhRrkAG5fHyXr+ZRAZnQK5XE3m1cw1nynuxNiQ//6nD+vDsclVc8SVrV7O6ihMfvgvuFyve20m7z98aN1/doJfAIwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753818698; c=relaxed/simple;
	bh=q2S8U1ciBfQTHyN+dfvvDmFzPPQgh+W3lJmwr8gcIHE=;
	h=Date:To:From:Subject:Message-Id; b=BjS+CuvTtvM5MvXRm3kdu1j/TxFwllTjNZUDKlinEJq4FsLGuLzz8oBU4Nnz3QnWxqkRBcC+9pJT4ZprkjGYJtAFpZZDjbEXHI+4FbKMi+65QCllqizvVwJSSGtvv3O6dE9BJK6ZTnRD4Duf6J9/skye2UTfVKbh86GDLJRe+cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wOHgRkbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wOHgRkbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4293BC4CEF7;
	Tue, 29 Jul 2025 19:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753818698;
	bh=q2S8U1ciBfQTHyN+dfvvDmFzPPQgh+W3lJmwr8gcIHE=;
	h=Date:To:From:Subject:From;
	b=wOHgRkbELklwxJkk/fCwvbd7HD4uH4gkCdEB6EXVTZNuUUuw2JPkb1Io7vfToh++3
	 2rUyGmw0Hzm6ewWKEjd2VoXp4T87pWKHMM/Xk0ive0/V1Z0m6e6cPp7TXWLqYK2YiL
	 bVZ89GHdFeIz6U5S+ETo++FEF1fA6aFzS2N23YGk=
Date: Tue, 29 Jul 2025 12:51:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3.patch added to mm-unstable branch
Message-Id: <20250729195138.4293BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped-v3.patch

