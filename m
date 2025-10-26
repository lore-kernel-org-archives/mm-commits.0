Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165AF245012
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761451613; cv=none; b=cCpWLr5G6TaMQX7zMKUnOIrnu/8xMc2BQ/ePGJL6yFds4uu3Fr43CARm5G7fgSF/b48y97Rl/S6qtz5e1xRtSc/4JsLW06qWZ3/InYAMbyMrcZTbonDvnprPlbk4ks/JHh5413KcC8JDxcGH+MA4u8Y1gUxWqZlPg3CRr7DU5q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761451613; c=relaxed/simple;
	bh=fhuJMz2MkTcYSI9fwhLjqqaWLjo/pU8grRdI8eGxMhc=;
	h=Date:To:From:Subject:Message-Id; b=IkVzC9+Nd2vmBwyepIbiYFsoaVirWTDAMfrF8TWJvlCELEREhria/OdMSmsLVvwkddY394lafXtmuAgiwakCPsiC/0hOYhdmCFgBDb9Aoi4mD8jiGq4jVeNDQxLd9W5vsmgb61Dn268J+Gh8UhaZTzSSUmbqMv9jhF0HeqTcAs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YBAKiu/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YBAKiu/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9974BC4CEE7;
	Sun, 26 Oct 2025 04:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761451612;
	bh=fhuJMz2MkTcYSI9fwhLjqqaWLjo/pU8grRdI8eGxMhc=;
	h=Date:To:From:Subject:From;
	b=YBAKiu/7R9Fv+Rv4imQ6KivurphOXhm0x/OS4o8xpF4Dcj7MRQ5YNSyi9otRPQE/2
	 nifR3ewZLrugGI7gzMWPaHqLgMnCQrR5DCWeFilcKBay24mYmkTON198qM2iUelYUY
	 sR9oYSXun3U8vjAC3spRsz6JnrNBSENgKlAwe+xs=
Date: Sat, 25 Oct 2025 21:06:52 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,graf@amazon.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-unpreserve-memory-in-case-of-error.patch added to mm-nonmm-unstable branch
Message-Id: <20251026040652.9974BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock: Unpreserve memory in case of error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     memblock-unpreserve-memory-in-case-of-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-unpreserve-memory-in-case-of-error.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: memblock: Unpreserve memory in case of error
Date: Fri, 24 Oct 2025 12:10:02 -0400

If there is an error half way through KHO memory preservation, we should
rollback and unpreserve everything that is partially preserved.

Link: https://lkml.kernel.org/r/20251024161002.747372-9-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/mm/memblock.c~memblock-unpreserve-memory-in-case-of-error
+++ a/mm/memblock.c
@@ -2447,6 +2447,7 @@ int reserve_mem_release_by_name(const ch
 
 static int __init prepare_kho_fdt(void)
 {
+	bool fdt_folio_preserved = false;
 	int err = 0, i;
 	struct page *fdt_page;
 	void *fdt;
@@ -2462,12 +2463,14 @@ static int __init prepare_kho_fdt(void)
 
 	err |= fdt_begin_node(fdt, "");
 	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
-	for (i = 0; i < reserved_mem_count; i++) {
+	for (i = 0; !err && i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
 		struct page *page = phys_to_page(map->start);
 		unsigned int nr_pages = map->size >> PAGE_SHIFT;
 
-		err |= kho_preserve_pages(page, nr_pages);
+		err = kho_preserve_pages(page, nr_pages);
+		if (err)
+			break;
 		err |= fdt_begin_node(fdt, map->name);
 		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
 		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
@@ -2477,12 +2480,27 @@ static int __init prepare_kho_fdt(void)
 	err |= fdt_end_node(fdt);
 	err |= fdt_finish(fdt);
 
-	err |= kho_preserve_folio(page_folio(fdt_page));
-
 	if (!err)
+		err = kho_preserve_folio(page_folio(fdt_page));
+
+	if (!err) {
+		fdt_folio_preserved = true;
 		err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	}
 
 	if (err) {
+		int nr_reserve_map_preserved = i;
+
+		for (i = 0; i < nr_reserve_map_preserved; i++) {
+			struct reserve_mem_table *map = &reserved_mem_table[i];
+			struct page *page = phys_to_page(map->start);
+			unsigned int nr_pages = map->size >> PAGE_SHIFT;
+
+			kho_unpreserve_pages(page, nr_pages);
+		}
+		if (fdt_folio_preserved)
+			kho_unpreserve_folio(page_folio(fdt_page));
+
 		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
 		put_page(fdt_page);
 	}
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
kho-allow-to-drive-kho-from-within-kernel.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-and-page-ranges.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-kho-debugfs-directory-to-liveupdate.patch
memblock-unpreserve-memory-in-case-of-error.patch

