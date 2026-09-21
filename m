Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13F73264EF
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961494; cv=none; b=TtFBKFpoXm7hpS3C54iIGK+UM7IztuG3sJ4paguIyKtvDuVv5RvGHSHN4c0KXfeWr9Ah4RV/nV4BLjhYSiPSHy2LHbyhEryHvsh9WXILCvkZmuVSXIK/nYbmRGFiIiJ3/mnasAxx4jLRJP+giHkVe8+m/+GBeHMSJzg8r+/kr2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961494; c=relaxed/simple;
	bh=RMWasU0nW4nU0HOjctYtb8/Q73ifRJYTzO5nIrf6bh8=;
	h=Date:To:From:Subject:Message-Id; b=Pr/D0+3Jjehy1k7GZsGc5TlPa5mmRYD8WLBjc01TVjjKGgReqGeAnEk0Jc30V12NKwrDgGrXiY76hb20QgkRwvQ6Np/HVqpId4T6OZomaqQHqFkSl5dCJG59QjlGuFn1fJSLv5e2x2/HdIArxhAxIjAii9DhkG9odIBXpreuc6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bO/CPTbG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bO/CPTbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCCA1F00898;
	Mon, 21 Sep 2026 03:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961492;
	bh=2t4Dug0HA9nJ96FBVbw1DIQoc8e3J3us2VTJNGVFMYc=;
	h=Date:To:From:Subject;
	b=bO/CPTbGo80ZxQNHFdP/fsD89wPatFdFfsPxjbvXFu90Jf4CrvViNRlbRHOTbC12n
	 2V3xcJkybCi52c1441RztItNYfCkqgTJw/+8AO7h0GrhwHTd+UgjBXXhXdTigsULkT
	 YeVBq4EKnvzfJTGyb39Y8EmMnDRT2mF30NgfI42M=
Date: Sun, 20 Sep 2026 20:31:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch removed from -mm tree
Message-Id: <20260921033132.4BCCA1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xen/grant-table: stop setting PG_private on pages for grant mapping
has been removed from the -mm tree.  Its filename was
     xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: xen/grant-table: stop setting PG_private on pages for grant mapping
Date: Sun, 13 Sep 2026 22:24:01 -0400

gnttab_alloc_pages() stores xen_page_foreign in page->private.  On 32-bit,
a pointer to an allocated xen_page_foreign is stored; on 64-bit,
xen_page_foreign is stored inline.  Checking page->private != NULL is
enough to tell whether a xen_page_foreign needs to be freed on 32-bit and
page->private is zeroed unconditionally on 64-bit.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-3-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
---

 drivers/xen/grant-table.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/xen/grant-table.c~xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping
+++ a/drivers/xen/grant-table.c
@@ -863,10 +863,10 @@ EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_
 
 int gnttab_pages_set_private(int nr_pages, struct page **pages)
 {
+#if BITS_PER_LONG < 64
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-#if BITS_PER_LONG < 64
 		struct xen_page_foreign *foreign;
 
 		foreign = kzalloc_obj(*foreign);
@@ -874,9 +874,9 @@ int gnttab_pages_set_private(int nr_page
 			return -ENOMEM;
 
 		set_page_private(pages[i], (unsigned long)foreign);
-#endif
-		SetPagePrivate(pages[i]);
 	}
+#endif
+	/* Data is stored in page->private on 64-bit */
 
 	return 0;
 }
@@ -1031,12 +1031,11 @@ void gnttab_pages_clear_private(int nr_p
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-		if (PagePrivate(pages[i])) {
 #if BITS_PER_LONG < 64
+		if (page_private(pages[i]))
 			kfree((void *)page_private(pages[i]));
 #endif
-			ClearPagePrivate(pages[i]);
-		}
+		set_page_private(pages[i], 0);
 	}
 }
 EXPORT_SYMBOL_GPL(gnttab_pages_clear_private);
_

Patches currently in -mm which might be from ziy@nvidia.com are

fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

