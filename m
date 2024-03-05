Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46158C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600526; cv=none; b=HNUB4Qvplj0bRraSHjAmiQUPdrZcpczCfEoOZPZbdpQLoCNto4IWy3fBqf6ZwvCth1o3retA9Agw821mBaSBkROKheOUkHwOTAQQm7SwpVV1XRsFpqcW8ToHZRcOsSemntgGcw4NaW3j0D+pEH8PKEa+eiM4l9OL+yrqCj/xJco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600526; c=relaxed/simple;
	bh=Pfn6JvQj509llEWLEl9LyILUc9W4/zlAb44x6j/BrjA=;
	h=Date:To:From:Subject:Message-Id; b=FSQRhy7unrLvUgcCo7a4b3BBIiVLS5XiypsWrqck8TVlkGZDm3RBsVBpIs47hTLDnEg8/GUe9nE07bchKF5yi4pKOEY0wpYzoEm4P7ceaF7tvkj95QnHAzLXqN7zLhYPrOgKuPvE/BvJvGgd49wPe0tM+/42buSYVGDQdpr4KiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BvGJ3X9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BvGJ3X9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD2FC43390;
	Tue,  5 Mar 2024 01:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600526;
	bh=Pfn6JvQj509llEWLEl9LyILUc9W4/zlAb44x6j/BrjA=;
	h=Date:To:From:Subject:From;
	b=BvGJ3X9xDGLX9CI3BB40Oizo2m6/0stdybgtc6UH5WgHkgvo28nO9HF4foKJ3JNBI
	 GEpSpMKlNyCowAlfGRKr7eub13zzM21Fg9H9m6NdxrTXMHATmC0GjA/tF1Jv9R757a
	 MTbxYPH1gFMUne9tK0vuIzCX7vacI+i814pkGHNQ=
Date: Mon, 04 Mar 2024 17:02:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch removed from -mm tree
Message-Id: <20240305010206.9CD2FC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: pass struct vm_fault through to hugetlb_handle_userfault()
has been removed from the -mm tree.  Its filename was
     hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: pass struct vm_fault through to hugetlb_handle_userfault()
Date: Wed, 21 Feb 2024 15:47:30 -0800

Now that hugetlb_fault() has a struct vm_fault, have
hugetlb_handle_userfault() use it instead of creating one of its own.

This lets us reduce the number of arguments passed to
hugetlb_handle_userfault() from 7 to 3, cleaning up the code and stack.

Link: https://lkml.kernel.org/r/20240221234732.187629-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

--- a/mm/hugetlb.c~hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault
+++ a/mm/hugetlb.c
@@ -6085,39 +6085,21 @@ int hugetlb_add_to_page_cache(struct fol
 	return 0;
 }
 
-static inline vm_fault_t hugetlb_handle_userfault(struct vm_area_struct *vma,
+static inline vm_fault_t hugetlb_handle_userfault(struct vm_fault *vmf,
 						  struct address_space *mapping,
-						  pgoff_t idx,
-						  unsigned int flags,
-						  unsigned long haddr,
-						  unsigned long addr,
 						  unsigned long reason)
 {
 	u32 hash;
-	struct vm_fault vmf = {
-		.vma = vma,
-		.address = haddr,
-		.real_address = addr,
-		.flags = flags,
-
-		/*
-		 * Hard to debug if it ends up being
-		 * used by a callee that assumes
-		 * something about the other
-		 * uninitialized fields... same as in
-		 * memory.c
-		 */
-	};
 
 	/*
 	 * vma_lock and hugetlb_fault_mutex must be dropped before handling
 	 * userfault. Also mmap_lock could be dropped due to handling
 	 * userfault, any vma operation should be careful from here.
 	 */
-	hugetlb_vma_unlock_read(vma);
-	hash = hugetlb_fault_mutex_hash(mapping, idx);
+	hugetlb_vma_unlock_read(vmf->vma);
+	hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-	return handle_userfault(&vmf, reason);
+	return handle_userfault(vmf, reason);
 }
 
 /*
@@ -6141,7 +6123,8 @@ static vm_fault_t hugetlb_no_page(struct
 			struct vm_area_struct *vma,
 			struct address_space *mapping, pgoff_t idx,
 			unsigned long address, pte_t *ptep,
-			pte_t old_pte, unsigned int flags)
+			pte_t old_pte, unsigned int flags,
+			struct vm_fault *vmf)
 {
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
@@ -6200,8 +6183,7 @@ static vm_fault_t hugetlb_no_page(struct
 				goto out;
 			}
 
-			return hugetlb_handle_userfault(vma, mapping, idx, flags,
-							haddr, address,
+			return hugetlb_handle_userfault(vmf, mapping,
 							VM_UFFD_MISSING);
 		}
 
@@ -6273,8 +6255,7 @@ static vm_fault_t hugetlb_no_page(struct
 				ret = 0;
 				goto out;
 			}
-			return hugetlb_handle_userfault(vma, mapping, idx, flags,
-							haddr, address,
+			return hugetlb_handle_userfault(vmf, mapping,
 							VM_UFFD_MINOR);
 		}
 	}
@@ -6444,9 +6425,8 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 * hugetlb_no_page will drop vma lock and hugetlb fault
 		 * mutex internally, which make us return immediately.
 		 */
-
 		return hugetlb_no_page(mm, vma, mapping, vmf.pgoff, address,
-					ptep, entry, flags);
+					ptep, entry, flags, &vmf);
 	}
 
 	ret = 0;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


