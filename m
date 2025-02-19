Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CB138B
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 00:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923475; cv=none; b=hZDB0+XSBEfOauvneuw5arVu/FIggM4jJtS9/em0rolhV8uF1NhowmH1p1/E7OzuAB7JksPfF7aYLygWj62lh+J1y+iIAntAXXnJxfsPzR4JDAAJWC3HogNNbrTYnpLMVz3fsV3wAkfEDv5fqBqKf1MiOEvNLTKj2SdaKwb38aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923475; c=relaxed/simple;
	bh=GKy/YPRJ8zNnWBZVsI4cWRZzNIBkJTKWZbt0n93x0HY=;
	h=Date:To:From:Subject:Message-Id; b=bhL0VYuNXPoHz2QJdMpQ5bLKW97Sw9shutDwsesK1kk/30ILPufYAd2Z+JizpDzVrFOdnbYm0LKmFsCuHm7QtxYejh6S+9EaJ+GIOO+hPipZMLu5vYdQGdE3eld7mzFnIoKCSoyy9ojZ0fIXtE21PpoXfQ6RgvkFsudXSTeLF8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IepXtiOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IepXtiOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9109C4CEE2;
	Wed, 19 Feb 2025 00:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923474;
	bh=GKy/YPRJ8zNnWBZVsI4cWRZzNIBkJTKWZbt0n93x0HY=;
	h=Date:To:From:Subject:From;
	b=IepXtiOCbtyyo2IdX/4m0ykTUjST29IDzmx3M8CBop1fDsxOp5HvrIQslQMhIKe9h
	 lZ+ZHKRy5zkHcAlXZtFelxZSXPJA41WrkBNv2TMrXrrVpD2kxCJvMmMXEP+eOmAnxr
	 HN2G2KxxoJF4iz1jqjRhCxmZsLvk8H7NCF0lnKQc=
Date: Tue, 18 Feb 2025 16:04:34 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch added to mm-unstable branch
Message-Id: <20250219000434.D9109C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc
Date: Tue, 18 Feb 2025 18:16:43 +0000

Architectures that want pre-HVO of hugetlb vmemmap pages will need to call
hugetlb_bootmem_alloc from an earlier spot in boot (before sparse_init). 
To facilitate some architectures doing this, protect hugetlb_bootmem_alloc
against multiple calls.

Also provide a helper function to check if it's been called, so that the
early HVO code, to be added later, can see if there is anything to do.

Link: https://lkml.kernel.org/r/20250218181656.207178-16-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++++++
 mm/hugetlb.c            |   12 ++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc
+++ a/include/linux/hugetlb.h
@@ -175,6 +175,7 @@ extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_alloc(void);
+bool hugetlb_bootmem_allocated(void);
 
 /* arch callbacks */
 
@@ -1256,6 +1257,11 @@ static inline bool hugetlbfs_pagecache_p
 static inline void hugetlb_bootmem_alloc(void)
 {
 }
+
+static inline bool hugetlb_bootmem_allocated(void)
+{
+	return false;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/hugetlb.c~mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc
+++ a/mm/hugetlb.c
@@ -4906,16 +4906,28 @@ static int __init default_hugepagesz_set
 }
 hugetlb_early_param("default_hugepagesz", default_hugepagesz_setup);
 
+static bool __hugetlb_bootmem_allocated __initdata;
+
+bool __init hugetlb_bootmem_allocated(void)
+{
+	return __hugetlb_bootmem_allocated;
+}
+
 void __init hugetlb_bootmem_alloc(void)
 {
 	struct hstate *h;
 
+	if (__hugetlb_bootmem_allocated)
+		return;
+
 	hugetlb_parse_params();
 
 	for_each_hstate(h) {
 		if (hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
+
+	__hugetlb_bootmem_allocated = true;
 }
 
 static unsigned int allowed_mems_nr(struct hstate *h)
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

