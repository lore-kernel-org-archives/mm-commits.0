Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE30E25392A
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758143773; cv=none; b=EUUWOO6efvVuu7QDbG8Sa/8Bq/YbeQ2tKld0Z7O5y7RU/eZh9uwPnxUATky4ST9AO2SNZ8SAq2ICfm2SjiTqMqdsiLu4dqL/XfzADPe0c0FmCnWWeWwa+mDOEMn/sgg22ZSqfaxU5p5KMRhEkS/P2H9VaMZY/Lf9wJZQRBQrVc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758143773; c=relaxed/simple;
	bh=1NNu+teEmo4IJjgX17ueqEAtIjQJrXkPr6vD/ywcIgY=;
	h=Date:To:From:Subject:Message-Id; b=VuCaEtKaxCtNVGT3Eh9SOdCzHaEnk2etGAdVrRtNFpzuheJRO0BIAxPS0GguSmKdgeLDloh5mUURjLUDbn+DQ9OYLuW5ZT2Cs20uvjKF4oaxqs5W1HR6bOMz6CFYc8M3TU4GiWup5eXvoW89J36mSfIh5ZB18UuaLc0+lbDoHU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iDPUjT/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iDPUjT/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F0FC4CEE7;
	Wed, 17 Sep 2025 21:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758143772;
	bh=1NNu+teEmo4IJjgX17ueqEAtIjQJrXkPr6vD/ywcIgY=;
	h=Date:To:From:Subject:From;
	b=iDPUjT/dHFuW12URLHkpJ/QJcnbC38bCdV5GIoE31rFunUe8EI813bu3rBMKozplf
	 62iTTCChIbEqJg+46tiac1ybCWux8dVy6sC2H5dnyrbSnR2vl5GI+xxLRgt6GCrrxD
	 v/e/vOlNXz5Df4QGEhqxuQ2GEr4aeabnHPJEwS64=
Date: Wed, 17 Sep 2025 14:16:11 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,pratyush@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt.patch added to mm-new branch
Message-Id: <20250917211612.70F0FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
has been added to the -mm mm-new branch.  Its filename is
     lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
Date: Wed, 17 Sep 2025 20:40:33 +0300

KHO test stores physical addresses of the preserved folios directly in
fdt.  Use kho_preserve_vmalloc() instead of it and kho_restore_vmalloc()
to retrieve the addresses after kexec.

This makes the test more scalable from one side and adds tests coverage
for kho_preserve_vmalloc() from the other.

Link: https://lkml.kernel.org/r/20250917174033.3810435-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

--- a/lib/test_kho.c~lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt
+++ a/lib/test_kho.c
@@ -32,6 +32,7 @@ module_param(max_mem, long, 0644);
 struct kho_test_state {
 	unsigned int nr_folios;
 	struct folio **folios;
+	phys_addr_t *folios_info;
 	struct folio *fdt;
 	__wsum csum;
 };
@@ -67,18 +68,15 @@ static struct notifier_block kho_test_nb
 
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
-	phys_addr_t *folios_info;
+	phys_addr_t *folios_info __free(kvfree) = NULL;
+	struct kho_vmalloc folios_info_phys;
 	int err = 0;
 
-	err |= fdt_begin_node(fdt, "data");
-	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
-			    sizeof(state->nr_folios));
-	err |= fdt_property_placeholder(fdt, "folios_info",
-					state->nr_folios * sizeof(*folios_info),
-					(void **)&folios_info);
-	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
-	err |= fdt_end_node(fdt);
+	folios_info = vmalloc_array(state->nr_folios, sizeof(*folios_info));
+	if (!folios_info)
+		return -ENOMEM;
 
+	err = kho_preserve_vmalloc(folios_info, &folios_info_phys);
 	if (err)
 		return err;
 
@@ -93,6 +91,17 @@ static int kho_test_save_data(struct kho
 			break;
 	}
 
+	err |= fdt_begin_node(fdt, "data");
+	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
+			    sizeof(state->nr_folios));
+	err |= fdt_property(fdt, "folios_info", &folios_info_phys,
+			    sizeof(folios_info_phys));
+	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
+	err |= fdt_end_node(fdt);
+
+	if (!err)
+		state->folios_info = no_free_ptr(folios_info);
+
 	return err;
 }
 
@@ -209,8 +218,9 @@ err_free_folios:
 
 static int kho_test_restore_data(const void *fdt, int node)
 {
+	const struct kho_vmalloc *folios_info_phys;
 	const unsigned int *nr_folios;
-	const phys_addr_t *folios_info;
+	phys_addr_t *folios_info;
 	const __wsum *old_csum;
 	__wsum csum = 0;
 	int len;
@@ -225,8 +235,12 @@ static int kho_test_restore_data(const v
 	if (!old_csum || len != sizeof(*old_csum))
 		return -EINVAL;
 
-	folios_info = fdt_getprop(fdt, node, "folios_info", &len);
-	if (!folios_info || len != sizeof(*folios_info) * *nr_folios)
+	folios_info_phys = fdt_getprop(fdt, node, "folios_info", &len);
+	if (!folios_info_phys || len != sizeof(*folios_info_phys))
+		return -EINVAL;
+
+	folios_info = kho_restore_vmalloc(folios_info_phys);
+	if (!folios_info)
 		return -EINVAL;
 
 	for (int i = 0; i < *nr_folios; i++) {
@@ -246,6 +260,8 @@ static int kho_test_restore_data(const v
 		folio_put(folio);
 	}
 
+	vfree(folios_info);
+
 	if (csum != *old_csum)
 		return -EINVAL;
 
@@ -304,6 +320,7 @@ static void kho_test_cleanup(void)
 		folio_put(kho_test_state.folios[i]);
 
 	kvfree(kho_test_state.folios);
+	vfree(kho_test_state.folios_info);
 	folio_put(kho_test_state.fdt);
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-check-if-kho-is-finalized-in-__kho_preserve_order.patch
kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch
kho-add-support-for-preserving-vmalloc-allocations.patch
lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt.patch

