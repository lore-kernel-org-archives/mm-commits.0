Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9EF2C327E
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156119; cv=none; b=R28Mgpd3sKBPUQEJpoZMJgsDophnkhrcF1a5edSYOIPM21FfDHpkUT+mxhRXfBLPPy+wN4KIwTd6hQPlOll1tmcFtNcOLzosU1zFQGCZMc31WHoho1Qm3iWwMKaDsZ91AS1GKDTaLfJ39D37BfqwrXCmSI7IB0qUXNKyNHCLsn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156119; c=relaxed/simple;
	bh=reZny+rVhXVu6iuyp84XnFfdpBkQZiuLc+BgXkfknHc=;
	h=Date:To:From:Subject:Message-Id; b=bmNg/FIk+wZhIYGy2/Lt24hQzhbFfsvZ2CzMM59nuX2DVdqjrbRambxpZxrpFJZv2ENdLnTLfKl3PQrZx7gBuAH5/CL3kGWc76rxOPIzIkXKak79HewQxZB2hc6UCln06Z69denQlWnHuSLALCJw0IWvi3miSyeFL+1XDvhGf38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q7oaHp/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q7oaHp/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AE9C2BC9E;
	Fri, 14 Nov 2025 21:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156119;
	bh=reZny+rVhXVu6iuyp84XnFfdpBkQZiuLc+BgXkfknHc=;
	h=Date:To:From:Subject:From;
	b=Q7oaHp/aCrjDBSNtG3VdvBerHPrMZNT8dp1xNw+OJoUnz/G13GgqPFgNea6l+n1jr
	 W639Uh4VKl+ti16ke5do2FmWLZlO3M0d4qzcMhWKXks6/VSpYd12DpSGXQqHRUdiL1
	 pIpzXt9V4rZwrjsA1Jpmo6Lke9QmHu55cGP4oR5Q=
Date: Fri, 14 Nov 2025 13:35:17 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213519.10AE9C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: verify deserialization status and fix FDT alignment access
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch

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
Subject: kho: verify deserialization status and fix FDT alignment access
Date: Fri, 14 Nov 2025 13:59:54 -0500

During boot, kho_restore_folio() relies on the memory map having been
successfully deserialized.  If deserialization fails or no map is present,
attempting to restore the FDT folio is unsafe.

Update kho_mem_deserialize() to return a boolean indicating success.  Use
this return value in kho_memory_init() to disable KHO if deserialization
fails.  Also, the incoming FDT folio is never used, there is no reason to
restore it.

Additionally, use get_unaligned() to retrieve the memory map pointer from
the FDT.  FDT properties are not guaranteed to be naturally aligned, and
accessing a 64-bit value via a pointer that is only 32-bit aligned can
cause faults.

Link: https://lkml.kernel.org/r/20251114190002.3311679-6-pasha.tatashin@soleen.com
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

 kernel/liveupdate/kexec_handover.c |   32 ++++++++++++++++-----------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-verify-deserialization-status-and-fix-fdt-alignment-access
+++ a/kernel/liveupdate/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/page-isolation.h>
+#include <linux/unaligned.h>
 #include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
@@ -451,20 +452,27 @@ static void __init deserialize_bitmap(un
 	}
 }
 
-static void __init kho_mem_deserialize(const void *fdt)
+/* Return true if memory was deserizlied */
+static bool __init kho_mem_deserialize(const void *fdt)
 {
 	struct khoser_mem_chunk *chunk;
-	const phys_addr_t *mem;
+	const void *mem_ptr;
+	u64 mem;
 	int len;
 
-	mem = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
-
-	if (!mem || len != sizeof(*mem)) {
+	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
+	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
-		return;
+		return false;
 	}
 
-	chunk = *mem ? phys_to_virt(*mem) : NULL;
+	mem = get_unaligned((const u64 *)mem_ptr);
+	chunk = mem ? phys_to_virt(mem) : NULL;
+
+	/* No preserved physical pages were passed, no deserialization */
+	if (!chunk)
+		return false;
+
 	while (chunk) {
 		unsigned int i;
 
@@ -473,6 +481,8 @@ static void __init kho_mem_deserialize(c
 					   &chunk->bitmaps[i]);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 	}
+
+	return true;
 }
 
 /*
@@ -1458,16 +1468,12 @@ static void __init kho_release_scratch(v
 
 void __init kho_memory_init(void)
 {
-	struct folio *folio;
-
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
 
-		kho_mem_deserialize(kho_get_fdt());
-		folio = kho_restore_folio(kho_in.fdt_phys);
-		if (!folio)
-			pr_warn("failed to restore folio for KHO fdt\n");
+		if (!kho_mem_deserialize(kho_get_fdt()))
+			kho_in.fdt_phys = 0;
 	} else {
 		kho_reserve_scratch();
 	}
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

