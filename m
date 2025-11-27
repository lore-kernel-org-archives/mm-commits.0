Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3D9311589
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282358; cv=none; b=AJuCfaUO+oW1FMPX5P880d17MaMPy7CeatwkIWKERLaiQykXqsQdcveKo9yDOtPUhV85ECUx2CrVglRI75XcGJQkE/auISAoJtDo+7OHyElpJvSaEB16pxIeOBHRXVaW0dXviHQLU+tfii7yymOx5OoTaozZkPlgHznXZbJ0XvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282358; c=relaxed/simple;
	bh=hiFJbq8Vsy+nnHAVr/8dBfhJWh4BdfS/VGh+HlUkqHc=;
	h=Date:To:From:Subject:Message-Id; b=D5TesmbLzO6RRw5xJK3TQWfPey0NyKBdTF1XgZyEN9v70L/ENTSR/b8+zG9ZYIOsBewNkACuKdMuer/tQqvJQRda0hQz4S6svj7SQze9wUKJxRVcKet5nDULZoxcm5jMKE+vL0Gv8ZG9UaarSFshfZS25ojsWTISnD3catuCg0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H83k58hf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H83k58hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BBFC4CEF8;
	Thu, 27 Nov 2025 22:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282358;
	bh=hiFJbq8Vsy+nnHAVr/8dBfhJWh4BdfS/VGh+HlUkqHc=;
	h=Date:To:From:Subject:From;
	b=H83k58hfGNOVxc3WDAtk/K+hsTNbpQDQRN8AQ++4t08JmlcEbfg4txsGrHYWefxUK
	 uqHtLWdXoDCm9POGRu5jGC3ZFMyXGAFXw579KOXX0yn7D1sS9eqQ15doqYdtHD9Sk2
	 XMf7zMNQuVNxRff/zl6IxnCgHS+3+rmuFbqPTlMk=
Date: Thu, 27 Nov 2025 14:25:58 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] memblock-unpreserve-memory-in-case-of-error.patch removed from -mm tree
Message-Id: <20251127222558.93BBFC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memblock: unpreserve memory in case of error
has been removed from the -mm tree.  Its filename was
     memblock-unpreserve-memory-in-case-of-error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: memblock: unpreserve memory in case of error
Date: Sat, 1 Nov 2025 10:23:20 -0400

If there is an error half way through KHO memory preservation, we should
rollback and unpreserve everything that is partially preserved.

[akpm@linux-foundation.org: s/err_no_fdt_page/err_report/ in prepare_kho_fdt(), per Mike]
Link: https://lkml.kernel.org/r/20251101142325.1326536-5-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
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
+		goto err_report;
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
+err_report:
+	pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
 
 	return err;
 }
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

