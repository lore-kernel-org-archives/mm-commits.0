Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AB435505C
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763155403; cv=none; b=ekNAo/F9112w1XC48rc+DY0XXQ652k4T964XXTGKCklqMEp7xogNQBElQe1gUzztJG4smAgS/FyqQJYDO/uxwIP82ZWkYproCzes/rTMZIh0ZDoksDNbk6bnQofyE0HJR75tsDuLTKrBZPEytgQgGocP5uO5wq+lbZw9VC7zJtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763155403; c=relaxed/simple;
	bh=Kvq9PSQZjXh0eiinNWMXhgFU6qWq3bWJn/HIDvX8u7c=;
	h=Date:To:From:Subject:Message-Id; b=FkBSHCnAIyuPUzAb8TS/D3a7lnVB1shuQH4uiuOuK8f7M/13YfU5PEc6JLDKa/E73L6CQ9L5ljyr/JV55AQbluKlJvi1S8bgOVmS3Ev1K80TnDIaUXaBQl7QgsNmqrqjKFYaMhIhSDsg8EDo7FnZoQtMLKOFThQIfCydWIyrSfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WVc1CKg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WVc1CKg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564BBC4CEF1;
	Fri, 14 Nov 2025 21:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763155401;
	bh=Kvq9PSQZjXh0eiinNWMXhgFU6qWq3bWJn/HIDvX8u7c=;
	h=Date:To:From:Subject:From;
	b=WVc1CKg6E2K0t1X64ZMlpXI0Y/MCmi7IKYvvsSmnI2j5VJAfN/63UB/qGRIZMh/m+
	 3mzxmM8SbvweOWRBvFiL2BJuxNxXvNwqyJBGX7HZ5bmSnvXcqcBHGLs9gG8qYxZq62
	 YCu896wiIU8vhVjMh6Eqoj5LtuSJF9xwM9aPw4KE=
Date: Fri, 14 Nov 2025 13:23:20 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sourabhjain@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,donettom@linux.ibm.com,christophe.leroy@csgroup.eu,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch removed from -mm tree
Message-Id: <20251114212321.564BBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
has been removed from the -mm tree.  Its filename was
     mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
Date: Wed, 12 Nov 2025 15:56:32 +0100

In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
runtime allocation of gigantic hugetlb folios.  In the meantime it evolved
into a generic way for the architecture to state that it supports gigantic
hugetlb folios.

In commit fae7d834c43c ("mm: add __dump_folio()") we started using
CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
have folios larger than what the buddy can handle.  In the context of that
commit, we started using MAX_FOLIO_ORDER to detect page corruptions when
dumping tail pages of folios.  Before that commit, we assumed that we
cannot have folios larger than the highest buddy order, which was
obviously wrong.

In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
when registering hstate"), we used MAX_FOLIO_ORDER to detect
inconsistencies, and in fact, we found some now.

Powerpc allows for configs that can allocate gigantic folio during boot
(not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
exceed PUD_ORDER.

To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
GiB (possible on arm64 and powerpc).  Note that on some powerpc
configurations, whether we actually have gigantic pages depends on the
setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is nothing really
problematic about setting it unconditionally: we just try to keep the
value small so we can better detect problems in __dump_folio() and
inconsistencies around the expected largest folio in the system.

Ideally, we'd have a better way to obtain the maximum hugetlb folio size
and detect ourselves whether we really end up with gigantic folios.  Let's
defer bigger changes and fix the warnings first.

While at it, handle gigantic DAX folios more clearly: DAX can only end up
creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.

Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases clearer. 
In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with HUGETLB_PAGE.

Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
also allow for runtime allocations of folios in some more powerpc configs.
I don't think this is a problem, but if it is we could handle it through
__HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.

While __dump_page()/__dump_folio was also problematic (not handling
dumping of tail pages of such gigantic folios correctly), it doesn't
seem critical enough to mark it as a fix.

Link: https://lkml.kernel.org/r/20251112145632.508687-1-david@kernel.org
Fixes: 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when registering hstate")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Closes: https://lore.kernel.org/r/3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu/
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Closes: https://lore.kernel.org/r/94377f5c-d4f0-4c0f-b0f6-5bf1cd7305b1@linux.ibm.com/
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 +
 include/linux/mm.h   |   12 +++++++++---
 mm/Kconfig           |    7 +++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

--- a/arch/powerpc/Kconfig~mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/arch/powerpc/Kconfig
@@ -137,6 +137,7 @@ config PPC
 	select ARCH_HAS_DMA_OPS			if PPC64
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
--- a/include/linux/mm.h~mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/include/linux/mm.h
@@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pag
 	return folio_large_nr_pages(folio);
 }
 
-#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
+#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
 /*
  * We don't expect any folios that exceed buddy sizes (and consequently
  * memory sections).
@@ -2087,10 +2087,16 @@ static inline unsigned long folio_nr_pag
  * pages are guaranteed to be contiguous.
  */
 #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#else
+#elif defined(CONFIG_HUGETLB_PAGE)
 /*
  * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (e.g., hugetlb, dax).
+ * currently expect: with hugetlb, we expect no folios larger than 16 GiB.
+ */
+#define MAX_FOLIO_ORDER		get_order(SZ_16G)
+#else
+/*
+ * Without hugetlb, gigantic folios that are bigger than a single PUD are
+ * currently impossible.
  */
 #define MAX_FOLIO_ORDER		PUD_ORDER
 #endif
--- a/mm/Kconfig~mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/mm/Kconfig
@@ -908,6 +908,13 @@ config PAGE_MAPCOUNT
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
+#
+# We can end up creating gigantic folio.
+#
+config HAVE_GIGANTIC_FOLIOS
+	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
+		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+
 # TODO: Allow to be enabled without THP
 config ARCH_SUPPORTS_HUGE_PFNMAP
 	def_bool n
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-update-david-hildenbrands-email-address.patch

