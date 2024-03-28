Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F1012F38B
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 18:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711651549; cv=none; b=KVCB64NxE6PfXV9YyInTb5qhZb7tXJPtH8PBnKHuOWZmRL+YQ8Fomp/BZuRZNKHUezYYLeWU4aTS3e+aCcuIBJODsiWS70OjaZ70QFQo+WmwwCINbkUcgVCduKNCPPa8teTqc731JqI2d0JldCRkbDpwZ/bPGumuD4/XUd0vggw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711651549; c=relaxed/simple;
	bh=CCmOEgvVnBHH1lNAUDJkZLtoArmAJuVbczplGJGh2sM=;
	h=Date:To:From:Subject:Message-Id; b=jDAYZgKL9+eP9IIFTVwwOj0l3PIWKKSMUiOBNFLM2MZl9V2boqlHCf9AGnUHbVHVO372W1/zpKCfmUueBeagv0A74j2vu3www1NGdR8jJR93e3RpBsjZLrDHycVdPflR+bbh8Igf4I7ZbNbSnFQQ/fV+so8SBCI7malm4Irw+CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iHETIGLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iHETIGLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5068C433F1;
	Thu, 28 Mar 2024 18:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711651548;
	bh=CCmOEgvVnBHH1lNAUDJkZLtoArmAJuVbczplGJGh2sM=;
	h=Date:To:From:Subject:From;
	b=iHETIGLWyJyrUhyyztqjDzlPKj7k1r9VDxf/TjyN5sSdU5tLiDGVb0p6GU7M833aR
	 ZGRkmUvTpO5CI4iX/3Wv5Nob6Rh7bSDb4YiuZjss0pdLOOgaFNG4bxObi34IrfM/lq
	 8022NScmKYp3p/r1OzvYaNmwI4PpekBWvylFV9CY=
Date: Thu, 28 Mar 2024 11:45:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,naresh.kamboju@linaro.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch added to mm-unstable branch
Message-Id: <20240328184548.A5068C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh-remove-use-of-pg_arch_1-on-individual-pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sh-remove-use-of-pg_arch_1-on-individual-pages-fix
Date: Thu Mar 28 11:44:56 AM PDT 2024

fix folio_flags call

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/cache-sh4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/mm/cache-sh4.c~sh-remove-use-of-pg_arch_1-on-individual-pages-fix
+++ a/arch/sh/mm/cache-sh4.c
@@ -247,7 +247,7 @@ static void sh4_flush_cache_page(void *a
 		 * another ASID than the current one.
 		 */
 		map_coherent = (current_cpu_data.dcache.n_aliases &&
-			test_bit(PG_dcache_clean, folio_flags(folio)) &&
+			test_bit(PG_dcache_clean, folio_flags(folio, 0)) &&
 			page_mapped(page));
 		if (map_coherent)
 			vaddr = kmap_coherent(page, address);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
drm-amd-display-use-arch_has_kernel_fpu_support-fix.patch

