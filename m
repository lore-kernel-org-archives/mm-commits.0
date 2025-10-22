Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2337B169AD2
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 19:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761159732; cv=none; b=G/IRfk1MF2EXZlPtg0SubO4jPB/DxjCBZySeQXgd+ixUPEgqF3/3My6INvPwK/EMeW2AG6wmW3Kjr9aJKLlZvmcbJ5kNtnjOwzvIIbMp5GDH2kCtdIxPexXrtzT2f7HDEtpGO6IaxoqU2eS4fYTXnrKeqKHQv+mYkgMpFJO1ZeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761159732; c=relaxed/simple;
	bh=VToR2lH/TMLbb06e+8rZBhhw/TEWwBX5dG91Wa9D65Q=;
	h=Date:To:From:Subject:Message-Id; b=cgaP6RwkXbdvcQfkbsNeSV7hKXXDPqAW5wsh0xgqdq6VfI8oy4+d13W3YK+FGmGLph4pEGqZCb6SH2dkT9u7Wcx/Mf4ELMgUz4TMuV9OqwXeHGbmgMhwvuVZTV/IBQQ6JMAMo4cWXKYi56MYr8ZqYxov48v5ORHrV8wVT8tUETk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ERcQtMXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ERcQtMXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848BEC4CEE7;
	Wed, 22 Oct 2025 19:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761159730;
	bh=VToR2lH/TMLbb06e+8rZBhhw/TEWwBX5dG91Wa9D65Q=;
	h=Date:To:From:Subject:From;
	b=ERcQtMXIIJVAn9uAYYbgm9ZscuPtTfHPpwYp3EO5jO7Le9/phf69T4U2OLnEQ2ktV
	 8yAuK/kvABPmK5YplVCS8homcbRrgBK/K+Tam1CnGq3BDJbB9OvcXKY9CDLZB2i2kv
	 prub1ij/gczbYqWfOpTuij3wLk61Sep/Gb3WaV5g=
Date: Wed, 22 Oct 2025 12:02:10 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,dave.hansen@intel.com,bp@alien8.de,apopple@nvidia.com,baolu.lu@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-use-pagetable_free.patch added to mm-new branch
Message-Id: <20251022190210.848BEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: use pagetable_free()
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-use-pagetable_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-use-pagetable_free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lu Baolu <baolu.lu@linux.intel.com>
Subject: x86/mm: use pagetable_free()
Date: Wed, 22 Oct 2025 16:26:32 +0800

The kernel's memory management subsystem provides a dedicated interface,
pagetable_free(), for freeing page table pages.  Updates two call sites to
use pagetable_free() instead of the lower-level __free_page() or
free_pages().  This improves code consistency and clarity, and ensures the
correct freeing mechanism is used.

Link: https://lkml.kernel.org/r/20251022082635.2462433-7-baolu.lu@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c        |    2 +-
 arch/x86/mm/pat/set_memory.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-use-pagetable_free
+++ a/arch/x86/mm/init_64.c
@@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(str
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		__free_pages(page, order);
+		pagetable_free(page_ptdesc(page));
 	}
 }
 
--- a/arch/x86/mm/pat/set_memory.c~x86-mm-use-pagetable_free
+++ a/arch/x86/mm/pat/set_memory.c
@@ -429,7 +429,7 @@ static void cpa_collapse_large_pages(str
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		__free_page(ptdesc_page(ptdesc));
+		pagetable_free(ptdesc);
 	}
 }
 
_

Patches currently in -mm which might be from baolu.lu@linux.intel.com are

iommu-disable-sva-when-config_x86-is-set.patch
x86-mm-use-pagetable_free.patch
iommu-sva-invalidate-stale-iotlb-entries-for-kernel-address-space.patch

