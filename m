Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71749463
	for <mm-commits@vger.kernel.org>; Sat, 15 Nov 2025 00:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763166878; cv=none; b=Yrh7jkp8E6MLT8xIS82IZAEwNr0BR5bfa3eFUpdP5ijYu7rANionvhoaCUMZAiONPsRVTD4+Mtw9y33noR4XriNCjkJrMrXBrMtaIK3TDn9JZESSjJOMZ3cPaQskgfkk0ZffChYGW9dTb3somx5zCLOGBlxDF8cL9XU2K+myltg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763166878; c=relaxed/simple;
	bh=msSUl13NrpwoCxcTLIfccw/64lv+GSXvr2m9Qd4IAJs=;
	h=Date:To:From:Subject:Message-Id; b=m4HDeLoow+l0OoVcXHEgg/81qVfnkiTwy6IagWUXYM2CoFKBiL/T5OFWBg16ihp+xxgjeLEihtr3hjvKv1fQoxNy+hl9ghC1adqWc9EnbAdAh8gsFu1I80W3J4WnEi5x9NUlAYzTbcHMwdrfc2WTriErCHF9jv1NOM2g0YVgEGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qVAcim75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qVAcim75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273ACC4CEFB;
	Sat, 15 Nov 2025 00:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763166878;
	bh=msSUl13NrpwoCxcTLIfccw/64lv+GSXvr2m9Qd4IAJs=;
	h=Date:To:From:Subject:From;
	b=qVAcim75GaI54NSTwmHjzAQxakTrTPXhB2OaF930rm4D4uyJn8uvc8Ag+9KLgmJTz
	 JJzd9086ODqlJCSLg2ksYI3HwROOn0ZFE2kgovO5xgrKNWI/PK+7jRDctrqkJN5fXC
	 bxaVFqEDqWt9U3mYAlnwmZltUk4+SOOBF0X/00jk=
Date: Fri, 14 Nov 2025 16:34:37 -0800
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-luo_core-integrate-with-kho-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251115003438.273ACC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate-luo_core-integrate-with-kho-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-luo_core-integrate-with-kho-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-luo_core-integrate-with-kho-fix.patch

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
Subject: liveupdate-luo_core-integrate-with-kho-fix
Date: Fri, 14 Nov 2025 17:06:42 -0500

Link: https://lkml.kernel.org/r/CA+CK2bD4vr2tZpKaGqOZBhP+DMZYYm3EB_0ToyFDduZDMWhXxw@mail.gmail.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/luo_core.c~liveupdate-luo_core-integrate-with-kho-fix
+++ a/kernel/liveupdate/luo_core.c
@@ -291,7 +291,7 @@ void luo_free_unpreserve(void *mem, size
 		return;
 
 	folio = virt_to_folio(mem);
-	WARN_ON_ONCE(kho_unpreserve_folio(folio));
+	kho_unpreserve_folio(folio);
 	folio_put(folio);
 }
 
diff --git /dev/null /dev/null
new file mode 100644
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

