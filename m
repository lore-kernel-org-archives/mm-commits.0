Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC565227
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 20:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870160; cv=none; b=Bod6CqtqbiqD79zcInI0mQDVbtWfR4WfK3Dx74iEXOmnKoFL/wOITKEFZ/lhk0Dc4Ze4H63YDpWNi4Sri1qsHsQmArabHRY4zScn3QJpZ19Flw7T7YAtQt7ihF29fTKCaY/YxAvUjV45ub6iOkVFAW6+LJx0ByAD3V1WRVcpXLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870160; c=relaxed/simple;
	bh=DZfMv3AuHu4FxYd8nV8ClMZsmGOnJ5zIFTwJ/L/Fhmg=;
	h=Date:To:From:Subject:Message-Id; b=cBtQKivSXZa7mn1B946GQhCFo/oEjFZNRSE/DZSUK06VtYI4O5ab3J/XbTYtWSutHjsm7vZ5/wDgPaf7crkNDYBNxbfKkw6WbtzboTaE0oVd8IXozONPv8W37v+c6PJQvyuBY2jqGVDo09Qsj4EUVzPoXNAgm8RtYR4qk+X9R2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uzMpdI3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uzMpdI3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203BBC4CEF1;
	Tue,  7 Oct 2025 20:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870160;
	bh=DZfMv3AuHu4FxYd8nV8ClMZsmGOnJ5zIFTwJ/L/Fhmg=;
	h=Date:To:From:Subject:From;
	b=uzMpdI3JytKwupEOlPeGH0+H47bJCdgEIFTi6pQw6jVqYxLtVTJFe/P6XQJHOprM3
	 14DV+44CS0JG4fRfMGY/5xteE4UiBrA6AQwGBneJX4/Ue+HtpShVRIK7ckIez7YHYY
	 F4VaRJbMMr909GnMP1utZXKI+1q+BsuIsx0AHvrI=
Date: Tue, 07 Oct 2025 13:49:19 -0700
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-check-if-kho-is-finalized-in-__kho_preserve_order.patch removed from -mm tree
Message-Id: <20251007204920.203BBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: check if kho is finalized in __kho_preserve_order()
has been removed from the -mm tree.  Its filename was
     kho-check-if-kho-is-finalized-in-__kho_preserve_order.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: check if kho is finalized in __kho_preserve_order()
Date: Sun, 21 Sep 2025 08:44:55 +0300

Patch series "kho: add support for preserving vmalloc allocations", v5.

Following the discussion about preservation of memfd with LUO [1] these
patches add support for preserving vmalloc allocations.

Any KHO uses case presumes that there's a data structure that lists
physical addresses of preserved folios (and potentially some additional
metadata).  Allowing vmalloc preservations with KHO allows scalable
preservation of such data structures.

For instance, instead of allocating array describing preserved folios in
the fdt, memfd preservation can use vmalloc:

        preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
        memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
        kho_preserve_vmalloc(preserved_folios, &folios_info);


This patch (of 4):

Instead of checking if kho is finalized in each caller of
__kho_preserve_order(), do it in the core function itself.

Link: https://lkml.kernel.org/r/20250921054458.4043761-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250921054458.4043761-2-rppt@kernel.org
Link: https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com [1]
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   55 +++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

--- a/kernel/kexec_handover.c~kho-check-if-kho-is-finalized-in-__kho_preserve_order
+++ a/kernel/kexec_handover.c
@@ -107,6 +107,29 @@ struct kho_serialization {
 	struct khoser_mem_chunk *preserved_mem_map;
 };
 
+struct kho_out {
+	struct blocking_notifier_head chain_head;
+
+	struct dentry *dir;
+
+	struct mutex lock; /* protects KHO FDT finalization */
+
+	struct kho_serialization ser;
+	bool finalized;
+};
+
+static struct kho_out kho_out = {
+	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
+	.lock = __MUTEX_INITIALIZER(kho_out.lock),
+	.ser = {
+		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
+		.track = {
+			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
+		},
+	},
+	.finalized = false,
+};
+
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 {
 	void *elm, *res;
@@ -165,6 +188,9 @@ static int __kho_preserve_order(struct k
 
 	might_sleep();
 
+	if (kho_out.finalized)
+		return -EBUSY;
+
 	physxa = xa_load(&track->orders, order);
 	if (!physxa) {
 		int err;
@@ -667,29 +693,6 @@ int kho_add_subtree(struct kho_serializa
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-struct kho_out {
-	struct blocking_notifier_head chain_head;
-
-	struct dentry *dir;
-
-	struct mutex lock; /* protects KHO FDT finalization */
-
-	struct kho_serialization ser;
-	bool finalized;
-};
-
-static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
-	.lock = __MUTEX_INITIALIZER(kho_out.lock),
-	.ser = {
-		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
-		.track = {
-			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
-		},
-	},
-	.finalized = false,
-};
-
 int register_kho_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
@@ -717,9 +720,6 @@ int kho_preserve_folio(struct folio *fol
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.ser.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	return __kho_preserve_order(track, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
@@ -743,9 +743,6 @@ int kho_preserve_phys(phys_addr_t phys,
 	int err = 0;
 	struct kho_mem_track *track = &kho_out.ser.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch
kho-add-support-for-preserving-vmalloc-allocations.patch
lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt.patch

