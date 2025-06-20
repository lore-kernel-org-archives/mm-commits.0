Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B39E322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391349; cv=none; b=SLof1DKUzeIhca/IRnEuBivjohTv1x36SAqgNiGto5j9wDbFdfmtoxGS9cZLGrLcm9pZw13R7mQunC7Mch9Pem/Ac4Cz5ZZBgIu2r87SVqBQOwGVbnzAvJhkuTjfjmWNevKcM29kpQX5S1d5TgjPGOEaNiNnTIKsGGtBhjolopQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391349; c=relaxed/simple;
	bh=5I5DPp6VuzKCTNOUejxli8B/gC2tZmAZojasUHbKDa0=;
	h=Date:To:From:Subject:Message-Id; b=Rjy83M/zWfDXHHYzGMJ0CiE2jwhzgwN+KLJ6XUxZhDyiJ0ytvV3l+zIuOajLv4ZSC2iaVd8te4bLT0Z0clMyScMtwxoXV9xhdC3hhGNQOyJMbd2ZTw8E4of3BFuRguFNCe+ouBrEEbThCgGTCjfCsu1PeoYoUYTTYE19mESp5L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wLS8GhgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wLS8GhgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EECC4CEE3;
	Fri, 20 Jun 2025 03:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391348;
	bh=5I5DPp6VuzKCTNOUejxli8B/gC2tZmAZojasUHbKDa0=;
	h=Date:To:From:Subject:From;
	b=wLS8GhgTGxEQfRKbat5t4iNjb6tWxuSsddIf0kGpC2SMTXZVKiyvy6x9oR/l9kk64
	 jhSSV9W8sdG9VzYgShawHbCiVijYq2FpmGveul7t0urW50ueTU2R2rsanZcz/vr/fb
	 g1J4cP5yDlSCcPwVPdcviUxC1CAUsT/Oy0OuXbJw=
Date: Thu, 19 Jun 2025 20:49:08 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ptyadav@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kho-initialize-tail-pages-for-higher-order-folios-properly.patch removed from -mm tree
Message-Id: <20250620034908.D3EECC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: initialize tail pages for higher order folios properly
has been removed from the -mm tree.  Its filename was
     kho-initialize-tail-pages-for-higher-order-folios-properly.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <ptyadav@amazon.de>
Subject: kho: initialize tail pages for higher order folios properly
Date: Thu, 5 Jun 2025 19:11:41 +0200

Currently, when restoring higher order folios, kho_restore_folio() only
calls prep_compound_page() on all the pages.  That is not enough to
properly initialize the folios.  The managed page count does not get
updated, the reserved flag does not get dropped, and page count does not
get initialized properly.

Restoring a higher order folio with it results in the following BUG with
CONFIG_DEBUG_VM when attempting to free the folio:

    BUG: Bad page state in process test  pfn:104e2b
    page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffffffffffffffff pfn:0x104e2b
    flags: 0x2fffff80000000(node=0|zone=2|lastcpupid=0x1fffff)
    raw: 002fffff80000000 0000000000000000 00000000ffffffff 0000000000000000
    raw: ffffffffffffffff 0000000000000000 00000001ffffffff 0000000000000000
    page dumped because: nonzero _refcount
    [...]
    Call Trace:
    <TASK>
    dump_stack_lvl+0x4b/0x70
    bad_page.cold+0x97/0xb2
    __free_frozen_pages+0x616/0x850
    [...]

Combine the path for 0-order and higher order folios, initialize the tail
pages with a count of zero, and call adjust_managed_page_count() to
account for all the pages instead of just missing them.

In addition, since all the KHO-preserved pages get marked with
MEMBLOCK_RSRV_NOINIT by deserialize_bitmap(), the reserved flag is not
actually set (as can also be seen from the flags of the dumped page in the
logs above).  So drop the ClearPageReserved() calls.

[ptyadav@amazon.de: declare i in the loop instead of at the top]
  Link: https://lkml.kernel.org/r/20250613125916.39272-1-pratyush@kernel.org
Link: https://lkml.kernel.org/r/20250605171143.76963-1-pratyush@kernel.org
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/kernel/kexec_handover.c~kho-initialize-tail-pages-for-higher-order-folios-properly
+++ a/kernel/kexec_handover.c
@@ -164,11 +164,21 @@ static int __kho_preserve_order(struct k
 }
 
 /* almost as free_reserved_page(), just don't free the page */
-static void kho_restore_page(struct page *page)
+static void kho_restore_page(struct page *page, unsigned int order)
 {
-	ClearPageReserved(page);
-	init_page_count(page);
-	adjust_managed_page_count(page, 1);
+	unsigned int nr_pages = (1 << order);
+
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
+
+	/* For higher order folios, tail pages get a page count of zero. */
+	for (unsigned int i = 1; i < nr_pages; i++)
+		set_page_count(page + i, 0);
+
+	if (order > 0)
+		prep_compound_page(page, order);
+
+	adjust_managed_page_count(page, nr_pages);
 }
 
 /**
@@ -186,15 +196,10 @@ struct folio *kho_restore_folio(phys_add
 		return NULL;
 
 	order = page->private;
-	if (order) {
-		if (order > MAX_PAGE_ORDER)
-			return NULL;
-
-		prep_compound_page(page, order);
-	} else {
-		kho_restore_page(page);
-	}
+	if (order > MAX_PAGE_ORDER)
+		return NULL;
 
+	kho_restore_page(page, order);
 	return page_folio(page);
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
_

Patches currently in -mm which might be from ptyadav@amazon.de are


