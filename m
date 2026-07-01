Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3583CC300
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 22:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782946515; cv=none; b=nwg96I3REW3vPtUskkUzQJUoNmE+HirZm20+E2G9kVxdiAE/l2TcS/ixKqe6PnXOml6HPY4Lv6xK8wv/Jp4flAPLSC8p1tly5tgsjAexRx4+T07eN3feLbhO2ePMyl02+ZU/uu96WZ5of5mk684+JXhcsQfOO1QQxDoXrm5Uxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782946515; c=relaxed/simple;
	bh=tzKIbHevlniLj/+5YU05+jiBjF2Ozt7u6pjUDGDfKLI=;
	h=Date:To:From:Subject:Message-Id; b=QT4tc3WUVxfai6yQ8aAE38HkdtBJmRp6VZxpUc+dK6rIyBk2kMQJpVoUe6PDRGiPTy3nlJnDfXMQe+MrgBWrCFTABlGsHxUBbjhu6r4QmmAPuwfLMXn90f4821c4isps1FV8Wtz6U52+z1bw/dEVX6KWm8rRDEeTmS7yej5Iqu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wFuAVs1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wFuAVs1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6C01F000E9;
	Wed,  1 Jul 2026 22:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782946512;
	bh=ciB5g13xljRCOVAbq8a+Oy6pzzErF4JDahXdtl4Wf1s=;
	h=Date:To:From:Subject;
	b=wFuAVs1odYOGe22oF0Tk8SKTlRNrtsrzwQciLCEpelin8ejV2WEQoxiXBTLrQ0vc0
	 OBVJ3iRThk80DkTg1VYDA9kNPsleoFr3M2J5iAwIJu2wvwRTvAEbhKwvHsuS5tz5FD
	 pC8MVLMM6ZYmNQgIcfX6Td1JJ4tInrRr6SvS/xqk=
Date: Wed, 01 Jul 2026 15:55:12 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,lkp@intel.com,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch added to mm-unstable branch
Message-Id: <20260701225512.AE6C01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

