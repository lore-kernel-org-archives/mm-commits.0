Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5502627979A
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 03:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762226791; cv=none; b=pyWxy/ypFJKCfY2WmWY7yqvMJzepAqS60CcyeNEB+6t6UYuAXk8eu/YqP1lDSxVW4URWuoYQcraZS9W0jJz9c2Pe7JCButCT+ETy/k4HF92JAdlR3KsBUqJKViZNNXaruKc99Fdzb/nEXK4fCKfghrhXthOSySAYLGbhzPKVjS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762226791; c=relaxed/simple;
	bh=UQXN+BvwreaxzYRWgGHsDaHHwf8Y+1QZUDBtJKpOHm4=;
	h=Date:To:From:Subject:Message-Id; b=jwCI4MKjnPATaWjQmjD/3Q0/nE/PEsejLw+grmMv65ru2rTitsrO5Sj25nQN1NOWbS4S35DwStUMTzK+raxTDpw+CLeBQWB2IyK5dCuMctVxh/+ZaNLPxFCkjk9Bfr9g6l3SVRK/KnP3U1dyFydWrmqsk18lszn+N3yAmMpRGFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VHS68wL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VHS68wL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124ACC113D0;
	Tue,  4 Nov 2025 03:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762226791;
	bh=UQXN+BvwreaxzYRWgGHsDaHHwf8Y+1QZUDBtJKpOHm4=;
	h=Date:To:From:Subject:From;
	b=VHS68wL7dg1RKe+1/lf8RiMfDrs3RoFnj916bIttKir/E7HRXmVWGEyvcaWEFkUAB
	 7RrOg6T/WNKRWelURDUt7QtvjRTNoaW/MsZR4+lLdKXJ+k93MVta4k07FemG5UgC8r
	 /f2C0hpqUYcZ2a7QhNeSYd341S6HMCJjZfDOH4+s=
Date: Mon, 03 Nov 2025 19:26:30 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-unpreserve-memory-in-case-of-error.patch added to mm-nonmm-unstable branch
Message-Id: <20251104032631.124ACC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock: unpreserve memory in case of error
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
Subject: memblock: unpreserve memory in case of error
Date: Sat, 1 Nov 2025 10:23:20 -0400

If there is an error half way through KHO memory preservation, we should
rollback and unpreserve everything that is partially preserved.

Link: https://lkml.kernel.org/r/20251101142325.1326536-5-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   75 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 16 deletions(-)

--- a/mm/memblock.c~memblock-unpreserve-memory-in-case-of-error
+++ a/mm/memblock.c
@@ -2445,29 +2445,60 @@ int reserve_mem_release_by_name(const ch
 #define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
 #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
 
+static int __init reserved_mem_preserve(void)
+{
+	unsigned int nr_preserved = 0;
+	int err;
+
+	for (unsigned int i = 0; i < reserved_mem_count; i++, nr_preserved++) {
+		struct reserve_mem_table *map = &reserved_mem_table[i];
+		struct page *page = phys_to_page(map->start);
+		unsigned int nr_pages = map->size >> PAGE_SHIFT;
+
+		err = kho_preserve_pages(page, nr_pages);
+		if (err)
+			goto err_unpreserve;
+	}
+
+	return 0;
+
+err_unpreserve:
+	for (unsigned int i = 0; i < nr_preserved; i++) {
+		struct reserve_mem_table *map = &reserved_mem_table[i];
+		struct page *page = phys_to_page(map->start);
+		unsigned int nr_pages = map->size >> PAGE_SHIFT;
+
+		kho_unpreserve_pages(page, nr_pages);
+	}
+
+	return err;
+}
+
 static int __init prepare_kho_fdt(void)
 {
-	int err = 0, i;
 	struct page *fdt_page;
 	void *fdt;
+	int err;
 
 	fdt_page = alloc_page(GFP_KERNEL);
-	if (!fdt_page)
-		return -ENOMEM;
+	if (!fdt_page) {
+		err = -ENOMEM;
+		goto err_no_fdt_page;
+	}
 
 	fdt = page_to_virt(fdt_page);
+	err = kho_preserve_pages(fdt_page, 1);
+	if (err)
+		goto err_free_fdt;
 
 	err |= fdt_create(fdt, PAGE_SIZE);
 	err |= fdt_finish_reservemap(fdt);
-
 	err |= fdt_begin_node(fdt, "");
 	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
-	for (i = 0; i < reserved_mem_count; i++) {
+
+	for (unsigned int i = 0; !err && i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
-		struct page *page = phys_to_page(map->start);
-		unsigned int nr_pages = map->size >> PAGE_SHIFT;
 
-		err |= kho_preserve_pages(page, nr_pages);
 		err |= fdt_begin_node(fdt, map->name);
 		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
 		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
@@ -2477,15 +2508,27 @@ static int __init prepare_kho_fdt(void)
 	err |= fdt_end_node(fdt);
 	err |= fdt_finish(fdt);
 
-	err |= kho_preserve_folio(page_folio(fdt_page));
-
-	if (!err)
-		err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	if (err)
+		goto err_unpreserve_fdt;
 
-	if (err) {
-		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
-		put_page(fdt_page);
-	}
+	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	if (err)
+		goto err_unpreserve_fdt;
+
+	err = reserved_mem_preserve();
+	if (err)
+		goto err_remove_subtree;
+
+	return 0;
+
+err_remove_subtree:
+	kho_remove_subtree(fdt);
+err_unpreserve_fdt:
+	kho_unpreserve_pages(fdt_page, 1);
+err_free_fdt:
+	put_page(fdt_page);
+err_no_fdt_page:
+	pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
 
 	return err;
 }
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
maintainers-update-kho-maintainers.patch

