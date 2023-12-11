Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1D03C21
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o8XJtOwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FC1C433C8;
	Mon, 11 Dec 2023 00:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256066;
	bh=EnB/QMntVAuhf8Cs+O+YUwaqMxSmSjXvzIxreo1AeBM=;
	h=Date:To:From:Subject:From;
	b=o8XJtOwA6S2JYG4+eq3BD38EQrWrhXJHllrqSh7fMQDVyJyvjexL/KcEJNM6pGMfE
	 Uv+n78JTs8YPhIAtYRDbe9iNcu7dQM+0m8k6iANPxiwg21Uy9cMthab2ZqRsv4Z93H
	 GcVjU82NeeUYTlFuRFTMoOrdXmZn49IJL8xuz4e0=
Date: Sun, 10 Dec 2023 16:54:26 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,ardb@kernel.org,lukas.bulwahn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmap-remove-the-ia64-specific-vma-expansion-implementation.patch removed from -mm tree
Message-Id: <20231211005426.84FC1C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mmap: remove the IA64-specific vma expansion implementation
has been removed from the -mm tree.  Its filename was
     mmap-remove-the-ia64-specific-vma-expansion-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mmap: remove the IA64-specific vma expansion implementation
Date: Mon, 13 Nov 2023 13:47:28 +0100

With commit cf8e8658100d ("arch: Remove Itanium (IA-64) architecture"),
there is no need to keep the IA64-specific vma expansion.

Clean up the IA64-specific vma expansion implementation.

Link: https://lkml.kernel.org/r/20231113124728.3974-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

--- a/mm/mmap.c~mmap-remove-the-ia64-specific-vma-expansion-implementation
+++ a/mm/mmap.c
@@ -2207,42 +2207,7 @@ struct vm_area_struct *find_extend_vma_l
 }
 #endif
 
-/*
- * IA64 has some horrid mapping rules: it can expand both up and down,
- * but with various special rules.
- *
- * We'll get rid of this architecture eventually, so the ugliness is
- * temporary.
- */
-#ifdef CONFIG_IA64
-static inline bool vma_expand_ok(struct vm_area_struct *vma, unsigned long addr)
-{
-	return REGION_NUMBER(addr) == REGION_NUMBER(vma->vm_start) &&
-		REGION_OFFSET(addr) < RGN_MAP_LIMIT;
-}
-
-/*
- * IA64 stacks grow down, but there's a special register backing store
- * that can grow up. Only sequentially, though, so the new address must
- * match vm_end.
- */
-static inline int vma_expand_up(struct vm_area_struct *vma, unsigned long addr)
-{
-	if (!vma_expand_ok(vma, addr))
-		return -EFAULT;
-	if (vma->vm_end != (addr & PAGE_MASK))
-		return -EFAULT;
-	return expand_upwards(vma, addr);
-}
-
-static inline bool vma_expand_down(struct vm_area_struct *vma, unsigned long addr)
-{
-	if (!vma_expand_ok(vma, addr))
-		return -EFAULT;
-	return expand_downwards(vma, addr);
-}
-
-#elif defined(CONFIG_STACK_GROWSUP)
+#if defined(CONFIG_STACK_GROWSUP)
 
 #define vma_expand_up(vma,addr) expand_upwards(vma, addr)
 #define vma_expand_down(vma, addr) (-EFAULT)
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are


