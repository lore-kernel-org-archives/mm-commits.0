Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3925424211
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723759993; cv=none; b=k5nAlWxEgEzjmK0W4/IAORSSyyQfgxZ7+mqm7cS9R7cqNO9ESb2cdbPDeC0ilgaI7xJPLOsK+40ly/uUXiCJgN0UFX8EbHo8Jow7wkAAmF5lN2TBUh92Mzj66hFNmr0NKdRRQBksF/SY5vay0htfgywpPoIXsCe7kr6S3nRl9WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723759993; c=relaxed/simple;
	bh=qVRmOWU9H94w7UNlh78oRlIEAXR3ULVFoANMC0c5dT8=;
	h=Date:To:From:Subject:Message-Id; b=XdreAb0INxZH4tIDYJN5OLWtqb0sAjom+mSAHQSwD7puddbW2WIiiWSS/pgrADPzG3Swq+aUoFiZ4zZ8HMod8enK5Ng3QOymOc2BDvWJDtPVLvwJHDtrBrIdOOh66O3sW988W0yHdCq8KozlAf5lMu3xwYZf77gdD/xki1YZaK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rIJAzT1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rIJAzT1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94782C32786;
	Thu, 15 Aug 2024 22:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723759992;
	bh=qVRmOWU9H94w7UNlh78oRlIEAXR3ULVFoANMC0c5dT8=;
	h=Date:To:From:Subject:From;
	b=rIJAzT1r7G9C8i6jvX8VTPBmQAaIQz1w4EFtchQTP4REwvquhoAzKGUeOU1vVEMqY
	 hPe+eT3Wjc1xKTGqwOEHlIuCI02x685HuLsnCtA8PHL21U0I0g/NRDcU80tSjt93ue
	 vtjdfNggMVYGDq0FWzCpcnyTchMaksglYVtrYLxM=
Date: Thu, 15 Aug 2024 15:13:11 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch added to mm-unstable branch
Message-Id: <20240815221312.94782C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: check all swaps belong to same swap_cgroup in swap_pte_batch()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: check all swaps belong to same swap_cgroup in swap_pte_batch()
Date: Fri, 16 Aug 2024 09:36:23 +1200

Right now, it is possible two folios are contiguous in swap slots but they
don't belong to one memcg.  In this case, even we return a large nr, we
can't really batch free all slots.

Link: https://lkml.kernel.org/r/20240815215308.55233-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix
+++ a/mm/internal.h
@@ -15,6 +15,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
 
 /* Internal core VMA manipulation functions. */
@@ -275,18 +276,22 @@ static inline int swap_pte_batch(pte_t *
 {
 	pte_t expected_pte = pte_next_swp_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
+	swp_entry_t entry = pte_to_swp_entry(pte);
 	pte_t *ptep = start_ptep + 1;
+	unsigned short cgroup_id;
 
 	VM_WARN_ON(max_nr < 1);
 	VM_WARN_ON(!is_swap_pte(pte));
-	VM_WARN_ON(non_swap_entry(pte_to_swp_entry(pte)));
+	VM_WARN_ON(non_swap_entry(entry));
 
+	cgroup_id = lookup_swap_cgroup_id(entry);
 	while (ptep < end_ptep) {
 		pte = ptep_get(ptep);
 
 		if (!pte_same(pte, expected_pte))
 			break;
-
+		if (lookup_swap_cgroup_id(pte_to_swp_entry(pte)) != cgroup_id)
+			break;
 		expected_pte = pte_next_swp_offset(expected_pte);
 		ptep++;
 	}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch
vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch
mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch
mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch

