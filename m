Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4752463B9
	for <mm-commits@vger.kernel.org>; Sat, 15 Nov 2025 00:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763165848; cv=none; b=jFh6DcixB5ErOqxD0pDdAkbyg6rT3fUGvwyXbCULDqJnXDFIGXoY12SKgp++uyIGCZFX0cp4KvmM8Gw8MGC/674irPeAZOf1/SZ4DdimrAfZp/7CSTu1o7l0d8qgd16TLCSqYwMpYXNrIvrkLuO+tOsk6P63gK07XuYV/N6KGdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763165848; c=relaxed/simple;
	bh=kDroa+agckdAcDj/fXKAPftroc6JcDvaqAYdpTAWT58=;
	h=Date:To:From:Subject:Message-Id; b=rDztDQPr/zAHtol+NDSQwFMxpVJG7HExXlXo87ynWugCkHBwmaKS1p/WV9xkUPnsPaTNQjNATdwGHtcc2CEpF2HUycaPe54fIJoiNZDBc0DEfNcmIVKWhXo9laPPbNG6klDw10in8WkRRpyT5Vn8F+I01lIpz41VHCoYWu69kFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hjY9yKGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hjY9yKGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD27C4CEF8;
	Sat, 15 Nov 2025 00:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763165847;
	bh=kDroa+agckdAcDj/fXKAPftroc6JcDvaqAYdpTAWT58=;
	h=Date:To:From:Subject:From;
	b=hjY9yKGrCXMjLjtwSTD5TSUeckTqF8KZDNHcOpIyYCGoFoyKzr/u/rI9ONGkNbwab
	 p9+xnLrmhrcgH8FYE7XrHc3TVcdKGB/GYWlEVguIKuSgstL652MnqNVDAH+P7jFnID
	 ZyFYVlsqhxLrL3x4ta600eLFH1ru0hDszixU7A8o=
Date: Fri, 14 Nov 2025 16:17:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sourabhjain@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,npiggin@gmail.com,nathan@kernel.org,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,donettom@linux.ibm.com,christophe.leroy@csgroup.eu,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch added to mm-hotfixes-unstable branch
Message-Id: <20251115001727.ADD27C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
Date: Fri, 14 Nov 2025 22:49:20 +0100

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
GiB on 64bit (possible on arm64 and powerpc) and 1 GiB on 32 bit
(powerpc).  Note that on some powerpc configurations, whether we actually
have gigantic pages depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER,
but there is nothing really problematic about setting it unconditionally:
we just try to keep the value small so we can better detect problems in
__dump_folio() and inconsistencies around the expected largest folio in
the system.

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
dumping of tail pages of such gigantic folios correctly), it doesn't seem
critical enough to mark it as a fix.

Link: https://lkml.kernel.org/r/20251114214920.2550676-1-david@kernel.org
Fixes: 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when registering hstate")
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Closes: https://lore.kernel.org/r/3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu/
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Closes: https://lore.kernel.org/r/94377f5c-d4f0-4c0f-b0f6-5bf1cd7305b1@linux.ibm.com/
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                   |    1 +
 arch/powerpc/platforms/Kconfig.cputype |    1 -
 include/linux/mm.h                     |   13 ++++++++++---
 mm/Kconfig                             |    7 +++++++
 4 files changed, 18 insertions(+), 4 deletions(-)

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
--- a/arch/powerpc/platforms/Kconfig.cputype~mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -423,7 +423,6 @@ config PPC_64S_HASH_MMU
 config PPC_RADIX_MMU
 	bool "Radix MMU Support"
 	depends on PPC_BOOK3S_64
-	select ARCH_HAS_GIGANTIC_PAGE
 	default y
 	help
 	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
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
@@ -2087,10 +2087,17 @@ static inline unsigned long folio_nr_pag
  * pages are guaranteed to be contiguous.
  */
 #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#else
+#elif defined(CONFIG_HUGETLB_PAGE)
 /*
  * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (e.g., hugetlb, dax).
+ * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
+ * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
+ */
+#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
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
mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch

