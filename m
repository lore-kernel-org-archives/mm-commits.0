Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFFC311589
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282362; cv=none; b=ISL3S4zK1XMP/2fM98dv+k6qc0CDeznW0HTE9c99Jk+ilNyxSeORDPC9c+5LV1XLItG75/klSkzfOgRxwHLNgYG+Rb1yQJfNOyC13+cO/+sG0Uz+dl7ZpjrbySwZLEkUohJCBIFXVmQ24z3dpijgoxsqHpXiMGu5/aqEdNs4PQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282362; c=relaxed/simple;
	bh=EbkByn/rdvrtZKZUYMM9Abmzij3w0Qk3/8PkZRwAuZg=;
	h=Date:To:From:Subject:Message-Id; b=S/5CLHJxdryhS0hFruslE+5qQX7fNkY9ZuR+rc9UWeumJ01bH/PzqzgBEZW0xO6iluxn3kvhzV7iMr1Ee5h6gdGlunzc9ayZOryMVlBEnh/dG0sS80dUjDWF7smJRmDv4ascZ0wJcBz5gGMKraW1UT5cNFuZuHm7V37zy+S9DlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VsYIj0Ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VsYIj0Ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F351DC4CEF8;
	Thu, 27 Nov 2025 22:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282362;
	bh=EbkByn/rdvrtZKZUYMM9Abmzij3w0Qk3/8PkZRwAuZg=;
	h=Date:To:From:Subject:From;
	b=VsYIj0IbzgwLOJWhHdFeQ+Xd3i1u/UIo+E1zey1BACBz1E3VBe3O7iNc9BAce0jMm
	 nzx5oxu6w8CVINAXq8YgOTRJgzTXbWytmyp2utd2HaKX/5DppCjVKe7padp8InxIEn
	 n+wlMnYOZqGJkchDe1uOHvImovoV7T/B4/0vjGkg=
Date: Thu, 27 Nov 2025 14:26:01 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] test_kho-unpreserve-memory-in-case-of-error.patch removed from -mm tree
Message-Id: <20251127222601.F351DC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_kho: unpreserve memory in case of error
has been removed from the -mm tree.  Its filename was
     test_kho-unpreserve-memory-in-case-of-error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: test_kho: unpreserve memory in case of error
Date: Sat, 1 Nov 2025 10:23:21 -0400

If there is an error half way through KHO memory preservation, we should
rollback and unpreserve everything that is partially preserved.

Link: https://lkml.kernel.org/r/20251101142325.1326536-6-pasha.tatashin@soleen.com
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |  103 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 73 insertions(+), 30 deletions(-)

--- a/lib/test_kho.c~test_kho-unpreserve-memory-in-case-of-error
+++ a/lib/test_kho.c
@@ -33,17 +33,28 @@ struct kho_test_state {
 	unsigned int nr_folios;
 	struct folio **folios;
 	phys_addr_t *folios_info;
+	struct kho_vmalloc folios_info_phys;
+	int nr_folios_preserved;
 	struct folio *fdt;
 	__wsum csum;
 };
 
 static struct kho_test_state kho_test_state;
 
-static int kho_test_save_data(struct kho_test_state *state, void *fdt)
+static void kho_test_unpreserve_data(struct kho_test_state *state)
+{
+	for (int i = 0; i < state->nr_folios_preserved; i++)
+		kho_unpreserve_folio(state->folios[i]);
+
+	kho_unpreserve_vmalloc(&state->folios_info_phys);
+	vfree(state->folios_info);
+}
+
+static int kho_test_preserve_data(struct kho_test_state *state)
 {
-	phys_addr_t *folios_info __free(kvfree) = NULL;
 	struct kho_vmalloc folios_info_phys;
-	int err = 0;
+	phys_addr_t *folios_info;
+	int err;
 
 	folios_info = vmalloc_array(state->nr_folios, sizeof(*folios_info));
 	if (!folios_info)
@@ -51,64 +62,98 @@ static int kho_test_save_data(struct kho
 
 	err = kho_preserve_vmalloc(folios_info, &folios_info_phys);
 	if (err)
-		return err;
+		goto err_free_info;
+
+	state->folios_info_phys = folios_info_phys;
+	state->folios_info = folios_info;
 
 	for (int i = 0; i < state->nr_folios; i++) {
 		struct folio *folio = state->folios[i];
 		unsigned int order = folio_order(folio);
 
 		folios_info[i] = virt_to_phys(folio_address(folio)) | order;
-
 		err = kho_preserve_folio(folio);
 		if (err)
-			break;
+			goto err_unpreserve;
+		state->nr_folios_preserved++;
 	}
 
+	return 0;
+
+err_unpreserve:
+	/*
+	 * kho_test_unpreserve_data frees folio_info, bail out immediately to
+	 * avoid double free
+	 */
+	kho_test_unpreserve_data(state);
+	return err;
+
+err_free_info:
+	vfree(folios_info);
+	return err;
+}
+
+static int kho_test_prepare_fdt(struct kho_test_state *state, ssize_t fdt_size)
+{
+	const char compatible[] = KHO_TEST_COMPAT;
+	unsigned int magic = KHO_TEST_MAGIC;
+	void *fdt = folio_address(state->fdt);
+	int err;
+
+	err = fdt_create(fdt, fdt_size);
+	err |= fdt_finish_reservemap(fdt);
+	err |= fdt_begin_node(fdt, "");
+	err |= fdt_property(fdt, "compatible", compatible, sizeof(compatible));
+	err |= fdt_property(fdt, "magic", &magic, sizeof(magic));
+
 	err |= fdt_begin_node(fdt, "data");
 	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
 			    sizeof(state->nr_folios));
-	err |= fdt_property(fdt, "folios_info", &folios_info_phys,
-			    sizeof(folios_info_phys));
+	err |= fdt_property(fdt, "folios_info", &state->folios_info_phys,
+			    sizeof(state->folios_info_phys));
 	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
 	err |= fdt_end_node(fdt);
 
-	if (!err)
-		state->folios_info = no_free_ptr(folios_info);
+	err |= fdt_end_node(fdt);
+	err |= fdt_finish(fdt);
 
 	return err;
 }
 
-static int kho_test_prepare_fdt(struct kho_test_state *state)
+static int kho_test_preserve(struct kho_test_state *state)
 {
-	const char compatible[] = KHO_TEST_COMPAT;
-	unsigned int magic = KHO_TEST_MAGIC;
 	ssize_t fdt_size;
-	int err = 0;
-	void *fdt;
+	int err;
 
 	fdt_size = state->nr_folios * sizeof(phys_addr_t) + PAGE_SIZE;
 	state->fdt = folio_alloc(GFP_KERNEL, get_order(fdt_size));
 	if (!state->fdt)
 		return -ENOMEM;
 
-	fdt = folio_address(state->fdt);
-
-	err |= kho_preserve_folio(state->fdt);
-	err |= fdt_create(fdt, fdt_size);
-	err |= fdt_finish_reservemap(fdt);
+	err = kho_preserve_folio(state->fdt);
+	if (err)
+		goto err_free_fdt;
 
-	err |= fdt_begin_node(fdt, "");
-	err |= fdt_property(fdt, "compatible", compatible, sizeof(compatible));
-	err |= fdt_property(fdt, "magic", &magic, sizeof(magic));
-	err |= kho_test_save_data(state, fdt);
-	err |= fdt_end_node(fdt);
+	err = kho_test_preserve_data(state);
+	if (err)
+		goto err_unpreserve_fdt;
 
-	err |= fdt_finish(fdt);
+	err = kho_test_prepare_fdt(state, fdt_size);
+	if (err)
+		goto err_unpreserve_data;
 
 	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt));
 	if (err)
-		folio_put(state->fdt);
+		goto err_unpreserve_data;
 
+	return 0;
+
+err_unpreserve_data:
+	kho_test_unpreserve_data(state);
+err_unpreserve_fdt:
+	kho_unpreserve_folio(state->fdt);
+err_free_fdt:
+	folio_put(state->fdt);
 	return err;
 }
 
@@ -174,14 +219,12 @@ static int kho_test_save(void)
 	if (err)
 		goto err_free_folios;
 
-	err = kho_test_prepare_fdt(state);
+	err = kho_test_preserve(state);
 	if (err)
 		goto err_free_folios;
 
 	return 0;
 
-err_free_fdt:
-	folio_put(state->fdt);
 err_free_folios:
 	kvfree(folios);
 	return err;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

