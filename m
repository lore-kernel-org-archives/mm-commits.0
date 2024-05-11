Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F981E89A
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467345; cv=none; b=Eote53Ct1rzeDQh9KMK8czniJG7QFxDmkNdT7gHF07aYhsLsonsng4ZBrwSkPrraGfWFDPQPE/RH/bmLz3cEU9I6zNgYdG1zOdNShnhXGo5jloK1D22K+EWIz9qYX8a5LlGX8iiE5rw8ZDTE8k92G5NdLo6xpV1Meh53P1ACv1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467345; c=relaxed/simple;
	bh=2aY0uANknr1HA9jEz9YVWnUMT9P8xp/Vtm6uzJOwLh4=;
	h=Date:To:From:Subject:Message-Id; b=tSzzkJgUYWrsOTMZaRMA6US5zkKFtIlcjcmoJOMlE7PxJpXGoOD8I0+qoAsIx7IB4ZFXIK9luwH6tWGCyxOlRvMHRSlvIyCoC6OAP7CEsRb1+25t3ccENTHpm08gPWU5FR1yPGgwhpURw5aUfqx9jP8gIc7ssEhQotjq7nT2j5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E9X0FAsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E9X0FAsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AA8C2BBFC;
	Sat, 11 May 2024 22:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467343;
	bh=2aY0uANknr1HA9jEz9YVWnUMT9P8xp/Vtm6uzJOwLh4=;
	h=Date:To:From:Subject:From;
	b=E9X0FAsdD7FvkDSOlKaSCMVysZhria2NyIApmkpF8o5riOjJQE9R3sWX166rk/wlN
	 529fuRE/nXm2STebjUEWV0H7a2QMih6sb0cnERnbvvv+AW+ZRMCCttVaOI25Y9o8HC
	 zPb77uLl4EttRAsE1E60/q9ZOmFK+8sVC3jFrIbg=
Date: Sat, 11 May 2024 15:42:23 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,liushixin2@huawei.com,axelrasmussen@google.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_fault.patch removed from -mm tree
Message-Id: <20240511224223.A8AA8C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: add missing VM_FAULT_SET_HINDEX in hugetlb_fault
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/hugetlb: add missing VM_FAULT_SET_HINDEX in hugetlb_fault
Date: Thu, 9 May 2024 12:01:47 +0200

Patch series "Minor fixups for hugetlb fault path".

This series contains a couple of fixups for hugetlb_fault and hugetlb_wp
respectively, where a VM_FAULT_SET_HINDEX call was missing.

I did not bother with a Fixes tag because the missing piece here is that
we will not report to userspace the right extension of the faulty area by
adjusting struct kernel_siginfo.si_addr_lsb, but I do not consider that to
be a big issue because I assume that userspace already knows the size of
the mapping anyway.


This patch (of 2):

commit af19487f00f3 ("mm: make PTE_MARKER_SWAPIN_ERROR more general")
added the code to handle pte_markers in hugetlb faulting path.  In case of
an UFFD_POISON event, a PTE_MARKER_POISONED will be created and we will
return VM_FAULT_HWPOISON_LARGE upon detecting that in the fault path.  Add
the missing VM_FAULT_SET_HINDEX, so the right si_addr_lsb will be passed
to userspace to report the extension of the faulty area.

Link: https://lkml.kernel.org/r/20240509100148.22384-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20240509100148.22384-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -6485,7 +6485,8 @@ vm_fault_t hugetlb_fault(struct mm_struc
 				pte_marker_get(pte_to_swp_entry(vmf.orig_pte));
 
 			if (marker & PTE_MARKER_POISONED) {
-				ret = VM_FAULT_HWPOISON_LARGE;
+				ret = VM_FAULT_HWPOISON_LARGE |
+				      VM_FAULT_SET_HINDEX(hstate_index(h));
 				goto out_mutex;
 			}
 		}
_

Patches currently in -mm which might be from osalvador@suse.de are


