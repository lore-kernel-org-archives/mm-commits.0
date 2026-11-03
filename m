Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672147;
	b=WatryqmN7pqR2zJhKf1jn6/+p5TCZyr3BCIfGokQwZpkpcRLvzOjweKyWqQq4SmqWuKw
	 Qn5+cZDF3MJSb6NlElBoaR3OyT2gBKWqk9uLf909/2xkcq9eK339NlZAe+kAUxNXKl3rT
	 as93KgY96dVOlDhlNn/9XW8invfPSZKvuyrTkLlVO4YwlNtDexvJntnTSvszK06CadUwQ
	 KsY/SF3lwXCz9TindBM8ERhLb6WSic0zYQI1UNPpPw3AsE6OdfbepR+0M95KToZ51DcGc
	 fVy1yKIjHcwC15aDO/up0Fb9O9CWo1BFg0Ok47Dg9FUtu+MKYEt0cZ176BdFT97BD6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672147;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=APoOSE3eQiTpI/a8/7eMeTk/q6sS/mBd5YfCvBguydo=;
	b=HmPJAWR3wDdwRAAGgXNR1b0+3m42uaD+D2DXgoMWQwyZ6hrZnM5Tq9G24P3CeLwXKtop
	 fcJZVif1h/Chl8K2WlFBee7/8BMKDY7lvzdS+SW/Vg4Dpa+TcHcn0WORo9TAmmIyTl4lv
	 J20UQoWJtLUWKi11FQnNohnKJdAzdWjFsVP4wLpyIHeMVG21clqMEm4v/bqEBbzBlAjZF
	 OPI0CEY3ZHA3b1lfuW9LCxDxzpDcvvq3etd0klZVv59vaL0rPgGWAxzAo9p5dZF2U6JLk
	 pAiIummi5MO9KfsJUmusVmmWSDzGiogV12lUZBGD24kljNMlj0h5GUHDbiIw/OTo/YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rL7fMwcq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2B3606A32E;
	Tue,  3 Nov 2026 02:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rL7fMwcq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8B81F000C1;
	Tue,  3 Nov 2026 02:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672146;
	bh=APoOSE3eQiTpI/a8/7eMeTk/q6sS/mBd5YfCvBguydo=;
	h=Date:To:From:Subject;
	b=rL7fMwcqn+ckPFbur97k19MzPOh9wBs5FNbqbx1l0RgHKrT+wS7mbhvHRBlljbSTH
	 eQ0p/CAoPKZtd2pPhD1Q8b7mn5xdAAGZNe65rLpNSVy6yNViDyr+uJ/HqWRTyBfHcd
	 eYpjAQdh6cHj8tvej35qP2Ikz15R14xXt5hUlcPU=
Date: Mon, 02 Nov 2026 18:15:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin@linux.dev,
	xemul@openvz.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	sj@kernel.org,shli@fb.com,seanjc@google.com,samarth.colleges@gmail.com,
	rppt@kernel.org,riel@surriel.com,peterx@redhat.com,pbonzini@redhat.com,
	mhocko@suse.com,mgorman@techsingularity.net,med08elkadiri@gmail.com,
	mcfadden8@llnl.gov,ljs@kernel.org,liam@infradead.org,kas@kernel.org,
	jthoughton@google.com,jglisse@redhat.com,hughd@google.com,hannes@cmpxchg.org,
	gokhale2@llnl.gov,dplotnikov@virtuozzo.com,dgilbert@interlog.com,
	david@kernel.org,cracauer@cons.org,corbet@lwn.net,chengming.zhou@linux.dev,
	bobbypowers@gmail.com,bgeffon@google.com,aarcange@redhat.com,
	lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-ksm-fix-userfaultfd-protection-during-merge-and-unmerge.patch removed from -mm tree
Message-Id: <20261103021546.7D8B81F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/ksm: fix userfaultfd protection during merge and unmerge
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-userfaultfd-protection-during-merge-and-unmerge.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
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
@@ -4125,8 +4125,11 @@ static vm_fault_t wp_page_copy(struct vm
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
@@ -6662,9 +6665,12 @@ static vm_fault_t handle_pte_fault(struc
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


