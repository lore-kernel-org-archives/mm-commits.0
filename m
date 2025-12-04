Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF7B27CB35;
	Thu,  4 Dec 2025 21:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764885579; cv=none; b=pruFtvBbHSrsqqkmx+is1RpAiJsbedsk5+Hh91ayljtBONxpISsIUR3gW3YbVvP7eAz48B0F+hLm92+8Fc6t14OsDg0g+0zn2dE60SHP7iQTrD41Rp1rdffzg//MUb0S3DOd3+YJbS6j2kgWmBEtOXny+43D3XR2SKFh+e5ZgT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764885579; c=relaxed/simple;
	bh=zoYG0yRVSPL0YEgb8/GpcZlSckKNZ+ksq2fCX+Ste9I=;
	h=Date:To:From:Subject:Message-Id; b=sAuJyaOFu8FKg/9VBcytYnHv/KBLYHazkj03KaWSeZxllv2NgR5gyyJwwoPkc1yDgUzZjQyCwS3/i39J8ZW+GKrllmlNHms4ulrxosxlyBXXq7uvVNykvyOD2Xdf+jWAOLDx6qtUjtYs0DcYM1nuO/IhEJRIZ4hmiJpPPKMPkeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VJJrflVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VJJrflVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750D3C4CEFB;
	Thu,  4 Dec 2025 21:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764885578;
	bh=zoYG0yRVSPL0YEgb8/GpcZlSckKNZ+ksq2fCX+Ste9I=;
	h=Date:To:From:Subject:From;
	b=VJJrflVWIVUAgDwzv9JilEpXrk2Ze8Tjt5NCHFDpjGzOiZ4fLTRLMj1FkXf1/ry7H
	 FuM0MX8Dc2qe7Bxth00I5ZJPmZc8ZiVNLhgd15e88z1ihu93vzFpYSfBgzsM9UTQIf
	 m0deI5jTNH1IypeWm+u3K3lf815q55EnQ89Y3WAM=
Date: Thu, 04 Dec 2025 13:59:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linuxfoundation.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,masahiroy@kernel.org,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,christophe.leroy@csgroup.eu,skhan@linuxfoundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch added to mm-hotfixes-unstable branch
Message-Id: <20251204215938.750D3C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch

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
From: Shuah Khan <skhan@linuxfoundation.org>
Subject: Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb"
Date: Wed, 3 Dec 2025 19:33:56 -0700

This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.

Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
systems.  git fetch-pack fails when cloning large repos and make hangs or
errors out of Makefile.build with Error: 139.  These failures are random
with git clone failing after fetching 1% of the objects, and make hangs
while compiling random files.

Below is is one of the git clone failures:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux_6.19
Cloning into 'linux_6.19'...
remote: Enumerating objects: 11173575, done.
remote: Counting objects: 100% (785/785), done.
remote: Compressing objects: 100% (373/373), done.
remote: Total 11173575 (delta 534), reused 505 (delta 411), pack-reused 11172790 (from 1)
Receiving objects: 100% (11173575/11173575), 3.00 GiB | 7.08 MiB/s, done.
Resolving deltas: 100% (9195212/9195212), done.
fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
fatal: fetch-pack: invalid index-pack output

(akpm: reverting this probably just hides a bug, but let's do that for now
while the bug is being worked on).

Link: https://lkml.kernel.org/r/20251204023358.54107-1-skhan@linuxfoundation.org
Fixes: 39231e8d6ba7 ("mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb")
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                   |    1 -
 arch/powerpc/platforms/Kconfig.cputype |    1 +
 include/linux/mm.h                     |   13 +++----------
 mm/Kconfig                             |    7 -------
 4 files changed, 4 insertions(+), 18 deletions(-)

--- a/arch/powerpc/Kconfig~revert-mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/arch/powerpc/Kconfig
@@ -137,7 +137,6 @@ config PPC
 	select ARCH_HAS_DMA_OPS			if PPC64
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
--- a/arch/powerpc/platforms/Kconfig.cputype~revert-mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -423,6 +423,7 @@ config PPC_64S_HASH_MMU
 config PPC_RADIX_MMU
 	bool "Radix MMU Support"
 	depends on PPC_BOOK3S_64
+	select ARCH_HAS_GIGANTIC_PAGE
 	default y
 	help
 	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
--- a/include/linux/mm.h~revert-mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/include/linux/mm.h
@@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pag
 	return folio_large_nr_pages(folio);
 }
 
-#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
+#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
 /*
  * We don't expect any folios that exceed buddy sizes (and consequently
  * memory sections).
@@ -2087,17 +2087,10 @@ static inline unsigned long folio_nr_pag
  * pages are guaranteed to be contiguous.
  */
 #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#elif defined(CONFIG_HUGETLB_PAGE)
-/*
- * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
- * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
- */
-#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
 #else
 /*
- * Without hugetlb, gigantic folios that are bigger than a single PUD are
- * currently impossible.
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect (e.g., hugetlb, dax).
  */
 #define MAX_FOLIO_ORDER		PUD_ORDER
 #endif
--- a/mm/Kconfig~revert-mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/mm/Kconfig
@@ -908,13 +908,6 @@ config PAGE_MAPCOUNT
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
-#
-# We can end up creating gigantic folio.
-#
-config HAVE_GIGANTIC_FOLIOS
-	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
-		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-
 # TODO: Allow to be enabled without THP
 config ARCH_SUPPORTS_HUGE_PFNMAP
 	def_bool n
_

Patches currently in -mm which might be from skhan@linuxfoundation.org are

revert-mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb.patch

