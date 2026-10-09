Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E49421251
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525578; cv=none; b=rNkb7OKDDwpvNZxz3/DHxs7BNX4OUSsHDTFoFL/KVEpZI6zb5mCQu4pLZVgz5dvpXKCy/NiyvlnYIb8a0U+MGXnqIuig3P7FlcVbstVi8SbMueF85VfDKOMndR3HCT0qFZ/n1h8xTtJD1IeLoChSno8IvSQzegbErNcEZIq6hPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525578; c=relaxed/simple;
	bh=Q3PpHSX9RhYiTXRFCWTUe+WV+2BPs8WHTz1ifRV5flo=;
	h=Date:To:From:Subject:Message-Id; b=j8fjV4auIbrtoFm/g5kMzkGWzxoecFE+cIMiEc3PJHCxVFqKyRIJ8d32dhNaS5QiI4RcutaW7GXvBMzIt3UWUNNhogEuqhkgJEil664czE6VP9OlEx5JKAHP5ZalcDIQjDYTihNV/MObbnju+GtSyNBoaPBeshU8hEGs7BjB7VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oGXMljOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oGXMljOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B0B1F00898;
	Fri,  9 Oct 2026 05:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525574;
	bh=cIetXi+BlaXaVjlDi7MzvO79b4XCr9GUduxPgCz9uPs=;
	h=Date:To:From:Subject;
	b=oGXMljOwenT4GEfHM1Wg0kr74U1ZSjhtcfjhLDPj17ni9RQwcFnxFthDmfA8CtgGc
	 DAbYLn2PeRTnRz+DKAIzwHQEfYtSiz5r83h1gcQNVtNFsvEqCmoqPZZwVymzbOl0T2
	 D+dshUeKNO3YFk1Mt8hZwcZH8wKG7SnE7k+tGSqk=
Date: Thu, 08 Oct 2026 22:59:33 -0700
To: mm-commits@vger.kernel.org,sstabellini@kernel.org,oleksandr_tyshchenko@epam.com,jgross@suse.com,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch removed from -mm tree
Message-Id: <20261009055934.14B0B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xen/grant-table: stop setting PG_private on pages for grant mapping
has been removed from the -mm tree.  Its filename was
     xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: xen/grant-table: stop setting PG_private on pages for grant mapping
Date: Sun, 20 Sep 2026 22:27:59 -0400

gnttab_alloc_pages() stores xen_page_foreign in page->private. On 32-bit, a
pointer to an allocated xen_page_foreign is stored; on 64-bit,
xen_page_forCcgn is stored inline. Checking page->private != NULL is enough
to tell whether a xen_page_foreign needs to be freed on 32-bit and
page->private is zeroed unconditionally on 64-bit.

It prepares for a future commit that remove PG_private.

No functional change intended.

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-3-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
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


