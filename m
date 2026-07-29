Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88823209F43
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297264; cv=none; b=daf1lAgKYzUEJixxq9C7cI+253RbFAO8W9VqrplC46jFghN0q66COyDC1hrtmUv/8T9rKucmKB2vDaZvIwlrzLS2ui0Y+27i65alyK9putCEsuQJAcq12pkcHxpBqfT6nySBP+jCUfFoeI7DivkJGv6c+cxVkO+kXjhPobjFrGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297264; c=relaxed/simple;
	bh=m8zx0vGFtW5aVuj/pHDTq78nfM+TG7hGXdo7A7UwGBA=;
	h=Date:To:From:Subject:Message-Id; b=Rvg2cTnGgx+JbHWTmERPR8SIDn/4qhNezZjfVGqDzw8BsNgXLvv+//qQ/L8bHbMNFG+RV8SAv4/rC8ohiBGlDULKybqW+sWn99mvsoexZhp+QEASOUZQqp5XimNVTHNm4w1rE1y58iYo9XV4WM3LFZjqb7TEryVKjq4i/UVKiWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FumFYDrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FumFYDrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122C31F00A3A;
	Wed, 29 Jul 2026 03:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297263;
	bh=dvDze5HicjM69QNTT8xtZ1LTNq603M84ntXAFEhnRnQ=;
	h=Date:To:From:Subject;
	b=FumFYDrDojpKlPY/xS2Xjq8OWbAgZNL3mMbGG1VrqJUrQVaRfOqzrMNsuz+DlfkI9
	 g4K0cXgrKkbcclfjRQfQwkYBho+zJihZ9I1rc8zY4tCJGWqoY0tsaDpS4k/gLTrV9h
	 xGkCEgnMNN7RagKfdS7Svjroe/22d8aBbivldLns=
Date: Tue, 28 Jul 2026 20:54:22 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,lkp@intel.com,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch removed from -mm tree
Message-Id: <20260729035423.122C31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix
Date: Wed Jul  1 03:52:15 PM PDT 2026

fix obj_to_class_idx() warning yet again

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/202607020359.FMDmPwjF-lkp@intel.com
Cc: Barry Song <baohua@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao@xiaomi.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix
+++ a/mm/zsmalloc.c
@@ -1457,11 +1457,13 @@ static void obj_free(int class_size, uns
 	mod_zspage_inuse(zspage, -1);
 }
 
+#if (ZS_OBJ_CLASS_BITS > 0) || defined(CONFIG_COMPACTION)
 /* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
 static unsigned int obj_to_class_idx(unsigned long obj)
 {
 	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
 }
+#endif
 
 /*
  * Resolve @handle to its zspage / size_class and acquire class->lock.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

csky-implement-flush_cache_vmap-in-c.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

