Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839711E8329
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 21:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758143768; cv=none; b=o8GjJquOw34Okb37bA9LV26nmQCimTREzeet3PVHl46E/bcrfme+YNHWihIPI7kkim71Rso4i9fD9/hH3odRnSd7puBkeDFXB8osCPFeadFm4pC38O9CPCpMGfUxR6lpi2K47bpj/bkhEVU9QwZ+yvsmrrCckQ4n2Oaq3h1mKsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758143768; c=relaxed/simple;
	bh=WS6u6tKd97VNGODfObrE2m5aWqcLsVpbmhV0Vrv3LQA=;
	h=Date:To:From:Subject:Message-Id; b=Uw4soxStrVtqWl5EpLRTMuoR0GJwY0Px+3oxqMuc6HRrPA5ut0A6zpz8YiWIHtiQIlZmCZ8t/Iz/+SdHyx/uKSQTZ85hk6Z4wxNBiIpy9xPqKkV66nQ7FupupplIeYKB87jIC/jRSh7Wn2XvyHVnX+NCQwMki5cDBJlyVW6ASfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WBLJePpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WBLJePpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA87C4CEE7;
	Wed, 17 Sep 2025 21:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758143767;
	bh=WS6u6tKd97VNGODfObrE2m5aWqcLsVpbmhV0Vrv3LQA=;
	h=Date:To:From:Subject:From;
	b=WBLJePppgUknGbL0TK6I2N7sUQkqTnNyfI1PrshX/T6ICUW6feZlZ91SSpw+2nytL
	 Rbxp5XKUEGd8bkuKlTo+2pEyf3SXHSFyvR8k9Wnf3JMSx4Q1yVuGl1Zgw56pWW2Nwu
	 lFadu62SRrlCcRoVzAxEkqXe1MhcXFOuktRloPPQ=
Date: Wed, 17 Sep 2025 14:16:07 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,pratyush@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-check-if-kho-is-finalized-in-__kho_preserve_order.patch added to mm-new branch
Message-Id: <20250917211607.BEA87C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: check if kho is finalized in __kho_preserve_order()
has been added to the -mm mm-new branch.  Its filename is
     kho-check-if-kho-is-finalized-in-__kho_preserve_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-check-if-kho-is-finalized-in-__kho_preserve_order.patch

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
Subject: kho: check if kho is finalized in __kho_preserve_order()
Date: Wed, 17 Sep 2025 20:40:30 +0300

Patch series "kho: add support for preserving vmalloc allocations", v4.

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

Link: https://lkml.kernel.org/r/20250917174033.3810435-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250917174033.3810435-2-rppt@kernel.org
Link: https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com [1]
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

 kernel/kexec_handover.c |   55 +++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

--- a/kernel/kexec_handover.c~kho-check-if-kho-is-finalized-in-__kho_preserve_order
+++ a/kernel/kexec_handover.c
@@ -91,6 +91,29 @@ struct kho_serialization {
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
@@ -149,6 +172,9 @@ static int __kho_preserve_order(struct k
 
 	might_sleep();
 
+	if (kho_out.finalized)
+		return -EBUSY;
+
 	physxa = xa_load(&track->orders, order);
 	if (!physxa) {
 		int err;
@@ -640,29 +666,6 @@ int kho_add_subtree(struct kho_serializa
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
@@ -690,9 +693,6 @@ int kho_preserve_folio(struct folio *fol
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.ser.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	return __kho_preserve_order(track, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
@@ -716,9 +716,6 @@ int kho_preserve_phys(phys_addr_t phys,
 	int err = 0;
 	struct kho_mem_track *track = &kho_out.ser.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-check-if-kho-is-finalized-in-__kho_preserve_order.patch
kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch
kho-add-support-for-preserving-vmalloc-allocations.patch
lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt.patch

