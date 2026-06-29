Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E9C43E486
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782751654; cv=none; b=S9mRmsjSgBwSGZ5jRVbxSEQbLfv549uICAAW/UqGMR8HBHLowWWV9ohJTgvsMauu/SJETnwv5FC0WkhawKTO6nlUEAmqLJQdKoYLBrbXLJx32whQGmrQ3L2D8dBQ9FkKNuVwxK83mx2EIlYkoUoqgptTz+5KtCBYtDINZdCWMCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782751654; c=relaxed/simple;
	bh=kTOZyBTUOaXvXv1Zp2DZQaaz+hnWtdmvdTzAXjiEhjA=;
	h=Date:To:From:Subject:Message-Id; b=OYCGNWlVrDTEIRdaLPeTqfw9S7Ncf3VB9MVgGl7VHewaXYb+88Sp+xaoKSir0n8PE/tj7G2xyZizwjwxjrxoVzB2zkbnFJL/xXPAhPKAlTXEPG3te+1fF5X8w4nZPEBR0kuhWtBP7xGvetpwYFB+hLOXhFPRTwgDXd+3VxFmaLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kwJIeKBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kwJIeKBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1071F000E9;
	Mon, 29 Jun 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782751652;
	bh=QRsnf7ztz2tHcaAD9zCluW2tj3mNONgdd0Dd7sBGzn0=;
	h=Date:To:From:Subject;
	b=kwJIeKBEmAywvOitBLFyvTD5VPE6ug0Otw2dcV/zUTc7EJkgxDfVmmf/31DNe2A68
	 FLwWkwlDFsY6Oo3tOodhJIefYTT5qvPhynQbCH5OizIR/SjK4i3n8MjGAgiF6C7qwd
	 zv6evCoGyVucJCwJWep3qVCJ3P16Q6Z/e4qvBXDg=
Date: Mon, 29 Jun 2026 09:47:32 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,lkp@intel.com,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch added to mm-new branch
Message-Id: <20260629164732.CD1071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

