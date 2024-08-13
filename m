Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C177B15A8
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 02:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723516064; cv=none; b=V2DJmbZ8hUUX0j+fDwQa6JlSi9FC6pqoL887VgjGhTnQlYLo+qaghGQCpvW3FQRg0FGF9CrDfvKawk7UepMWu5pqX0/oE7e8sNCa1oEp43t6Y3P7lJ7WRs3esA8Xvs+m95SHGUxAgVzdsJkriu6d1qZUNJv9b+YcBQQtOR3RJkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723516064; c=relaxed/simple;
	bh=FAqSqsRxm8OvTjoZik4oBKgfbaSF5P8z2aEbxUQr+W4=;
	h=Date:To:From:Subject:Message-Id; b=tqHCoj6YTHzz2/bwBQUiTt9Q6bM/pkam7sYxkzxkDrAy3AUDdefVFxj4ura22ZG7fe6qCferi89Q7ExRxM/tuQMfCY1lulw62xiESoEkTrhl1mTl7JuW0CNXddYvyOwJIwLNAWcBuCssgS0sGOfF0iepM1cPRXWAqj5Ae+9IcW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qNEacpGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qNEacpGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C65C4AF09;
	Tue, 13 Aug 2024 02:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723516064;
	bh=FAqSqsRxm8OvTjoZik4oBKgfbaSF5P8z2aEbxUQr+W4=;
	h=Date:To:From:Subject:From;
	b=qNEacpGt/bZi0bFXp2KVgeVuA/rOAbLqHE2tSD9tyz05pVkCVRkAFAMNZ3h634qL0
	 qNZdpJEyFGFZFbDx5inKDGbNpdZt0CNZDhar7rBDEJxJHeaTljmLW5DGm40NV0qwiX
	 ilSsJ9Sp2PnCVeQ6mH2BZ0iD76J4yK0izSanacqs=
Date: Mon, 12 Aug 2024 19:27:43 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mgorman@techsingularity.net,kirill@shutemov.name,jthoughton@google.com,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-dax-dump-start-address-in-fault-handler.patch removed from -mm tree
Message-Id: <20240813022744.30C65C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/dax: dump start address in fault handler
has been removed from the -mm tree.  Its filename was
     mm-dax-dump-start-address-in-fault-handler.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/dax: dump start address in fault handler
Date: Wed, 7 Aug 2024 15:48:05 -0400

Patch series "mm/mprotect: Fix dax puds", v4.

Dax supports pud pages for a while, but mprotect on puds was missing since
the start.

The problem is mprotect() will skip the dax 1G PUD while it shouldn't;
meanwhile it'll dump some bad PUD in dmesg.  Both of them look like (corner
case) bugs to me.. where:

  - skipping the 1G pud means mprotect() will succeed even if the pud won't
    be updated with the correct permission specified. Logically that can
    cause e.g. in mprotect(RO) then write the page can cause data corrupt,
    as the pud page will still be writable.

  - the bad pud will generate a pr_err() into dmesg, with no limit so far I
    can see.  So I think it means an userspace can DoS the kernel log if it
    wants.. simply by creating the PUD and keep mprotect-ing it

This series tries to fix that by providing pud handling in mprotect(). 
The goal is to add more types of pud mappings like hugetlb or pfnmaps. 
This series paves way for it by fixing known pud entries.

Considering nobody reported this until when I looked at those other types
of pud mappings, I am thinking maybe it doesn't need to be a fix for
stable and this may not need to be backported.  I would guess whoever
cares about mprotect() won't care 1G dax puds yet, vice versa.  I hope
fixing that in new kernels would be fine, but I'm open to suggestions.

There are a few small things changed to teach mprotect work on PUDs.  E.g.
it will need to start with dropping NUMA_HUGE_PTE_UPDATES which may stop
making sense when there can be more than one type of huge pte.  OTOH,
we'll also need to push the mmu notifiers from pmd to pud layers, which
might need some attention but so far I think it's safe.  For such details,
please refer to each patch's commit message.

The mprotect() pud process should be straightforward, as I kept it as
simple as possible.  There's no NUMA handled as dax simply doesn't support
that.  There's also no userfault involvements as file memory (even if work
with userfault-wp async mode) will need to split a pud, so pud entry
doesn't need to yet know userfault's existance (but hugetlb entries will;
that's also for later).


This patch (of 7):

Currently the dax fault handler dumps the vma range when dynamic debugging
enabled.  That's mostly not useful.  Dump the (aligned) address instead
with the order info.

Link: https://lkml.kernel.org/r/20240807194812.819412-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240807194812.819412-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/dax/device.c~mm-dax-dump-start-address-in-fault-handler
+++ a/drivers/dax/device.c
@@ -235,9 +235,9 @@ static vm_fault_t dev_dax_huge_fault(str
 	int id;
 	struct dev_dax *dev_dax = filp->private_data;
 
-	dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) order:%d\n", current->comm,
-			(vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
-			vmf->vma->vm_start, vmf->vma->vm_end, order);
+	dev_dbg(&dev_dax->dev, "%s: op=%s addr=%#lx order=%d\n", current->comm,
+		(vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
+		vmf->address & ~((1UL << (order + PAGE_SHIFT)) - 1), order);
 
 	id = dax_read_lock();
 	if (order == 0)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-mprotect-push-mmu-notifier-to-puds.patch
mm-powerpc-add-missing-pud-helpers.patch
mm-x86-make-pud_leaf-only-care-about-pse-bit.patch
mm-x86-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch

