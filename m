Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C692027979A
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 03:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762226795; cv=none; b=Q6SuEAAmA4lsojpbLMkhAcMIVt2I913Lm7QnmwjkRcIZkfezDRnk5Erb7v5ioyFZCnzyLkpoEk/9JDgzjw8DwlttjLZq5QSZnNBh/aidzQF0R6ErsYohu5vugVoRFw4O6a9dFYEVjxyemhX/tJrjAtqS3Bdwk0s68s6ZaVlQMvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762226795; c=relaxed/simple;
	bh=zkMCKWaXuyiyBajRt5Kb9ljuNLRzXqMAmKihP31LvzI=;
	h=Date:To:From:Subject:Message-Id; b=BNzDtqWEmmVpDkMC+c878YXbROztAIHucEF5v/nJKo7hiGM/37Fz1CHK+Jk2c8TQM1THp62sm2WAKZwd8+cUQO07oR+RAMUF/lb9V/p0r9WGA7jzIqEMZk3WA9T2NEGGRKFnUIdQd0iDgqPbV04UYKPidnuTU9+c16mTO2l5no0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gCRp47o3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gCRp47o3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAFDC113D0;
	Tue,  4 Nov 2025 03:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762226795;
	bh=zkMCKWaXuyiyBajRt5Kb9ljuNLRzXqMAmKihP31LvzI=;
	h=Date:To:From:Subject:From;
	b=gCRp47o30+9LUpAkMksiCpiK9Q9kocNm+MUaooh0ibqwQDaqBJXzIEmZinxJ0Hm8F
	 XfTS8ye1aXp4HrG5BL/LZxgNagjt/6nFWZk23dCltDvQpNWkZP42RHB9BTdINufST4
	 FSgOYQX/a+E5XF4W9Ltl17VC0VRxQkaJ0MiFnpys=
Date: Mon, 03 Nov 2025 19:26:34 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_kho-unpreserve-memory-in-case-of-error.patch added to mm-nonmm-unstable branch
Message-Id: <20251104032635.4BAFDC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_kho: unpreserve memory in case of error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     test_kho-unpreserve-memory-in-case-of-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_kho-unpreserve-memory-in-case-of-error.patch

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

