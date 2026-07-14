Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA9936A34D
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 03:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783998541; cv=none; b=uPwyZMp3vhzytecZINegiqcql8feFcLofvGOpZAGV9xcY5BtMe8CuMuyEnVFaFxuzc/iR+leoJGDcuJS3zqD+UiK6OnxKWLnXtw1clKgHIE+pMfUAHcWwoDmdWI6Z87oFVziPyypM0gDN+DMH/QyfsLhMtmcBiyLTWj8AIdDqC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783998541; c=relaxed/simple;
	bh=iOLfZxJ0oA9OtJYdnG4AfjxPzJnvQ/ewOKKWD1SQ0v0=;
	h=Date:To:From:Subject:Message-Id; b=dnRA32ORhkeumYr0+lHNSdu/ApqcvOqLZHm3W3DShtdSjbWaKfVJL13gIrjK5tYaf7oSL8SRhEFF0dz8O/CPsE8OTN2RECPoQjDjrbkaP/tU4QAwBtaT42ehT7lEwfLmmRYRte3M6VbExsD8NAKn8dHNxLV4XsRKn4B1V+Cs490=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=No7I0atE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="No7I0atE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE77E1F000E9;
	Tue, 14 Jul 2026 03:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783998540;
	bh=omVcOyblmISJHudHnffW04ifsfBXxRHFhY2+6FvtAN0=;
	h=Date:To:From:Subject;
	b=No7I0atE4Ck2iGmSfecc+ZqVlE+ieoUC0gkmp8un+ymuc3qs6bkwOgDN/Hg+rqcpx
	 jZNeHrx9Dmblov798QAEAYtlHLHpZwtuh2oCARFMf0ImAqY0L0gtTzALtyCrq70OGN
	 aOjHYj86gERgWVgFZHTY2vni86JmP5V/Ix7+QgoE=
Date: Mon, 13 Jul 2026 20:08:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wang.yaxin@zte.com.cn,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch added to mm-new branch
Message-Id: <20260714030859.EE77E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_slot.h: add comments for mm_slot_lookup/insert
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: mm/mm_slot.h: add comments for mm_slot_lookup/insert
Date: Tue, 14 Jul 2026 09:28:15 +0800 (CST)

mm_slot_lookup() and mm_slot_insert() are the only helpers in this header
that are implemented as macros rather than static inline functions.  This
may look inconsistent without explanation.

Explain they must be macros because hash_for_each_possible() needs the
table as an array (for sizeof), not a pointer.

Link: https://lore.kernel.org/20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Cc: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_slot.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/mm_slot.h~mm-mm_sloth-add-comments-for-mm_slot_lookup-insert
+++ a/mm/mm_slot.h
@@ -33,6 +33,12 @@ static inline void mm_slot_free(struct k
 	kmem_cache_free(cache, objp);
 }
 
+/*
+ * Note: mm_slot_lookup and mm_slot_insert cannot be converted to static inline
+ * functions because the hash helpers (hash_for_each_possible and hash_add) rely
+ * on the actual array argument 'hashtable' for sizeof() instead of pointers.
+ */
+
 #define mm_slot_lookup(_hashtable, _mm) 				       \
 ({									       \
 	struct mm_slot *tmp_slot, *mm_slot = NULL;			       \
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-add-linear_page_index-into-ksm_rmap_item.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch
ksm-add-mremap-selftests-for-ksm_rmap_walk.patch
mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm.patch
ksm-use-precise-linear_page_index-instead-of-the-whole-address-space.patch
mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch
mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch

