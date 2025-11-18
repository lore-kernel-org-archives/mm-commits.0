Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D5B31ED80
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 17:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763488300; cv=none; b=gXjJ1vd3ohNcKZcFXzvV2TzuVnGOT3GNViNGwq0oiOI0ok8uPi/D49osQ1YAf/qJxBhQY84UyCSMOnfkgu88rnDQF8aWgG8WzzzErKbmiO0VmPEG1mCAdzPQ5swNoI2cNunnXJ+bjVz2j5RWnZeSuBYPG7S+0Bdcuv2XbEZvfsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763488300; c=relaxed/simple;
	bh=3f/7iZ4FOofigfxOjS5pxCtn1OWePk1ryzrMYRzrooE=;
	h=Date:To:From:Subject:Message-Id; b=mwn5lsQzyT3/+G+upNY2KRuidnSszakxEIQd87hRGXGbQdnUVZGPh/FWvhUEX4SMfg5kKZrdM1KJSmSwzk4DShiYyKt5/PUBs/xOtGlr2eq0zoszUkw+iiWRuZpf8u461YlxeVkY8CBFMcYFgJAbTaOOKKYLf+WchQsGo7iy19w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T7luDWLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T7luDWLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7667C4CEF5;
	Tue, 18 Nov 2025 17:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763488300;
	bh=3f/7iZ4FOofigfxOjS5pxCtn1OWePk1ryzrMYRzrooE=;
	h=Date:To:From:Subject:From;
	b=T7luDWLxJoueVQmsz3blIYufXvufsMxmBPGy5/5d8NY2waxfQJtgSxutTrtGneXXh
	 DtpvmbQxlgzke/7QYcM0g8xZFtTnxTIKyDLS5coS2DeOUmR4QtpY3gpXTwm5QwTmKG
	 Xw4fssH549oEeIlBa1MrYGGsfjN4ks2GBAnnCbKM=
Date: Tue, 18 Nov 2025 09:51:38 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,robh@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jack@suse.cz,debug@rivosinc.com,david@redhat.com,conor@kernel.org,conor.dooley@microchip.com,brauner@kernel.org,axelrasmussen@google.com,arnd@arndb.de,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,alex@ghiti.fr,ajones@ventanamicro.com,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-add-pgtable_supports_uffd_wp.patch added to mm-new branch
Message-Id: <20251118175139.C7667C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: userfaultfd: add pgtable_supports_uffd_wp()
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-add-pgtable_supports_uffd_wp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-add-pgtable_supports_uffd_wp.patch

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
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Subject: mm: userfaultfd: add pgtable_supports_uffd_wp()
Date: Thu, 13 Nov 2025 15:28:02 +0800

Some platforms can customize the PTE/PMD entry uffd-wp bit making it
unavailable even if the architecture provides the resource.  This patch
adds a macro API pgtable_supports_uffd_wp() that allows architectures to
define their specific implementations to check if the uffd-wp bit is
available on which device the kernel is running.

Also this patch is removing "ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP" and
"ifdef CONFIG_PTE_MARKER_UFFD_WP" in favor of pgtable_supports_uffd_wp()
and uffd_supports_wp_marker() checks respectively that default to
IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) and
"IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) &&
IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP)" if not overridden by the
architecture, no change in behavior is expected.

Link: https://lkml.kernel.org/r/20251113072806.795029-3-zhangchunyan@iscas.ac.cn
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Conor Dooley <conor.dooley@microchip.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                   |   22 ++++----
 include/asm-generic/pgtable_uffd.h |   17 ++++++
 include/linux/mm_inline.h          |    8 +--
 include/linux/userfaultfd_k.h      |   69 ++++++++++++++++-----------
 mm/memory.c                        |    6 +-
 5 files changed, 78 insertions(+), 44 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-add-pgtable_supports_uffd_wp
+++ a/fs/userfaultfd.c
@@ -1289,9 +1289,9 @@ static int userfaultfd_register(struct u
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
 		vm_flags |= VM_UFFD_MISSING;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP) {
-#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-		goto out;
-#endif
+		if (!pgtable_supports_uffd_wp())
+			goto out;
+
 		vm_flags |= VM_UFFD_WP;
 	}
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR) {
@@ -1999,14 +1999,14 @@ static int userfaultfd_api(struct userfa
 	uffdio_api.features &=
 		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
 #endif
-#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-	uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
-#endif
-#ifndef CONFIG_PTE_MARKER_UFFD_WP
-	uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
-	uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
-	uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
-#endif
+	if (!pgtable_supports_uffd_wp())
+		uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+
+	if (!uffd_supports_wp_marker()) {
+		uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
+		uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
+		uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
+	}
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
--- a/include/asm-generic/pgtable_uffd.h~mm-userfaultfd-add-pgtable_supports_uffd_wp
+++ a/include/asm-generic/pgtable_uffd.h
@@ -1,6 +1,23 @@
 #ifndef _ASM_GENERIC_PGTABLE_UFFD_H
 #define _ASM_GENERIC_PGTABLE_UFFD_H
 
+/*
+ * Some platforms can customize the uffd-wp bit, making it unavailable
+ * even if the architecture provides the resource.
+ * Adding this API allows architectures to add their own checks for the
+ * devices on which the kernel is running.
+ * Note: When overriding it, please make sure the
+ * CONFIG_HAVE_ARCH_USERFAULTFD_WP is part of this macro.
+ */
+#ifndef pgtable_supports_uffd_wp
+#define pgtable_supports_uffd_wp()	IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP)
+#endif
+
+static inline bool uffd_supports_wp_marker(void)
+{
+	return pgtable_supports_uffd_wp() && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP);
+}
+
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static __always_inline int pte_uffd_wp(pte_t pte)
 {
--- a/include/linux/mm_inline.h~mm-userfaultfd-add-pgtable_supports_uffd_wp
+++ a/include/linux/mm_inline.h
@@ -553,7 +553,6 @@ static inline pte_marker copy_pte_marker
 
 	return dstm;
 }
-#endif
 
 /*
  * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
@@ -571,9 +570,11 @@ static inline bool
 pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			      pte_t *pte, pte_t pteval)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	bool arm_uffd_pte = false;
 
+	if (!uffd_supports_wp_marker())
+		return false;
+
 	/* The current status of the pte should be "cleared" before calling */
 	WARN_ON_ONCE(!pte_none(ptep_get(pte)));
 
@@ -602,7 +603,7 @@ pte_install_uffd_wp_if_needed(struct vm_
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
 		return true;
 	}
-#endif
+
 	return false;
 }
 
@@ -616,6 +617,7 @@ static inline bool vma_has_recency(const
 
 	return true;
 }
+#endif
 
 /**
  * num_pages_contiguous() - determine the number of contiguous pages
--- a/include/linux/userfaultfd_k.h~mm-userfaultfd-add-pgtable_supports_uffd_wp
+++ a/include/linux/userfaultfd_k.h
@@ -228,15 +228,14 @@ static inline bool vma_can_userfault(str
 	if (wp_async && (vm_flags == VM_UFFD_WP))
 		return true;
 
-#ifndef CONFIG_PTE_MARKER_UFFD_WP
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
 	 * uffd-wp, then shmem & hugetlbfs are not supported but only
 	 * anonymous.
 	 */
-	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
+	    !vma_is_anonymous(vma))
 		return false;
-#endif
 
 	/* By default, allow any of anon|shmem|hugetlb */
 	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
@@ -291,6 +290,43 @@ void userfaultfd_release_new(struct user
 void userfaultfd_release_all(struct mm_struct *mm,
 			     struct userfaultfd_ctx *ctx);
 
+static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
+{
+	/* Only wr-protect mode uses pte markers */
+	if (!userfaultfd_wp(vma))
+		return false;
+
+	/* File-based uffd-wp always need markers */
+	if (!vma_is_anonymous(vma))
+		return true;
+
+	/*
+	 * Anonymous uffd-wp only needs the markers if WP_UNPOPULATED
+	 * enabled (to apply markers on zero pages).
+	 */
+	return userfaultfd_wp_unpopulated(vma);
+}
+
+/*
+ * Returns true if this is a swap pte and was uffd-wp wr-protected in either
+ * forms (pte marker or a normal swap pte), false otherwise.
+ */
+static inline bool pte_swp_uffd_wp_any(pte_t pte)
+{
+	if (!uffd_supports_wp_marker())
+		return false;
+
+	if (pte_present(pte))
+		return false;
+
+	if (pte_swp_uffd_wp(pte))
+		return true;
+
+	if (pte_is_uffd_wp_marker(pte))
+		return true;
+
+	return false;
+}
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
@@ -415,23 +451,9 @@ static inline bool vma_has_uffd_without_
 	return false;
 }
 
-#endif /* CONFIG_USERFAULTFD */
-
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
-	/* Only wr-protect mode uses pte markers */
-	if (!userfaultfd_wp(vma))
-		return false;
-
-	/* File-based uffd-wp always need markers */
-	if (!vma_is_anonymous(vma))
-		return true;
-
-	/*
-	 * Anonymous uffd-wp only needs the markers if WP_UNPOPULATED
-	 * enabled (to apply markers on zero pages).
-	 */
-	return userfaultfd_wp_unpopulated(vma);
+	return false;
 }
 
 /*
@@ -440,16 +462,7 @@ static inline bool userfaultfd_wp_use_ma
  */
 static inline bool pte_swp_uffd_wp_any(pte_t pte)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
-	if (pte_present(pte))
-		return false;
-	if (pte_swp_uffd_wp(pte))
-		return true;
-
-	if (pte_is_uffd_wp_marker(pte))
-		return true;
-#endif
 	return false;
 }
-
+#endif /* CONFIG_USERFAULTFD */
 #endif /* _LINUX_USERFAULTFD_K_H */
--- a/mm/memory.c~mm-userfaultfd-add-pgtable_supports_uffd_wp
+++ a/mm/memory.c
@@ -1590,7 +1590,9 @@ zap_install_uffd_wp_if_needed(struct vm_
 {
 	bool was_installed = false;
 
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!uffd_supports_wp_marker())
+		return false;
+
 	/* Zap on anonymous always means dropping everything */
 	if (vma_is_anonymous(vma))
 		return false;
@@ -1607,7 +1609,7 @@ zap_install_uffd_wp_if_needed(struct vm_
 		pte++;
 		addr += PAGE_SIZE;
 	}
-#endif
+
 	return was_installed;
 }
 
_

Patches currently in -mm which might be from zhangchunyan@iscas.ac.cn are

mm-softdirty-add-pgtable_supports_soft_dirty.patch
mm-userfaultfd-add-pgtable_supports_uffd_wp.patch
riscv-add-risc-v-svrsw60t59b-extension-support.patch
riscv-mm-add-soft-dirty-page-tracking-support.patch
riscv-mm-add-userfaultfd-write-protect-support.patch
dt-bindings-riscv-add-svrsw60t59b-extension-description.patch

