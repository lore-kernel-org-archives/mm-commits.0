Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85DE3FBA7
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282004; cv=none; b=ePb6gd3sMsmzT9l2HwiwL8n7NovRvJyJ28vCRww/YZMVlI95THbOcw99QWp8SEjwtCWoVtxSljsPpVA5X9X0qd7wXnMYtrgXnue/KdV6hrLeJDHddyrGi8R2Oe/v9MJqD3u3YCuNgTY3ejaWJvxciAyWc3+edu1DxHCqj8DSHa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282004; c=relaxed/simple;
	bh=Y+01eapGm0bh/vthwqRD0UEobU65cqHbDJY0fSjAYYw=;
	h=Date:To:From:Subject:Message-Id; b=oPEYikBRh6qs3sS4iC+7qDXjoHzdJFgWfVtZ1GD/Skco8pwYr+zl/WzPOXy/39y66L6IJx4HaPTwvJ+LiPgreeBPUYyJf1fXoy4bLb144gVrqV9UmNSRep1dJn9X+wTIdtJu/VtSGizh5xXLUW3M69vdp0gLSCprtpKtRqMxMv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PGd/KSg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PGd/KSg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F2DC4CEF8;
	Thu, 27 Nov 2025 22:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282003;
	bh=Y+01eapGm0bh/vthwqRD0UEobU65cqHbDJY0fSjAYYw=;
	h=Date:To:From:Subject:From;
	b=PGd/KSg2tuumWBBdacwdVoFmz0W4aO7UwIan9DJumKr1dFiL+bFQRZ0TYkCdMchb3
	 xifZW2QhdpQuR4XPnh8X7q779fAR7sAxRlq087mMbK7UjaMlQPw18t9gSyayH0wtTF
	 Ilri3fSVub6cZepb4akKfcAwuVmlfdGqCOX4JM9o=
Date: Thu, 27 Nov 2025 14:20:02 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-introduce-high-level-memory-allocation-api-fix.patch removed from -mm tree
Message-Id: <20251127222003.49F2DC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho-introduce-high-level-memory-allocation-api-fix
has been removed from the -mm tree.  Its filename was
     kho-introduce-high-level-memory-allocation-api-fix.patch

This patch was dropped because it was folded into kho-introduce-high-level-memory-allocation-api.patch

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho-introduce-high-level-memory-allocation-api-fix
Date: Sat, 15 Nov 2025 18:19:41 -0500

build fixes

Link: https://lkml.kernel.org/r/CA+CK2bBgXDhrHwTVgxrw7YTQ-0=LgW0t66CwPCgG=C85ftz4zw@mail.gmail.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511160332.SpHDxf5J-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/kexec_handover.h~kho-introduce-high-level-memory-allocation-api-fix
+++ a/include/linux/kexec_handover.h
@@ -105,13 +105,13 @@ static inline int kho_unpreserve_vmalloc
 	return -EOPNOTSUPP;
 }
 
-void *kho_alloc_preserve(size_t size)
+static inline void *kho_alloc_preserve(size_t size)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-void kho_unpreserve_free(void *mem) { }
-void kho_restore_free(void *mem) { }
+static inline void kho_unpreserve_free(void *mem) { }
+static inline void kho_restore_free(void *mem) { }
 
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
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
liveupdate-luo_core-live-update-orchestrato.patch
liveupdate-luo_core-integrate-with-kho.patch
kexec-call-liveupdate_reboot-before-kexec.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_core-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-simple-kexec-based-selftest-for-luo.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

