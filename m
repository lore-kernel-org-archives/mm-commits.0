Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C721552ED
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717800525; cv=none; b=EbPU+IBmWlKcDYWLCiGd9RGqZn5QuHBaGVFMkiqq9rMen91q8gP9Lrqm0x0dVuA+Eiv9GUdkUwy4R2pQMPe4nqlC3jQBJ9htVkHpaimT4TIy7kE3A2SOb1dqX5C1n3Q8bdM9pJeVgQK3AK77qixss/8Lkjx7M/Nhf6KaE+YzSzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717800525; c=relaxed/simple;
	bh=PWX40MEGdK9v4rWzv5u/NUmCcnBKoSvI/kQDNnnz3uw=;
	h=Date:To:From:Subject:Message-Id; b=qAqbfMmT7vTzzbi4YP02NUluDciT8eX2SAV/zUX2QRIGmYwYJvla9BeqOTUwnPharIDVPb1dEvgfNz5E+YcbHJqWo33dFm3xnOYAA74cYtUDBTTGuXeYRTkVHK4ZUIe1RNARXhdNYCok+jXNVoEQduhfK+9jS2uG8j2JhVtjnZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ip+TkUk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ip+TkUk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504A8C2BBFC;
	Fri,  7 Jun 2024 22:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717800525;
	bh=PWX40MEGdK9v4rWzv5u/NUmCcnBKoSvI/kQDNnnz3uw=;
	h=Date:To:From:Subject:From;
	b=Ip+TkUk4nNDLSpg396bbrMtDCNh5fNms3GX0wT+/g5yRKMTgo2Z4ljUjuYvZ+cwND
	 P2dasnz7p4PYOo3VSDVXmvP76IrFVBWZJtCm60lClxI0yU+pdQmMbC/eDOSRpS5SCJ
	 O6ntIA7UKPVSLzmG+vxwMOvJX68wTkZkrtEBpjKU=
Date: Fri, 07 Jun 2024 15:48:44 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-make-nr_free_highpages-return-unsigned-long.patch added to mm-unstable branch
Message-Id: <20240607224845.504A8C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/highmem: make nr_free_highpages() return "unsigned long"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-highmem-make-nr_free_highpages-return-unsigned-long.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-highmem-make-nr_free_highpages-return-unsigned-long.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/highmem: make nr_free_highpages() return "unsigned long"
Date: Fri, 7 Jun 2024 10:37:11 +0200

It looks rather weird that totalhigh_pages() returns an "unsigned long"
but nr_free_highpages() returns an "unsigned int".

Let's return an "unsigned long" from nr_free_highpages() to be consistent.

While at it, use a plain "0" instead of a "0UL" in the !CONFIG_HIGHMEM
totalhigh_pages() implementation, to make these look alike as well.

Link: https://lkml.kernel.org/r/20240607083711.62833-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    8 ++++----
 include/linux/highmem.h          |    2 +-
 mm/highmem.c                     |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/highmem.h~mm-highmem-make-nr_free_highpages-return-unsigned-long
+++ a/include/linux/highmem.h
@@ -179,7 +179,7 @@ static inline void *kmap_local_folio(str
 static inline void *kmap_atomic(struct page *page);
 
 /* Highmem related interfaces for management code */
-static inline unsigned int nr_free_highpages(void);
+static inline unsigned long nr_free_highpages(void);
 static inline unsigned long totalhigh_pages(void);
 
 #ifndef ARCH_HAS_FLUSH_ANON_PAGE
--- a/include/linux/highmem-internal.h~mm-highmem-make-nr_free_highpages-return-unsigned-long
+++ a/include/linux/highmem-internal.h
@@ -131,10 +131,10 @@ static inline void __kunmap_atomic(const
 		preempt_enable();
 }
 
-unsigned int __nr_free_highpages(void);
+unsigned long __nr_free_highpages(void);
 unsigned long __totalhigh_pages(void);
 
-static inline unsigned int nr_free_highpages(void)
+static inline unsigned long nr_free_highpages(void)
 {
 	return __nr_free_highpages();
 }
@@ -234,8 +234,8 @@ static inline void __kunmap_atomic(const
 		preempt_enable();
 }
 
-static inline unsigned int nr_free_highpages(void) { return 0; }
-static inline unsigned long totalhigh_pages(void) { return 0UL; }
+static inline unsigned long nr_free_highpages(void) { return 0; }
+static inline unsigned long totalhigh_pages(void) { return 0; }
 
 static inline bool is_kmap_addr(const void *x)
 {
--- a/mm/highmem.c~mm-highmem-make-nr_free_highpages-return-unsigned-long
+++ a/mm/highmem.c
@@ -111,10 +111,10 @@ static inline wait_queue_head_t *get_pkm
 }
 #endif
 
-unsigned int __nr_free_highpages(void)
+unsigned long __nr_free_highpages(void)
 {
+	unsigned long pages = 0;
 	struct zone *zone;
-	unsigned int pages = 0;
 
 	for_each_populated_zone(zone) {
 		if (is_highmem(zone))
_

Patches currently in -mm which might be from david@redhat.com are

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch
mm-highmem-make-nr_free_highpages-return-unsigned-long.patch

