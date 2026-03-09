Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE7A2E1F0E
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078602; cv=none; b=cxh3Znnmemj0ZqPAlyteHlbDLepMzzGDUZxX49FqZBBpO0GB/nhnlEow4qaKdPWcpcT5JyjNPHq7TWDGdKJK9Los4V0i24OzNMxtOmHAmBq7xe+6TiPoCHKZnQpQQf4pmLgfR/0UkTvM9aXUePaQTShGVh2qhLI/qSvoEhpkleQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078602; c=relaxed/simple;
	bh=JjXiP7+Bf4yspgMXcL1J8aZ7snkJVwSyXXfUUQjvgaM=;
	h=Date:To:From:Subject:Message-Id; b=pwaznWdfruLkckNqwOhf6B42qaNNvxNoFE9Ku4cyCnji3Z+pUjJRIaURipH/1iryjtR1WSpbQL57V00es/2onTgpL/ilC7hRM9na42qDWjPoJsnJRkQPY5COUPWNN8pqDPA2Rj0b8JuqJs+1HMVZ+Hyqsk88rQ89fjzghtSp+bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xdbWMsSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xdbWMsSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E32C2BC87;
	Mon,  9 Mar 2026 17:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773078602;
	bh=JjXiP7+Bf4yspgMXcL1J8aZ7snkJVwSyXXfUUQjvgaM=;
	h=Date:To:From:Subject:From;
	b=xdbWMsSXpmsLwCJOlrXOfcqGTC2Fj9LkQbXOMb5SRn8Lrb9+i0pFIk8Zc1xgHv2hv
	 epOEoNs1LqA2WwU02aXSLCJTa3rMPSP+VRdOMEpuFreFPzgz4fZpeEz+JXkh5JXuMZ
	 8ghwPQH5WZFg5ttpi2QEmeNGuuLAwzcWE4WGnyjo=
Date: Mon, 09 Mar 2026 10:50:01 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,dan.j.williams@intel.com,chleroy@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-remove-hugetlbh-inclusion.patch added to mm-new branch
Message-Id: <20260309175001.F3E32C2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KVM: remove hugetlb.h inclusion
has been added to the -mm mm-new branch.  Its filename is
     kvm-remove-hugetlbh-inclusion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-remove-hugetlbh-inclusion.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: KVM: remove hugetlb.h inclusion
Date: Mon, 9 Mar 2026 16:19:00 +0100

hugetlb.h is no longer required now that we moved vma_kernel_pagesize() to
mm.h.

Link: https://lkml.kernel.org/r/20260309151901.123947-4-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/virt/kvm/kvm_main.c~kvm-remove-hugetlbh-inclusion
+++ a/virt/kvm/kvm_main.c
@@ -41,7 +41,6 @@
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/srcu.h>
-#include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
_

Patches currently in -mm which might be from david@kernel.org are

mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch
mm-pagewalk-drop-fw_migration.patch
mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix.patch
mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch
mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch
mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch
mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch
mm-memory-rename-unmap_single_vma-to-__zap_vma_range.patch
mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch
mm-memory-convert-details-even_cows-into-details-skip_cows.patch
mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch
mm-rename-zap_vma_pages-to-zap_vma.patch
mm-rename-zap_page_range_single_batched-to-zap_vma_range_batched.patch
mm-rename-zap_page_range_single-to-zap_vma_range.patch
mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch
mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch
kasan-docs-slub-is-the-only-remaining-slab-implementation.patch
mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch
mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch
kvm-remove-hugetlbh-inclusion.patch
kvm-ppc-remove-hugetlbh-inclusion.patch

