Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793335798;
	b=qy/TjFOztbhXqjKSJWrg9jvnsz4Mx+SAN+dK2qwS8cdw18bPAfiVmvlh27oHb0XohRuE
	 /eT8cFFg6ICbDhxUgwBkAI7IkdU7+F5jxtdwWTxC+S0/dnNQI+0ToZjQ15+5sU7bC02n0
	 5SJVQK1B1zeSpp9zf2/Gzs4pLrzvXyevI6nCABR2TLFQbNC/uuVr63xXwPy8wqqQPcVx+
	 JV1UKRApdyMm71qxEsWP/gxRLrQskjMrroZcR0UtSc0g4XcsE0ZUyLMaU76zIK37iHKtx
	 ZMSvP4EMETLfFXs6T9D3SCDzO1mOgd9bOFLRsBRfvu6DMtrvqu6Zwx1b0wMnYEz7vlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793335798;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=boRLXJIyEDnKZBtbYe+tmBju0roqJbd1qi7sXtwFnaY=;
	b=oS1A+wK/mjTk4GM265aXOyDNBmeAxi8D3BcaeqDhp1qoe6+lOXbyH5twoWQt0lomtE0D
	 OVZweu6EEzVSngmcddIUUveQC0A1DMkNZ+ev4ddPIIfkL+LIhLm8L0Vlqj291A3uXhK+/
	 idfCQQ9jOOFKoBL2LFJyUYIrRVe6d1Srz/Cp0oLVHa7WAZv0grP1BboamOZDmJcB/FP2Y
	 mwN41scy/LPawv9JzWGRLE0qo/UOgaxqvmsDofp3uns2GZ0nOvCJhFx2fWLet6L7ryouw
	 5cRdPLICHQ5r1TVBqJauBMTeDDAgWmSWZJxkKa2cjNHHLdb3IMA4iguuDVJUopsjRaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Em964XxN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8490F606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 04:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Em964XxN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1AD1F000C1;
	Fri, 30 Oct 2026 04:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793335798;
	bh=boRLXJIyEDnKZBtbYe+tmBju0roqJbd1qi7sXtwFnaY=;
	h=Date:To:From:Subject;
	b=Em964XxNWo8Wq1XGauyDfptxAI4VOE+I25A77wWdGcJi6Ri/GDGleLV0O9Y/gxJKg
	 H2lQZUhxMwpJj2NyRIT81/RMEe63XPhaPurbS7o3IFAiHcCSISmONwO4qvJyJS5mOB
	 vNjrKnFI+4xtawTeZqH1OOn1Zc5X3XaGFa8Kdaf0=
Date: Thu, 29 Oct 2026 21:49:57 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,osalvador@suse.de,
	muchun.song@linux.dev,gourry@gourry.net,david@kernel.org,lienze@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-drop-unused-mm-parameter-from-unmap_ref_private.patch added to mm-new branch
Message-Id: <20261030044958.0B1AD1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: drop unused mm parameter from unmap_ref_private()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-drop-unused-mm-parameter-from-unmap_ref_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-drop-unused-mm-parameter-from-unmap_ref_private.patch

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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/hugetlb: drop unused mm parameter from unmap_ref_private()
Date: Wed, 21 Oct 2026 14:19:01 +0800

The mm parameter has never been used since the helper was introduced in
commit 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process
that called mmap(MAP_PRIVATE) on hugetlbfs will succeed").  Remove it and
drop it at the sole call site.

Link: https://lore.kernel.org/20261021061901.376104-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-drop-unused-mm-parameter-from-unmap_ref_private
+++ a/mm/hugetlb.c
@@ -5519,8 +5519,8 @@ void unmap_hugepage_range(struct vm_area
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
-static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
-			      struct folio *folio, unsigned long address)
+static void unmap_ref_private(struct vm_area_struct *vma, struct folio *folio,
+			      unsigned long address)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
@@ -5696,7 +5696,7 @@ retry_avoidcopy:
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-			unmap_ref_private(mm, vma, old_folio, vmf->address);
+			unmap_ref_private(vma, old_folio, vmf->address);
 
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			hugetlb_vma_lock_read(vma);
_

Patches currently in -mm which might be from lienze@kylinos.cn are

docs-hugetlbpagerst-clarify-hugepages_total-in-hugetlbpagerst.patch
mm-hugetlb-drop-unused-mm-parameter-from-unmap_ref_private.patch

