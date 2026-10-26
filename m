Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051152;
	b=tGjXGMmQjsDeWLYjzfsSkSOysJMB/pNGjg4wmlX7sixTDZ/139wGooCANW97ur196D2l
	 XOCfRNMzb/kD9hD9MfDRY6AwYo4S0AZ4+cwqbNr/VHvn43/TU+8Vp1YhtXUKHEKF8BLIa
	 gI+AeWinISrCiYG1FC83Q3WXyZJVlXHos+8yz7xW37+ldai3y6XIU4vy34nXxQmSs+IyW
	 PCK/O6/thtMqlyncZugX0X+PYOGnTLXvzjlGvlpYavo7MJfYgOMvoptu2ic2gLt4OZ2j2
	 YRZqpFMQJcpUFGyxLloiYmJMg//IvzN5k438p3YMR+cXY205tuhOdAC39eDZtz1lc9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051152;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=LIxn8dmLwdRcxbqau0966HmEjpdstbqbz/jOXmMb9Yo=;
	b=TZvrkadaDCqynBwQKgUZQ9IZy7108SQTZ3/5FP9MOW77vTeQ5EEzS3mb7FGSxnupmsty
	 d2tWe1BLOia0uuO12MCqs4qVCgLWvwzdD+ittq0XssbdvKkonZ2roqe4cDHJGrIG0JIPB
	 tY7taYPu2vaZXcz9QfoNlHD8jCLzUyjTFhp0rF2qh9uUgeWn8z5R65rOfJArwHjbRo/Wo
	 Iw2qxK9Ogqh/LNpyzkGHVALSVzgBLEY8fslJ/MJGw/2M50ZBgymuHNdYUv5v6a5JLFcr9
	 TH58wAjgcC8aqZ2gZyezVJRA4ViphA6IC1NKQJvUH+LBPFf46rEPex6D8cuOENDWRgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dqVeQbC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A3606A31A;
	Mon, 26 Oct 2026 21:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dqVeQbC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3311F0128D;
	Mon, 26 Oct 2026 21:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793051151;
	bh=LIxn8dmLwdRcxbqau0966HmEjpdstbqbz/jOXmMb9Yo=;
	h=Date:To:From:Subject;
	b=dqVeQbC4qIr0XKEoTYc0sRzMppaWWsQ4lfslmU5vODkfafafBD35bSExBo8m45lOr
	 5E48nR7u228pWNG0GB7+sukWVHH5gmfZeyMDdWY5Kpg3qrBWRT4zXiBWNbJG7Kx8DT
	 MPrg57Pejb/WNwATi+tCF0PMkKozDok0saxZRrTs=
Date: Mon, 26 Oct 2026 14:45:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin@linux.dev,
	xemul@openvz.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	sj@kernel.org,shli@fb.com,seanjc@google.com,samarth.colleges@gmail.com,
	rppt@kernel.org,riel@surriel.com,peterx@redhat.com,pbonzini@redhat.com,
	mike.kravetz@oracle.com,mhocko@suse.com,mgorman@techsingularity.net,
	med08elkadiri@gmail.com,mcfadden8@llnl.gov,ljs@kernel.org,liam@infradead.org,
	kas@kernel.org,jthoughton@google.com,jglisse@redhat.com,hughd@google.com,
	hannes@cmpxchg.org,gokhale2@llnl.gov,dplotnikov@virtuozzo.com,
	dgilbert@interlog.com,david@kernel.org,cracauer@cons.org,corbet@lwn.net,
	chengming.zhou@linux.dev,bobbypowers@gmail.com,bgeffon@google.com,
	aarcange@redhat.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-userfaultfd-protection-during-merge-and-unmerge.patch added to mm-unstable branch
Message-Id: <20261026214551.8F3311F0128D@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/ksm: fix userfaultfd protection during merge and unmerge
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-fix-userfaultfd-protection-during-merge-and-unmerge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-userfaultfd-protection-during-merge-and-unmerge.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/ksm: fix userfaultfd protection during merge and unmerge
Date: Mon, 26 Oct 2026 21:00:54 +0800

KSM loses userfaultfd protection when replace_page() builds a new PTE from
vma->vm_page_prot.  Dropping its uffd bit lets a subsequent write go
through ordinary COW instead of userfaultfd write protection handling. 
For RWP, a merged page also becomes readable without faulting.

Keeping the uffd bit and restoring PAGE_NONE fixes merging, but we also
have to handle unmerging.  An existing KSM page can be protected with RWP
before MADV_UNMERGEABLE, so unmerging already needs fixing independently
of preserving RWP during merging.

Unsharing replaces a shared page with a private one and should leave
userfaultfd protection in place, as do_wp_page() already does for write
protection.  Currently, an unshare fault reaches do_uffd_rwp() before it
can proceed to do_wp_page().

- With synchronous RWP, handle_userfault() returns VM_FAULT_SIGBUS.
  break_ksm() then reports success with a KSM page still merged.

- With asynchronous RWP, protection is cleared before unsharing.

Preserve the uffd bit when merging, and restore PAGE_NONE for RWP.  Let
FAULT_FLAG_UNSHARE skip RWP fault handling and keep PAGE_NONE on each
private copy as well.  Unsharing can then complete with RWP still armed
for a subsequent access.

Link: https://lore.kernel.org/20261026130054.91461-1-lance.yang@linux.dev
Link: https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/
Link: https://lore.kernel.org/all/20261020055518.36087-1-lance.yang@linux.dev/
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Samarth Narang <samarth.colleges@gmail.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Xu Xin <xu.xin@linux.dev>"
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shaohua Li <shli@fb.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/ksm.c    |    8 +++++++-
 mm/memory.c |   14 ++++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-userfaultfd-protection-during-merge-and-unmerge
+++ a/mm/ksm.c
@@ -34,6 +34,7 @@
 #include <linux/memory.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/ksm.h>
 #include <linux/hashtable.h>
 #include <linux/freezer.h>
@@ -1463,9 +1464,14 @@ static int replace_page(struct vm_area_s
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
-	/* Preserve soft-dirty when replacing the page. */
+	/* Preserve soft-dirty and uffd protection when replacing the page. */
 	if (pte_soft_dirty(orig_pte))
 		newpte = pte_mksoft_dirty(newpte);
+	if (pte_uffd(orig_pte)) {
+		newpte = pte_mkuffd(newpte);
+		if (userfaultfd_rwp(vma))
+			newpte = pte_modify(newpte, PAGE_NONE);
+	}
 
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
--- a/mm/memory.c~mm-ksm-fix-userfaultfd-protection-during-merge-and-unmerge
+++ a/mm/memory.c
@@ -4122,8 +4122,11 @@ static vm_fault_t wp_page_copy(struct vm
 		if (unlikely(unshare)) {
 			if (pte_soft_dirty(vmf->orig_pte))
 				entry = pte_mksoft_dirty(entry);
-			if (pte_uffd(vmf->orig_pte))
+			if (pte_uffd(vmf->orig_pte)) {
 				entry = pte_mkuffd(entry);
+				if (userfaultfd_rwp(vma))
+					entry = pte_modify(entry, PAGE_NONE);
+			}
 		} else {
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		}
@@ -6659,9 +6662,12 @@ static vm_fault_t handle_pte_fault(struc
 		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
 		 * NUMA hinting and must still fall through to do_numa_page().
 		 */
-		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
-			return do_uffd_rwp(vmf);
-		return do_numa_page(vmf);
+		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte)) {
+			if (!(vmf->flags & FAULT_FLAG_UNSHARE))
+				return do_uffd_rwp(vmf);
+		} else {
+			return do_numa_page(vmf);
+		}
 	}
 
 	spin_lock(vmf->ptl);
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-ksm-fix-userfaultfd-protection-during-merge-and-unmerge.patch

