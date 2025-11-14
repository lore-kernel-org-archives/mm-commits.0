Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A856435BDC3
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156127; cv=none; b=SkrC1eHlbonJc4OF5oWuhMJWA1JrG5lnByGqyZ2i5lvbDr+90rVm2GKJuaracgCPzxj1l4/ACEttGdF1DhGtSxGYsuW+v15Ij7Nr+OPtTTTRFmYm9SZjHTfcdN+a/7Moj2X0YrYI4b1CAF88K6E1qJfPOA9n+skkioEsQxNhgJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156127; c=relaxed/simple;
	bh=hO4vl0pTADgAddeQFb60oPdrL8IX+Je9XNTvEDMOOWw=;
	h=Date:To:From:Subject:Message-Id; b=pwcynhqO+30UZopXXNSIomU8YllzpM8lkUMw/y4DaWAJTP62Z6dsJM6wJoi5lwk5GA2v4mpGbmwJMWhJl8EVk9/Ww92qvGVClPvs+LWJKbvSmqyxpIc8tcmpJA4gzj/KWtXi5Dkoj+B3yiSyKpQVV2zU/yFCKJmcORP4idppOBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jUa9cj3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jUa9cj3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38858C4CEF1;
	Fri, 14 Nov 2025 21:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156127;
	bh=hO4vl0pTADgAddeQFb60oPdrL8IX+Je9XNTvEDMOOWw=;
	h=Date:To:From:Subject:From;
	b=jUa9cj3Daw1gqNjPca3I44aaXvksFJevpTEND1bDEqtMTpMAc9Uzkc0qLONmo7x1r
	 UNL6aloKcsG8DUPWJ2+reYS/GDxhlV5i6XDEuCYTj2zkv3jFBIB8ui8Arx9YppU3Qx
	 y/X2YJWV0bRYsfnRZqVAfIpJNandTBavRnCSXvdI=
Date: Fri, 14 Nov 2025 13:35:26 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213527.38858C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: remove global preserved_mem_map and store state in FDT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch

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

lib-test_kho-check-if-kho-is-enabled.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
maintainers-update-kho-maintainers.patch
kho-fix-misleading-log-message-in-kho_populate.patch
kho-convert-__kho_abort-to-return-void.patch
kho-introduce-high-level-memory-allocation-api.patch
kho-preserve-fdt-folio-only-once-during-initialization.patch
kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch
kho-always-expose-output-fdt-in-debugfs.patch
kho-simplify-serialization-and-remove-__kho_abort.patch
kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch
kho-remove-abort-functionality-and-support-state-refresh.patch
kho-update-fdt-dynamically-for-subtree-addition-removal.patch
kho-allow-kexec-load-before-kho-finalization.patch
kho-allow-memory-preservation-state-updates-after-finalization.patch
kho-add-kconfig-option-to-enable-kho-by-default.patch
liveupdate-luo_core-luo_ioctl-live-update-orchestrator.patch
liveupdate-luo_core-integrate-with-kho.patch
reboot-call-liveupdate_reboot-before-kexec.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_ioctl-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation-and-state-management.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-kexec-based-selftest-for-session-lifecycle.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

