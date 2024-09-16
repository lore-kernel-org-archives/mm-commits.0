Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A71381B1;
	Mon, 16 Sep 2024 06:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726466619; cv=none; b=WEY8lDYdEEj52yQBzQ4K/o0LVw/GWIXfW4pBdXuJebtkAsnhdPU01Bni7/WxMnptxE+1TeCfjnZg9wdVX8fr3NtXIvsyeKGAg0KlCphX2jYeYqFPOXfASY3gWEK8PyFqWbW3jDkYonnLtMe55QHx/xK84izIem1SrdR5WyxHAqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726466619; c=relaxed/simple;
	bh=kFfemlrgGPHheGJTZlz78t+8wj1zHnLP2V7jvzR6HPM=;
	h=Date:To:From:Subject:Message-Id; b=OdXgPmHKPdhS6YY5sytQdaLYZq3rxc+nfECeah2EPkPpb/Ok3aXtbmI3zf/5+Ok+JLne/xMpMvL0lfwNEj+JHeoei3kQ13MzOcu76RACf1a3cSutaXWfC90QET+vdryVomCUV/W43z8LGvPzUQdJ6YBN1TUvHE14h/3cLXHUh+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kW1hKyjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kW1hKyjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24411C4CEC4;
	Mon, 16 Sep 2024 06:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726466618;
	bh=kFfemlrgGPHheGJTZlz78t+8wj1zHnLP2V7jvzR6HPM=;
	h=Date:To:From:Subject:From;
	b=kW1hKyjF2tshJoMTVnLZjf+QKQ7TWuEgHHC3LPlrB1byBRNVvKM0c8E6Wb+aQOn/r
	 +Eh+j+FI+RDqV1982pOx9YJ5S7a99LQOg/BLLa4igSk2DrMFUJevZrZUw1d94agVlT
	 wzkbipCUOnrrF01PDS2wXtasic1aw66JceBjhuNY=
Date: Sun, 15 Sep 2024 23:03:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-vmf_anon_prepare-to-__vmf_anon_prepare.patch added to mm-hotfixes-unstable branch
Message-Id: <20240916060338.24411C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change vmf_anon_prepare() to __vmf_anon_prepare()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-change-vmf_anon_prepare-to-__vmf_anon_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-vmf_anon_prepare-to-__vmf_anon_prepare.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-change-vmf_anon_prepare-to-__vmf_anon_prepare.patch
mm-hugetlbc-fix-uaf-of-vma-in-hugetlb-fault-pathway.patch

