Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0CD257827
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334326; cv=none; b=Z+oTW1/CdtBgkFBnbAWKkCr1dYeiIL6rMWGQ5BWFFilEjBQ3s0Y4aiXKaC0n/o3iWChNOL4j/kBgtvJWgRdTzpYEHFCZkb8qmJTtBhmtfFUdsfGEviHir4nmYLJbvTtWaIyKaEzWX7XtFKEM4/Giofjod94et4WETTIVfC4O7Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334326; c=relaxed/simple;
	bh=YnIW8cude+FpAMQ7cHgJzLPEZSeSTI/mI/p1Fjo0W9g=;
	h=Date:To:From:Subject:Message-Id; b=iWSETk+4hGg/Et1KXoCu+UB6/ssqX2HqBRvYSI+j0nKw6cLtQSn1EKeJIRIsgbW0atrxJ4dKDw1prTjJkDWPkyr8Fw+BEZ+Sem7KliNgcX6etmFRJCdfn4JNy0byDcWivySGvOhanCRPIAB+4ztJjT73mWuvonNRGJmYYkNNf5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VnLna/Yb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VnLna/Yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B671F0089B;
	Wed,  7 Oct 2026 00:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334325;
	bh=oxfACo7+CLU2kc/2ZiZbQdhfW060/vvB3mQ6yUy7qMY=;
	h=Date:To:From:Subject;
	b=VnLna/YbKF0b4o2vjZf2CUhQshN7CkGfYUo1HOeQC+VmTthPzAuSoxXtCSTYRv77w
	 5QusaB3yazKG9LG0hI27JMeB9AjklAM2aMk0mrd5yDRmBXalyZSWSXR4+lNiNRg2XC
	 OPe3yyXyEgEilH+dsj6qAAF1vjXSgd4SjUMKcQ9M=
Date: Tue, 06 Oct 2026 17:52:04 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch removed from -mm tree
Message-Id: <20261007005205.24B671F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_table_check: add explicit pmd_none check in pte_clear_range
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/page_table_check: add explicit pmd_none check in pte_clear_range
Date: Wed, 19 Aug 2026 10:55:15 +0800

In __page_table_check_pte_clear_range(), the condition to determine
whether to iterate over PTEs only checked pmd_bad() and pmd_leaf().  This
relies on the implicit assumption that pmd_none() is always a subset of
pmd_bad() on all architectures supporting PAGE_TABLE_CHECK.

While this assumption currently holds for x86_64, arm64, s390, riscv, and
powerpc, it is an architecture-dependent behavior that may not hold for
future architectures.  Add an explicit pmd_none() check to make the intent
clear and avoid calling pte_offset_map() on an empty PMD, which could lead
to undefined behavior.

Link: https://lore.kernel.org/20260819025516.2967199-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
---

 mm/page_table_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_table_check.c~mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range
+++ a/mm/page_table_check.c
@@ -278,7 +278,7 @@ void __page_table_check_pte_clear_range(
 	if (&init_mm == mm)
 		return;
 
-	if (!pmd_bad(pmd) && !pmd_leaf(pmd)) {
+	if (!pmd_none(pmd) && !pmd_bad(pmd) && !pmd_leaf(pmd)) {
 		pte_t *ptep = pte_offset_map(&pmd, addr);
 		unsigned long i;
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch
mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

