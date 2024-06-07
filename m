Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38314502BE
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717799023; cv=none; b=c6VTVx6cPhOAN+axiuM6xdjOskI0jNQXM7McpFj8qsp47qw9lX9aJkuZ8SYUzxNwERIpsLFUveRaAZsTbYii0821/9p8St0j/u9E/CTkurulu8c1tmvCYUtMoZHdegqqFYDdEjMhTwZ770OB/t6fHxknm7n4Amp6n9lLzHQ52LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717799023; c=relaxed/simple;
	bh=Savf5sGC1dlBobno40ob98wsoWnZvXj+CDEwyhlFPjk=;
	h=Date:To:From:Subject:Message-Id; b=gk/W0vQK3RDEpS9kchtAnegH9mQ3OEie59o58f0mXYAEUPKTIj7wfKhwv4/FSirM1fqZDbiM2Z2mUVwmvNdMOcpXDdJfQPTTNE1IM50A+4wl1v2eeS36Wj29aMnO5MRH47Y4K4yuntc2RUlEIXzYW4tBhPIx3omNVsCMdo16sb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jtfz5Eub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jtfz5Eub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958C7C2BBFC;
	Fri,  7 Jun 2024 22:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717799022;
	bh=Savf5sGC1dlBobno40ob98wsoWnZvXj+CDEwyhlFPjk=;
	h=Date:To:From:Subject:From;
	b=jtfz5Eub63ZKWmYLaUWjVSPnIK090dCulDLsBGxCEQBTHWWPY+ZnQakjW3YIIBq3Z
	 XMaudvGIbpfaKSgksd1jK9lsT/IoFRJ7QFJX+nglZwcg4o6xLO83CS6Sa080vzmavT
	 sApIA4ajQNaGSVM4jvJPLX0KRYpyr3Mn8BH4tpxQ=
Date: Fri, 07 Jun 2024 15:23:42 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,sstabellini@kernel.org,rppt@kernel.org,osalvador@suse.de,oleksandr_tyshchenko@epam.com,mst@redhat.com,kys@microsoft.com,jgross@suse.com,jasowang@redhat.com,haiyangz@microsoft.com,glider@google.com,eperezma@redhat.com,elver@google.com,dvyukov@google.com,decui@microsoft.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-meminit_context-to-__free_pages_core-fix.patch added to mm-unstable branch
Message-Id: <20240607222342.958C7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-pass-meminit_context-to-__free_pages_core-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-meminit_context-to-__free_pages_core-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-meminit_context-to-__free_pages_core-fix.patch

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
Subject: mm-pass-meminit_context-to-__free_pages_core-fix
Date: Fri, 7 Jun 2024 20:40:52 +0200

add missed CONFIG_DEFERRED_STRUCT_PAGE_INIT

Link: https://lkml.kernel.org/r/b72e6efd-fb0a-459c-b1a0-88a98e5b19e2@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Marco Elver <elver@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-pass-meminit_context-to-__free_pages_core-fix
+++ a/mm/mm_init.c
@@ -1928,7 +1928,7 @@ static void __init deferred_free_range(u
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
 		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
 			set_pageblock_migratetype(page + i, MIGRATE_MOVABLE);
-		__free_pages_core(page, MAX_PAGE_ORDER);
+		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
 
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

