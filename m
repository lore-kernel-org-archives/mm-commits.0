Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D3517555
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758485189; cv=none; b=ac2qSBVvkVbmyAZUFkdbGm1mDdP5Wuig/E6GReCv2y7XGWWYYBnk89JNDQf9iEwlXmk/eOmFiE7oqB6OiVCf0czOgZGKQFjhgAjNSo+H2fayaGx1JA25+jzFo1eOC+NCVJU2RaSEdulUxTlmRlamKqTUpouRmPUisCiEfOqEvpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758485189; c=relaxed/simple;
	bh=R+bMiYE2f7UxTt5uYdwzXCPTxBIKenObW0xwmyUtrYE=;
	h=Date:To:From:Subject:Message-Id; b=e+x9Nnln8gDyyX7ehIkpIebM1xZ5oxihB5QL+cLVVTKBraqFUrKJ39CbOxYK+engIn0EloQYJUwWTg3nkWXoxmk4VfgPskQkdW1fOfpBjHxgBjjn7UNdHG9zKAdZMW9VG7FmuBzbUWbXx2uYtK3VroCk4FehB7w3aBB9XpHJdZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LMyOz2YB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LMyOz2YB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43ADC4CEE7;
	Sun, 21 Sep 2025 20:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758485188;
	bh=R+bMiYE2f7UxTt5uYdwzXCPTxBIKenObW0xwmyUtrYE=;
	h=Date:To:From:Subject:From;
	b=LMyOz2YBpmCLnNxwmrwvNwTww8S0SQHAbZl5Psvw0fDan51QLlSLeQ4tPxMLoWWPi
	 0kg2g5rhcYRfH+uGgrOnh7VCQLCLdtfeUOxdgO67/5HEqzMyV2OFbIE5xL5I8xIO7I
	 PAPJt2lbwLJDwUgmb3q/WWqJ+zLPfF0/eXT93uio=
Date: Sun, 21 Sep 2025 13:06:28 -0700
To: mm-commits@vger.kernel.org,youling.tang@linux.dev,tangyouling@kylinos.cn,max.kellermann@ionos.com,chizhiling@kylinos.cn,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-filemap-align-last_index-to-folio-size-fix-fix.patch removed from -mm tree
Message-Id: <20250921200628.C43ADC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-filemap-align-last_index-to-folio-size-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-filemap-align-last_index-to-folio-size-fix-fix.patch

This patch was dropped because it was folded into mm-filemap-align-last_index-to-folio-size.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-filemap-align-last_index-to-folio-size-fix-fix
Date: Wed Sep  3 03:50:51 PM PDT 2025

update it for Max's constification efforts

Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: Youling Tang <youling.tang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-filemap-align-last_index-to-folio-size-fix-fix
+++ a/include/linux/pagemap.h
@@ -483,7 +483,7 @@ mapping_min_folio_nrpages(const struct a
 }
 
 static inline unsigned long
-mapping_min_folio_nrbytes(struct address_space *mapping)
+mapping_min_folio_nrbytes(const struct address_space *mapping)
 {
 	return mapping_min_folio_nrpages(mapping) << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-filemap-align-last_index-to-folio-size.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

