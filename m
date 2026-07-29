Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08875209F43
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297263; cv=none; b=a0sGk92WuQZZQgzpreJgnoJguWYqgalc1Ux6cFuhKP/X9iVxXAKu7nhrfSf9d0Ocxk0VRQwhLSbFUl9ZKV/tPBHI/NSWJKPuRnKF+/Bahq1vu3hHLZUei79fCbNaStB1DVR3lMQ6S+uEVwBibBqbLcsOzZHUfvMftzxqhxmvapc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297263; c=relaxed/simple;
	bh=e1FPx+Qxcbwb1CFSOtLyE/yqUOwsfmwbCbh5efC16Qg=;
	h=Date:To:From:Subject:Message-Id; b=ZShYqjuBJTPs2ofGtckhHIZPbbC8r3BJdNrv7aquQWAMrK3DCR8O+7ElQevv675zyjl6MXawVPUihkm1OyEyhLZtbbt0UoLcj9C3C7ZNrncEtYnk3ogeCTZfVAGK8Ew306faMBEXyl2siGGNFBMiKvj5F64juvy3qAhGdwlrGeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G+ADqys5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G+ADqys5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFDE1F000E9;
	Wed, 29 Jul 2026 03:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297261;
	bh=jLZdyhLqiHsXLBI9I/lPYEU+VijVq54vQCUkDEPrCIA=;
	h=Date:To:From:Subject;
	b=G+ADqys5MoYBUnFF7bW/QsGNuXKgrH4VnRBpqMCtH3q9lz2/BbayyT7Qc4YrI0H2x
	 K4/R6wFPawFZB+DuuRomyInnpCqhaXGI7FZaWfSwdCZ20d9VhJbOzmMYlj1PT0kmgd
	 CdEmp0Tb9FIehY5Om6CPtAAnGZrGFQOaT1/AdcBY=
Date: Tue, 28 Jul 2026 20:54:21 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,lkp@intel.com,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch removed from -mm tree
Message-Id: <20260729035421.BFFDE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix
Date: Mon Jun 29 07:48:04 PM PDT 2026

build fix

mm/zsmalloc.c: In function 'obj_class_get_and_lock':
mm/zsmalloc.c:1481:36: error: implicit declaration of function 'obj_to_class_idx' [-Wimplicit-function-declaration]
 1481 |         *classp = pool->size_class[obj_to_class_idx(obj)];
      |                                    ^~~~~~~~~~~~~~~~

Cc: Barry Song <baohua@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao@xiaomi.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix
+++ a/mm/zsmalloc.c
@@ -1457,6 +1457,12 @@ static void obj_free(int class_size, uns
 	mod_zspage_inuse(zspage, -1);
 }
 
+/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
+static unsigned int obj_to_class_idx(unsigned long obj)
+{
+	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
+}
+
 /*
  * Resolve @handle to its zspage / size_class and acquire class->lock.
  *
@@ -1759,12 +1765,6 @@ static void lock_zspage(struct zspage *z
 	zspage_read_unlock(zspage);
 }
 
-/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
-static unsigned int obj_to_class_idx(unsigned long obj)
-{
-	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
-}
-
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct zpdesc *newzpdesc, struct zpdesc *oldzpdesc)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

csky-implement-flush_cache_vmap-in-c.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

