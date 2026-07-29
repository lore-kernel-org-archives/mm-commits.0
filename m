Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E6E3314AC
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297208; cv=none; b=gRgWUMe0Huf6RkiqX/3VGviJVzig38dfIqqmaZC8NUe5A838o4vz1YW/YkSzawSwPobXwkOQ+THDUw+CPc2EG0kZH/JNWUo8EsVWmhZbWrkN+gWcMIVW1bUC2h1rJi2bBnB4sEmcCQysFv3wYcZ2Lc2LoernB26wIY4C5bMo2+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297208; c=relaxed/simple;
	bh=Y5FluUXs7wajswoVfBfVC+3plD6IfHLVrVvqfibEv/A=;
	h=Date:To:From:Subject:Message-Id; b=PMFkgpC8v5gZ/2bXhprA5OYnb8Y0WtyCAitKq/+KS6/HuBFm302LXol7q9hmhhUhfegADaqS3vUlWxHfuDz0M7aHXvW3rynw/uOpWq8AURQGz1AYBYOn0V0GttDi6k5V7Xm8waQUadTbryG8gmdSSb6rjmMlrcKQy+wSVi/ijHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjP693sM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjP693sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B261F00A3A;
	Wed, 29 Jul 2026 03:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297207;
	bh=vZ092WgC1+XIMVNmbnmaPIKztq6K9SkLMOjX08ZYfeU=;
	h=Date:To:From:Subject;
	b=GjP693sMKMh9uajbmzGYKxlhVzvjii2QQt6c5P8aUG/xjEgeQWm4GzjcDzSsjI5uD
	 CXwdXqHDjKq0CI1KkJUgQg61d4YsNUEmg34u3yJ2HbgjIAKA21MNLfn91Z7RpjfmNg
	 E/b3f2G3C28nT0uiSAEzBQuig/kerTceZqAsMH0U=
Date: Tue, 28 Jul 2026 20:53:26 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,lkp@intel.com,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch removed from -mm tree
Message-Id: <20260729035327.09B261F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix
Date: Mon Jun 29 09:44:25 AM PDT 2026

- fix obj_to_class_idx() defined but not used
- remove duplicated #ifdef CONFIG_COMPACTION

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com/
Cc: Barry Song <baohua@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao@xiaomi.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix
+++ a/mm/zsmalloc.c
@@ -796,12 +796,6 @@ static void obj_to_zpdesc(unsigned long
 	*zpdesc = pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
 }
 
-/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
-static unsigned int obj_to_class_idx(unsigned long obj)
-{
-	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
-}
-
 /**
  * location_to_obj - encode (<zpdesc>, <obj_idx>, <class_idx>) into obj value
  * @zpdesc: zpdesc object resides in zspage
@@ -1719,9 +1713,12 @@ static void lock_zspage(struct zspage *z
 	}
 	zspage_read_unlock(zspage);
 }
-#endif /* CONFIG_COMPACTION */
 
-#ifdef CONFIG_COMPACTION
+/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
+static unsigned int obj_to_class_idx(unsigned long obj)
+{
+	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
+}
 
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct zpdesc *newzpdesc, struct zpdesc *oldzpdesc)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

csky-implement-flush_cache_vmap-in-c.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

