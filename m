Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8220E22A4CC
	for <mm-commits@vger.kernel.org>; Sat, 15 Nov 2025 23:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763250338; cv=none; b=ugFTdQY34E6u7My2tYDRluplzlKoWiMByke6wmHd/n6n+hLdRUqEu4e/OQbP4rBAoP+aAg4preMW1yCSNbOuXJCzy459+3KZCO/PW0LPuHiNz7f/GR6MBOIRoh9dDSd/60PaUVb+GsFtIUb2oxCxhoJFAbod2+HFxJ9tBWFgbLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763250338; c=relaxed/simple;
	bh=xxYKAW7DmCbBoOZkXhyahdAnGCfLmQ6vP3sR6C4/EaQ=;
	h=Date:To:From:Subject:Message-Id; b=sTMRZb7Oji8ZP31g3ZsIsRm8sIk1Emiu8QXFHrZixu3pKktSNwDjdJm13ZuPc935ru+71Do1vwEDQmggmXpY1ZeERKoGntvtpKFPKfoIMISL3IaQRjVq6hQGfzoVNQoNaFAhA1gfEzrKZNBdbZ2xAnqSvotiXKjSjG1CCSjK0bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ixsqkMAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ixsqkMAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4C3C4CEF5;
	Sat, 15 Nov 2025 23:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763250337;
	bh=xxYKAW7DmCbBoOZkXhyahdAnGCfLmQ6vP3sR6C4/EaQ=;
	h=Date:To:From:Subject:From;
	b=ixsqkMAmgJCdWHfZ0k8A4QyAouA47gysLiqRRfx7PmGIFuCyhMJU8689b1plOKYrZ
	 +ImcjUyAy3Ob3WwDbMTvnjAYLlhOHJ/TblLuQkw97sJFEHnHT9h1pA5h+H1cFmF3qg
	 Ibf+go8/2KsElNShPRej/d77FC9g3a8EUja2beEM=
Date: Sat, 15 Nov 2025 15:45:36 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-introduce-high-level-memory-allocation-api-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251115234537.AC4C3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-introduce-high-level-memory-allocation-api-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-introduce-high-level-memory-allocation-api-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-introduce-high-level-memory-allocation-api-fix.patch

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
Subject: kho-introduce-high-level-memory-allocation-api-fix
Date: Sat, 15 Nov 2025 18:19:41 -0500

build fixes

Link: https://lkml.kernel.org/r/CA+CK2bBgXDhrHwTVgxrw7YTQ-0=LgW0t66CwPCgG=C85ftz4zw@mail.gmail.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511160314.OK0OGRXl-lkp=
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
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
maintainers-update-kho-maintainers.patch
kho-fix-misleading-log-message-in-kho_populate.patch
kho-convert-__kho_abort-to-return-void.patch
kho-introduce-high-level-memory-allocation-api.patch
kho-introduce-high-level-memory-allocation-api-fix.patch
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
liveupdate-luo_core-integrate-with-kho-fix.patch
reboot-call-liveupdate_reboot-before-kexec.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_session-add-sessions-support-fix.patch
liveupdate-luo_ioctl-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation-and-state-management.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
mm-memfd_luo-allow-preserving-memfd-fix.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-kexec-based-selftest-for-session-lifecycle.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

