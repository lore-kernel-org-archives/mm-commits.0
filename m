Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E0712D1EF
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 21:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638218; cv=none; b=UYqLrypCKlW+jxiI2wyfazt5hhCIU23EjOgo4GbbSXMOJnErcTjES0ut5dzeE3poh+bgHYuNA32saQa/Q/O/aQhM0Lc9d8/94Mc4w2htW/UE9LZZv8MjM8xnACDCghqMuovKKkvUAMPqZYO9YflLwy7gq2WgW4jqT0w9k4XTfXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638218; c=relaxed/simple;
	bh=WY77f31SG9jyVsSO0ebRNzn7auVjUwEsM0YraGqDEOU=;
	h=Date:To:From:Subject:Message-Id; b=YpkHIwzd5786DxoqbGjeTBB0bqAWpPzNRquZjR9h4lRSu2R5XcHkmcxZk7X/xzAJ341kQgxns8R9CudWrG4+dkvJcrAWhD0TGsyV1n0SJ/ECc0BGRFsTyPxWBr8K/9Y9wEAoerDL2AKrKu2qdYSgcvgqq6VK7Ou2L3V2KvCkmO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1t2/ZO/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1t2/ZO/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7537C433F1;
	Thu, 22 Feb 2024 21:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708638217;
	bh=WY77f31SG9jyVsSO0ebRNzn7auVjUwEsM0YraGqDEOU=;
	h=Date:To:From:Subject:From;
	b=1t2/ZO/inHbUy2D71xX3sij/GI8C9JvvL1P3QUfedeSlseQOKrOpm2yQjyNKiBxq2
	 0+v2MayjBNkwDdIn76shuWlJPZHPQNuBuxdAENkhmZk/N0dmpQdbXTVqxMMsnN2zxD
	 XRYGUd7gAvp9G3r6nQORtqaQ5JXJRNWikuhqcYUg=
Date: Thu, 22 Feb 2024 13:43:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch added to mm-unstable branch
Message-Id: <20240222214337.D7537C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: pass struct vm_fault through to hugetlb_handle_userfault()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch

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
@@ -6172,39 +6172,21 @@ int hugetlb_add_to_page_cache(struct fol
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
@@ -6228,7 +6210,8 @@ static vm_fault_t hugetlb_no_page(struct
 			struct vm_area_struct *vma,
 			struct address_space *mapping, pgoff_t idx,
 			unsigned long address, pte_t *ptep,
-			pte_t old_pte, unsigned int flags)
+			pte_t old_pte, unsigned int flags,
+			struct vm_fault *vmf)
 {
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
@@ -6287,8 +6270,7 @@ static vm_fault_t hugetlb_no_page(struct
 				goto out;
 			}
 
-			return hugetlb_handle_userfault(vma, mapping, idx, flags,
-							haddr, address,
+			return hugetlb_handle_userfault(vmf, mapping,
 							VM_UFFD_MISSING);
 		}
 
@@ -6360,8 +6342,7 @@ static vm_fault_t hugetlb_no_page(struct
 				ret = 0;
 				goto out;
 			}
-			return hugetlb_handle_userfault(vma, mapping, idx, flags,
-							haddr, address,
+			return hugetlb_handle_userfault(vmf, mapping,
 							VM_UFFD_MINOR);
 		}
 	}
@@ -6531,9 +6512,8 @@ vm_fault_t hugetlb_fault(struct mm_struc
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

mm-memory-change-vmf_anon_prepare-to-be-non-static.patch
hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch
hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch
hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch
hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch

