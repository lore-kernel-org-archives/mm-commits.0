Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A508C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600524; cv=none; b=KwL/HSfgzESW6eLNIV1skmfaYbg+ogJEaDlQd2o8R/LaaSyT3xaXpwPtvgDcu9ioiiCqDJhdtnIrQIy/QX110j6QEMDVwJDDvXbd5aKnCoN5kKNJiMXFz9r3EabSdmcYHLPuq4PCN6eaVzQ77x1CTlBxe8bTjnF+AuxXFU+omcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600524; c=relaxed/simple;
	bh=tY7vLavDTxXOW1gnTFMfcTeo1FXi2pw4Lty2h4GcwMQ=;
	h=Date:To:From:Subject:Message-Id; b=e3EcPpvZyN28SeHS27q7a81D9ixPSdw22HRs0dvAEs+gvc0SjP3NDUkXe8i6zMpOPNYRqPesWtvD4C8mXnukFwqfMW/iMGLf7GCQLqYx8jOAUtxdvg4t247lYygXndhWppTyg5OhqQBoHCBBXn4uZciYjT8eGgFmZDVWor2Kbwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o+bPOi8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o+bPOi8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B913C433F1;
	Tue,  5 Mar 2024 01:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600524;
	bh=tY7vLavDTxXOW1gnTFMfcTeo1FXi2pw4Lty2h4GcwMQ=;
	h=Date:To:From:Subject:From;
	b=o+bPOi8slRNBiRbQ8qkFLz5TG/mU6eRmWjmFjPQnuRF1s/TScD9UhsiaSdBm3Y0Yt
	 1F98A0xVtiK+vSVFTgIr2+xW+/A8Q187Dqp13jrKyvzmIbfehcmYteykchBOLz+lqp
	 8qjoJORwfSJu5gvNq1KyLdvlDckB/pX0mp843uic=
Date: Mon, 04 Mar 2024 17:02:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-change-vmf_anon_prepare-to-be-non-static.patch removed from -mm tree
Message-Id: <20240305010204.6B913C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: change vmf_anon_prepare() to be non-static
has been removed from the -mm tree.  Its filename was
     mm-memory-change-vmf_anon_prepare-to-be-non-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/memory: change vmf_anon_prepare() to be non-static
Date: Wed, 21 Feb 2024 15:47:28 -0800

Patch series "Handle hugetlb faults under the VMA lock", v2.

It is generally safe to handle hugetlb faults under the VMA lock.  The
only time this is unsafe is when no anon_vma has been allocated to this
vma yet, so we can use vmf_anon_prepare() instead of anon_vma_prepare() to
bailout if necessary.  This should only happen for the first hugetlb page
in the vma.

Additionally, this patchset begins to use struct vm_fault within
hugetlb_fault().  This works towards cleaning up hugetlb code, and should
significantly reduce the number of arguments passed to functions.

The last patch in this series may cause ltp hugemmap10 to "fail".  This is
because vmf_anon_prepare() may bailout with no anon_vma under the VMA lock
after allocating a folio for the hugepage.  In free_huge_folio(), this
folio is completely freed on bailout iff there is a surplus of hugetlb
pages.  This will remove a folio off the freelist and decrement the number
of hugepages while ltp expects these counters to remain unchanged on
failure.  The rest of the ltp testcases pass.


This patch (of 2):

In order to handle hugetlb faults under the VMA lock, hugetlb can use
vmf_anon_prepare() to ensure we can safely prepare an anon_vma.  Change it
to be a non-static function so it can be used within hugetlb as well.

Link: https://lkml.kernel.org/r/20240221234732.187629-6-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20240221234732.187629-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 +
 mm/memory.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-memory-change-vmf_anon_prepare-to-be-non-static
+++ a/mm/internal.h
@@ -103,6 +103,7 @@ static inline void wake_throttle_isolate
 		wake_up(wqh);
 }
 
+vm_fault_t vmf_anon_prepare(struct vm_fault *vmf);
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
--- a/mm/memory.c~mm-memory-change-vmf_anon_prepare-to-be-non-static
+++ a/mm/memory.c
@@ -3280,7 +3280,7 @@ static inline vm_fault_t vmf_can_call_fa
 	return VM_FAULT_RETRY;
 }
 
-static vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


