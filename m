Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D3C6AAD
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627557; cv=none; b=f5Bt7tpOCkfxpOKjjPcno4lhSPHrFLdrkZsRLYkFZWbUWcLaJXbx1skS2/EtjIBLY8TxlmlxnZGvViKvohs2UqG2928Iek9KFUOQnlmwE+/wxtLGzC0twajT8JQRxMFtKKOW+aEXnJLTGqrsAEXG0/WYpo81SYMId119gUPjrT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627557; c=relaxed/simple;
	bh=IBSQgmsf+WkrXg9U3dsJuJqGWBTEjdzgUGbDUoXds84=;
	h=Date:To:From:Subject:Message-Id; b=W4S+DJaZZj2M5xdNe3jVGi3GySbneStlltFkWQ92ddPXdqIQszzwHlBVtzsK7Gm3UM3E2aV7+Tuk97asidFVKIYzk9C6HFnoB43nI8Vy9sVbxkD2EbKePKGJO5v5Io5HJFb2L3Nelf2I3afeKllhYELfm90qLgF0fyC19UCHe2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYBZMhia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYBZMhia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D879C116B1;
	Sat, 29 Jun 2024 02:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627556;
	bh=IBSQgmsf+WkrXg9U3dsJuJqGWBTEjdzgUGbDUoXds84=;
	h=Date:To:From:Subject:From;
	b=dYBZMhiaOzfInpGPhvCBi/L9EzzT2vd6fUC00R2ac9hTrxqDoc+HK1OP29UOMIxgD
	 WgL5cI56f2MbHVlSPwRqV0+MeUj3LvqaWz7+M0RLnU0WN4SZ5MUhr4MmJQ6m8jpZxZ
	 eMhpU4Hayhb6mGRz94Y5/FaQV0T8VgV8Oabe4ntA=
Date: Fri, 28 Jun 2024 19:19:15 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,sstabellini@kernel.org,rppt@kernel.org,osalvador@suse.de,oleksandr_tyshchenko@epam.com,mst@redhat.com,kys@microsoft.com,jgross@suse.com,jasowang@redhat.com,haiyangz@microsoft.com,glider@google.com,eperezma@redhat.com,elver@google.com,dvyukov@google.com,decui@microsoft.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-pass-meminit_context-to-__free_pages_core-fix.patch removed from -mm tree
Message-Id: <20240629021916.7D879C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-pass-meminit_context-to-__free_pages_core-fix
has been removed from the -mm tree.  Its filename was
     mm-pass-meminit_context-to-__free_pages_core-fix.patch

This patch was dropped because it was folded into mm-pass-meminit_context-to-__free_pages_core.patch

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
@@ -1931,7 +1931,7 @@ static void __init deferred_free_pages(u
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
 		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
 			set_pageblock_migratetype(page + i, MIGRATE_MOVABLE);
-		__free_pages_core(page, MAX_PAGE_ORDER);
+		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix.patch

