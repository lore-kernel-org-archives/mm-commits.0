Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2FF31579B
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282381; cv=none; b=WMNcHmm3iy50M1Ym0ZKn0FbSNUQaQef1LJBPUjnbEyX1DSIAmiuRsT14ycAVK0CoPlJNPPEX8QDJRyWWl1WHT9LGGBVULeBERRigHl7/JMaYEd47o6n48fgl62IzoXSY2R/2k77CNx6YnHKboQ4JrLGcg4U4ShbpDV4sGCNzzSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282381; c=relaxed/simple;
	bh=nqQlVcz4evFklKqFMdiwfLCwn/SgXmQLREG/bzaG6Z0=;
	h=Date:To:From:Subject:Message-Id; b=CfX1tyE4iwQYLN8KsCxp4ay6J6w5npbwJXxAPiejH9iP5osr59PRUWPL2yEtdUqmhAXFx6PkRgeMMJfYWS7emINDlRgtqxSdVEfYZLfaq4w9pPU9DyTuGV2eTcyR37YBMdpFrbBXQ1SWwgdI3xxGFU3cCSj156Vz8HyJOr3xFNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UVCf6/S4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UVCf6/S4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5286AC4CEFB;
	Thu, 27 Nov 2025 22:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282381;
	bh=nqQlVcz4evFklKqFMdiwfLCwn/SgXmQLREG/bzaG6Z0=;
	h=Date:To:From:Subject:From;
	b=UVCf6/S4sJ7bhRXO3u79HEcop1FjfhX8jt+H8AcZ8FbaPkcoZm5hEliqp9D15tnUC
	 PS3jezAa4XIp61jZvGt42Fk+IovLUb4tB+n5xEAO5ft1QtZbUWjEVu2TN8K8i4BOsR
	 qQgwUocQsa50XOc4vzY79sBHRvopTqLdk+O0i12U=
Date: Thu, 27 Nov 2025 14:26:20 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch removed from -mm tree
Message-Id: <20251127222621.5286AC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: remove global preserved_mem_map and store state in FDT
has been removed from the -mm tree.  Its filename was
     kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: remove global preserved_mem_map and store state in FDT
Date: Fri, 14 Nov 2025 13:59:57 -0500

Currently, the serialized memory map is tracked via
kho_out.preserved_mem_map and copied to the FDT during finalization.  This
double tracking is redundant.

Remove preserved_mem_map from kho_out.  Instead, maintain the physical
address of the head chunk directly in the preserved-memory-map FDT
property.

Introduce kho_update_memory_map() to manage this property. This function
handles:
1. Retrieving and freeing any existing serialized map (handling the
   abort/retry case).
2. Updating the FDT property with the new chunk address.

This establishes the FDT as the single source of truth for the handover
state.

Link: https://lkml.kernel.org/r/20251114190002.3311679-9-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   43 ++++++++++++++++-----------
 1 file changed, 26 insertions(+), 17 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-remove-global-preserved_mem_map-and-store-state-in-fdt
+++ a/kernel/liveupdate/kexec_handover.c
@@ -119,9 +119,6 @@ struct kho_out {
 	struct mutex fdts_lock;
 
 	struct kho_mem_track track;
-	/* First chunk of serialized preserved memory map */
-	struct khoser_mem_chunk *preserved_mem_map;
-
 	struct kho_debugfs dbg;
 };
 
@@ -382,6 +379,27 @@ static void kho_mem_ser_free(struct khos
 	}
 }
 
+/*
+ *  Update memory map property, if old one is found discard it via
+ *  kho_mem_ser_free().
+ */
+static void kho_update_memory_map(struct khoser_mem_chunk *first_chunk)
+{
+	void *ptr;
+	u64 phys;
+
+	ptr = fdt_getprop_w(kho_out.fdt, 0, PROP_PRESERVED_MEMORY_MAP, NULL);
+
+	/* Check and discard previous memory map */
+	phys = get_unaligned((u64 *)ptr);
+	if (phys)
+		kho_mem_ser_free((struct khoser_mem_chunk *)phys_to_virt(phys));
+
+	/* Update with the new value */
+	phys = first_chunk ? (u64)virt_to_phys(first_chunk) : 0;
+	put_unaligned(phys, (u64 *)ptr);
+}
+
 static int kho_mem_serialize(struct kho_out *kho_out)
 {
 	struct khoser_mem_chunk *first_chunk = NULL;
@@ -422,7 +440,7 @@ static int kho_mem_serialize(struct kho_
 		}
 	}
 
-	kho_out->preserved_mem_map = first_chunk;
+	kho_update_memory_map(first_chunk);
 
 	return 0;
 
@@ -1223,8 +1241,7 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	kho_mem_ser_free(kho_out.preserved_mem_map);
-	kho_out.preserved_mem_map = NULL;
+	kho_update_memory_map(NULL);
 	kho_out.finalized = false;
 
 	return 0;
@@ -1234,21 +1251,15 @@ static int __kho_finalize(void)
 {
 	void *root = kho_out.fdt;
 	struct kho_sub_fdt *fdt;
-	u64 *preserved_mem_map;
+	u64 empty_mem_map = 0;
 	int err;
 
 	err = fdt_create(root, PAGE_SIZE);
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	/**
-	 * Reserve the preserved-memory-map property in the root FDT, so
-	 * that all property definitions will precede subnodes created by
-	 * KHO callers.
-	 */
-	err |= fdt_property_placeholder(root, PROP_PRESERVED_MEMORY_MAP,
-					sizeof(*preserved_mem_map),
-					(void **)&preserved_mem_map);
+	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
+			    sizeof(empty_mem_map));
 	if (err)
 		goto err_exit;
 
@@ -1271,8 +1282,6 @@ static int __kho_finalize(void)
 	if (err)
 		goto err_exit;
 
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
-
 	return 0;
 
 err_exit:
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

