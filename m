Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1457527A904
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156122; cv=none; b=K2sv72HZ16LXjTSntSh6gtJN5yZ4kpDsHIFpVrSZB8qUH9tKLfctqIaQ8bznjWSZb8IgBBtpHp0pWNzb3odyi6Y5FfNjZSX4Kg7ucbWUNuBoAFFTdWr97TTBqtLWoZwEMlBoj/z7TDaOVmlA2VKyXg7LOtgY38VkFuC5CE5T2dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156122; c=relaxed/simple;
	bh=zA7JKux0LebV9/DbOcS8bmuQ5zjXrC3whIYmj/Ui/MA=;
	h=Date:To:From:Subject:Message-Id; b=cuh0VSjtznrt6gQswqtAOYl1wr384LliXlyn1ILuez4PcG2KTeBX12GNQkmee7Z5/eqhupfw/Y0WNsLPRuStOyDXzlQp53SFZa1vo0hTvLHUQ6QlOe4h8BwBlxQJqeO6+CMwD6ron0yG9SJV32aAyEbtdBTfzbAdplaFss3FIOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KdHmn9Pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KdHmn9Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6CAC4CEF1;
	Fri, 14 Nov 2025 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156121;
	bh=zA7JKux0LebV9/DbOcS8bmuQ5zjXrC3whIYmj/Ui/MA=;
	h=Date:To:From:Subject:From;
	b=KdHmn9PvfMSbJf7Y9nna/455OtO/Q6C8Pv3F8i5QTA+vvRC5J0P633VCiXfP3igcP
	 9PgieIlXrt1M9Z9jqkP4pORuTxSjXPBVVKeqZTRfjUYVS/db5ioJ55zlY7oOdy2mWQ
	 ulGxX7DvoFCWVul59qKz/wgxfyqD0FLOsGGsMAOk=
Date: Fri, 14 Nov 2025 13:35:20 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-always-expose-output-fdt-in-debugfs.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213521.BF6CAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: always expose output FDT in debugfs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-always-expose-output-fdt-in-debugfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-always-expose-output-fdt-in-debugfs.patch

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
Subject: kho: always expose output FDT in debugfs
Date: Fri, 14 Nov 2025 13:59:55 -0500

Currently, the output FDT is added to debugfs only when KHO is finalized
and removed when aborted.

There is no need to hide the FDT based on the state.  Always expose it
starting from initialization.  This aids the transition toward removing
the explicit abort functionality and converting KHO to be fully stateless.

Link: https://lkml.kernel.org/r/20251114190002.3311679-7-pasha.tatashin@soleen.com
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

 kernel/liveupdate/kexec_handover.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-always-expose-output-fdt-in-debugfs
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1234,8 +1234,6 @@ int kho_abort(void)
 	__kho_abort();
 	kho_out.finalized = false;
 
-	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
-
 	return 0;
 }
 
@@ -1306,9 +1304,6 @@ int kho_finalize(void)
 
 	kho_out.finalized = true;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt, true));
-
 	return 0;
 }
 
@@ -1425,6 +1420,9 @@ static __init int kho_init(void)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
 	}
 
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
+					 kho_out.fdt, true));
+
 	return 0;
 
 err_free_fdt:
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

