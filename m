Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FE72BD031
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801293; cv=none; b=sezYGMyAsEtQKFhEoJONvs5GJzqU4UBhqmcc05OFu0fGPWvTZ78AGuDNOtnxHGTlplUnr4i+cR/jlbP3dy75EYVgTz/Tq3V+/SL/2yRsA72AZlrLh3aR1EPRVThqJHZDeprBr9dq0rWaCf1vGgkjF9fHaOoGNStiBS/zDy6ETRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801293; c=relaxed/simple;
	bh=a+hbURAZWZDvmzAKK25wLRSXwMt4FF9ufLplA4KfGmM=;
	h=Date:To:From:Subject:Message-Id; b=BL0s6xlaVCMoXMod4xVHfYU/6kgyDys0FMmUUjjjJzlOHw6HjrSxYVrCy10+f8wpHiv+xxmi46o7jqFMK44m3a7qyeRl1+4/hVEuq7WISGuUMifk5sQOY8DrzmIi/HwRqp8v9ADbLeRncBNAnmfbTHMdIdww0nQLH5Q9hvPVJ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EJrO+ZSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EJrO+ZSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D564C4CEEB;
	Sat, 13 Sep 2025 22:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801293;
	bh=a+hbURAZWZDvmzAKK25wLRSXwMt4FF9ufLplA4KfGmM=;
	h=Date:To:From:Subject:From;
	b=EJrO+ZSQ2hR0d45ZSYzSNftkwZYTCvARAc+un8dPVtzDkDsyBjHKjYmSxuoEpLVc+
	 KHdD9BnA3fJ1DXnMJpR8rJBovgTA7TcIAbgI6R0BLlj1TsddEcG/qrWn/CamFhjrnz
	 88yTQC3lQ/Rr9Vh7+EfB4MSz97gksif+gDaTw/YY=
Date: Sat, 13 Sep 2025 15:08:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vgupta@kernel.org,lorenzo.stoakes@oracle.com,lkp@intel.com,liuye@kylinos.cn,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch removed from -mm tree
Message-Id: <20250913220813.5D564C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
has been removed from the -mm tree.  Its filename was
     mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch

This patch was dropped because it was folded into mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
Date: Fri Aug 22 02:54:15 PM PDT 2025

remove arc's private PAGES_TO_MB, remove its unused PAGES_TO_KB

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lkml.kernel.org/r/202508230539.pnO97SIj-lkp@intel.com
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/arcregs.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arc/include/asm/arcregs.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
+++ a/arch/arc/include/asm/arcregs.h
@@ -146,14 +146,13 @@
 
 #ifndef __ASSEMBLER__
 
+#include <linux/mm.h>
+
 #include <soc/arc/arc_aux.h>
 
 /* Helpers */
 #define TO_KB(bytes)		((bytes) >> 10)
 #define TO_MB(bytes)		(TO_KB(bytes) >> 10)
-#define PAGES_TO_KB(n_pages)	((n_pages) << (PAGE_SHIFT - 10))
-#define PAGES_TO_MB(n_pages)	(PAGES_TO_KB(n_pages) >> 10)
-
 
 /*
  ***************************************************************
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

