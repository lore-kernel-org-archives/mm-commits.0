Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25B92E6CD5
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078604; cv=none; b=h0+4FZEVQnjfZwKMSSd+umxBmUFEeAFhuJnjzZDWpXq0ESSunF5vrRsWQ/t/R00gXgA9MvfbQuYg03o14wgxAIg8+L+Msmr1NH7LkgVqoQjXc9yJKLLtRzdL7+6tr4K3MIMt7wJGgTAjIEpyja00Gy9JIRw/LA6bVe0EIl+Npk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078604; c=relaxed/simple;
	bh=GM6zeLS+C2/MagkAh78Wk7pz9bHG8w+Ek5P01jTP2Es=;
	h=Date:To:From:Subject:Message-Id; b=DkiDPo7zutnFoAVm1fupiwK93786p99SSgLW4Ow6Bo2txuTyhKzICiZ3v3/f/cDVCuVO5atGhv+TF0Pb4RVR8MZYWQkdABvW0xzFarPdKwvT6UR/bCKg4BAz4tyt13PuJmPP9vNG3GB0ctDS8rwtbRxWh9DKDlRk7wrHajn8djg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eLaqgzt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eLaqgzt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3801DC2BC9E;
	Mon,  9 Mar 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773078604;
	bh=GM6zeLS+C2/MagkAh78Wk7pz9bHG8w+Ek5P01jTP2Es=;
	h=Date:To:From:Subject:From;
	b=eLaqgzt2Ao0gaefAARmIyzJINMz1BWTRaBUpE1/gm65fRg3uQxhRe1G5c41IpDEs8
	 F9JvhytNErWSnYed4+GqDKpbyINPQN1rCcpXYyI/6zuMDwIkxUse8tvQI528mHJ05x
	 lLGTtg/Gcpe4h8iIcUDceh9famQj8iV8FqVLkK/I=
Date: Mon, 09 Mar 2026 10:50:03 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,dan.j.williams@intel.com,chleroy@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-ppc-remove-hugetlbh-inclusion.patch added to mm-new branch
Message-Id: <20260309175004.3801DC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KVM: PPC: remove hugetlb.h inclusion
has been added to the -mm mm-new branch.  Its filename is
     kvm-ppc-remove-hugetlbh-inclusion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-ppc-remove-hugetlbh-inclusion.patch

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
Subject: KVM: PPC: remove hugetlb.h inclusion
Date: Mon, 9 Mar 2026 16:19:01 +0100

hugetlb.h is no longer required now that we moved vma_kernel_pagesize() to
mm.h.

Link: https://lkml.kernel.org/r/20260309151901.123947-5-david@kernel.org
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

 arch/powerpc/kvm/book3s_hv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv.c~kvm-ppc-remove-hugetlbh-inclusion
+++ a/arch/powerpc/kvm/book3s_hv.c
@@ -36,7 +36,6 @@
 #include <linux/gfp.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
-#include <linux/hugetlb.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/module.h>
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

