Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C13043AA8;
	Tue, 17 Sep 2024 07:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726559922; cv=none; b=llNQQPN6Ry4JnkMs8kHlK+2/DpqIrgssn1Rq/hLJ/RrPi9NOHS4XBEnWwKn2BMLeQaVMJh1NAZKyahbcAHHNVZ70jdKflQtmTccO8H2HtbewZ4/HDmvS+Su/7B3Gn9fvt4LQqSslHBrIaMhZOL21h0TVey67pGRdGkOPQ1YROnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726559922; c=relaxed/simple;
	bh=T6gObr8sR1HSn74g3pttCWYFQ6mvZ5m0ww/sFYU+hdM=;
	h=Date:To:From:Subject:Message-Id; b=k6PuvOVSf1PVIoyYVOWQTHaPe3ia0yjWeHdvflVL9x5lv+V68CTgF4nO+TvB3DYtRK4ddUF85xeUw8XLg231kM0jv7mrhjYwLR2tHjOHLuQ9uhh/mAqnczthpX3OUlHYow1KKATYVivtHTxba6M/uCMRpuVevtOCLWa76zakaQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0UWk3ZeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0UWk3ZeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F65C4CEC6;
	Tue, 17 Sep 2024 07:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726559921;
	bh=T6gObr8sR1HSn74g3pttCWYFQ6mvZ5m0ww/sFYU+hdM=;
	h=Date:To:From:Subject:From;
	b=0UWk3ZeGxcSyU/fXJqgFlwkRLfjg5Q4KnmKDT018aNixoygwjWtO/uQTl8+G54BkB
	 GS5jurVrb1eEyvacZskdZiWvG3EOzFlZZ5SFzjjGc0jLhHuDVS1+vyOV2Kra4gCSTa
	 vMaFLPXHsItMCIFCP3hbB33f7F9LXLRs8mVkGJFY=
Date: Tue, 17 Sep 2024 00:58:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-change-vmf_anon_prepare-to-__vmf_anon_prepare.patch removed from -mm tree
Message-Id: <20240917075841.75F65C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change vmf_anon_prepare() to __vmf_anon_prepare()
has been removed from the -mm tree.  Its filename was
     mm-change-vmf_anon_prepare-to-__vmf_anon_prepare.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: change vmf_anon_prepare() to __vmf_anon_prepare()
Date: Sat, 14 Sep 2024 12:41:18 -0700

Some callers of vmf_anon_prepare() may not want us to release the per-VMA
lock ourselves.  Rename vmf_anon_prepare() to __vmf_anon_prepare() and let
the callers drop the lock when desired.

Also, make vmf_anon_prepare() a wrapper that releases the per-VMA lock
itself for any callers that don't care.

This is in preparation to fix this bug reported by syzbot:
https://lore.kernel.org/linux-mm/00000000000067c20b06219fbc26@google.com/

Link: https://lkml.kernel.org/r/20240914194243.245-1-vishal.moola@gmail.com
Fixes: 9acad7ba3e25 ("hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()")
Reported-by: syzbot+2dab93857ee95f2eeb08@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/00000000000067c20b06219fbc26@google.com/
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   11 ++++++++++-
 mm/memory.c   |    8 +++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/mm/internal.h~mm-change-vmf_anon_prepare-to-__vmf_anon_prepare
+++ a/mm/internal.h
@@ -310,7 +310,16 @@ static inline void wake_throttle_isolate
 		wake_up(wqh);
 }
 
-vm_fault_t vmf_anon_prepare(struct vm_fault *vmf);
+vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf);
+static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+{
+	vm_fault_t ret = __vmf_anon_prepare(vmf);
+
+	if (unlikely(ret & VM_FAULT_RETRY))
+		vma_end_read(vmf->vma);
+	return ret;
+}
+
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
--- a/mm/memory.c~mm-change-vmf_anon_prepare-to-__vmf_anon_prepare
+++ a/mm/memory.c
@@ -3259,7 +3259,7 @@ static inline vm_fault_t vmf_can_call_fa
 }
 
 /**
- * vmf_anon_prepare - Prepare to handle an anonymous fault.
+ * __vmf_anon_prepare - Prepare to handle an anonymous fault.
  * @vmf: The vm_fault descriptor passed from the fault handler.
  *
  * When preparing to insert an anonymous page into a VMA from a
@@ -3273,7 +3273,7 @@ static inline vm_fault_t vmf_can_call_fa
  * Return: 0 if fault handling can proceed.  Any other value should be
  * returned to the caller.
  */
-vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
@@ -3281,10 +3281,8 @@ vm_fault_t vmf_anon_prepare(struct vm_fa
 	if (likely(vma->anon_vma))
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		if (!mmap_read_trylock(vma->vm_mm)) {
-			vma_end_read(vma);
+		if (!mmap_read_trylock(vma->vm_mm))
 			return VM_FAULT_RETRY;
-		}
 	}
 	if (__anon_vma_prepare(vma))
 		ret = VM_FAULT_OOM;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


