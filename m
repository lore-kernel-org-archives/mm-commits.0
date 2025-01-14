Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA88C23C700
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837003; cv=none; b=of6dTqEn/RCXwRg4TJHpT1f5X9PJ/0DvplMgm03Gd12INcoNZO0KykeHQCNGOUj41cBr1L6xA8i7g8BoQ89cjZyX4LD62AYdnE22uWhTMRQhRHhPLSvqUp1JPYrhPHcRqtCdB5l5R0mnTHtFA0SHd++PDRK60I6N3OYvUrzPIic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837003; c=relaxed/simple;
	bh=PawOefPAdtSvqvJIUhB+mQTuoJBc+eNLpAxJcV5iLhQ=;
	h=Date:To:From:Subject:Message-Id; b=XWX74p7bxucGRYczjuabhdbJV74zkjokh915bFn9Qb8CPwl5lcHZIljMkzGbYWpHGtSZrvQTOFX1ivLXMQIp+SzJH+SBBgMRTNL/bEkPFFZELMGlae4hQaJCxudBeE1Y9t6H0Ns2RMbzlfy9U8Zr0LHygEJ+yClSMzq3dNCeRi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qXtAHHmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qXtAHHmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A998C4CEDD;
	Tue, 14 Jan 2025 06:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837003;
	bh=PawOefPAdtSvqvJIUhB+mQTuoJBc+eNLpAxJcV5iLhQ=;
	h=Date:To:From:Subject:From;
	b=qXtAHHmBCw5g33T0rMijW+Xx1pwfdiGc5eSmT6SO+o35rKK+fwFxbv0wCo+es60iA
	 SHaCbKQRmLr6uvs0BR+0oCNUFdjxLGKUCorZ6o8gD2MiyjVP4j5uW4PlSk1MUGRVqF
	 ah5KwSvhgcSQsl4s4M9HFo9GGbDj6tPQkpt6gt98=
Date: Mon, 13 Jan 2025 22:43:23 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch removed from -mm tree
Message-Id: <20250114064323.8A998C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zap_install_uffd_wp_if_needed: return whether uffd-wp pte has been re-installed
has been removed from the -mm tree.  Its filename was
     mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: zap_install_uffd_wp_if_needed: return whether uffd-wp pte has been re-installed
Date: Wed, 4 Dec 2024 19:09:46 +0800

In some cases, we'll replace the none pte with an uffd-wp swap special pte
marker when necessary.  Let's expose this information to the caller
through the return value, so that subsequent commits can use this
information to detect whether the PTE page is empty.

Link: https://lkml.kernel.org/r/9d4516554724eda87d6576468042a1741c475413.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   11 +++++++----
 mm/memory.c               |   16 ++++++++++++----
 2 files changed, 19 insertions(+), 8 deletions(-)

--- a/include/linux/mm_inline.h~mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed
+++ a/include/linux/mm_inline.h
@@ -564,9 +564,9 @@ static inline pte_marker copy_pte_marker
  * Must be called with pgtable lock held so that no thread will see the none
  * pte, and if they see it, they'll fault and serialize at the pgtable lock.
  *
- * This function is a no-op if PTE_MARKER_UFFD_WP is not enabled.
+ * Returns true if an uffd-wp pte was installed, false otherwise.
  */
-static inline void
+static inline bool
 pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			      pte_t *pte, pte_t pteval)
 {
@@ -583,7 +583,7 @@ pte_install_uffd_wp_if_needed(struct vm_
 	 * with a swap pte.  There's no way of leaking the bit.
 	 */
 	if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
-		return;
+		return false;
 
 	/* A uffd-wp wr-protected normal pte */
 	if (unlikely(pte_present(pteval) && pte_uffd_wp(pteval)))
@@ -596,10 +596,13 @@ pte_install_uffd_wp_if_needed(struct vm_
 	if (unlikely(pte_swp_uffd_wp_any(pteval)))
 		arm_uffd_pte = true;
 
-	if (unlikely(arm_uffd_pte))
+	if (unlikely(arm_uffd_pte)) {
 		set_pte_at(vma->vm_mm, addr, pte,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
+		return true;
+	}
 #endif
+	return false;
 }
 
 static inline bool vma_has_recency(struct vm_area_struct *vma)
--- a/mm/memory.c~mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed
+++ a/mm/memory.c
@@ -1466,27 +1466,35 @@ static inline bool zap_drop_markers(stru
 /*
  * This function makes sure that we'll replace the none pte with an uffd-wp
  * swap special pte marker when necessary. Must be with the pgtable lock held.
+ *
+ * Returns true if uffd-wp ptes was installed, false otherwise.
  */
-static inline void
+static inline bool
 zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 			      unsigned long addr, pte_t *pte, int nr,
 			      struct zap_details *details, pte_t pteval)
 {
+	bool was_installed = false;
+
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	/* Zap on anonymous always means dropping everything */
 	if (vma_is_anonymous(vma))
-		return;
+		return false;
 
 	if (zap_drop_markers(details))
-		return;
+		return false;
 
 	for (;;) {
 		/* the PFN in the PTE is irrelevant. */
-		pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
+		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
+			was_installed = true;
 		if (--nr == 0)
 			break;
 		pte++;
 		addr += PAGE_SIZE;
 	}
+#endif
+	return was_installed;
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


