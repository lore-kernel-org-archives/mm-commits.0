Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DEE35BDC1
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156142; cv=none; b=P2X3RuojLNO8D3Ie9JZXlNwlophR0CpeaM6f5f0LdKJhDOchdl8sjsGSNUkHHh4yr8YsajW0IYLH0m6rZrg/ZLm4+/LzzJEtAzakU3EZZXyzq38g4dlt4xIvw7Ux8+i5foYyxV3/losuufdRHVq4T3k+gwHyMHdeRH/ocT2ahFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156142; c=relaxed/simple;
	bh=nyMVx9701p+WNx+69cqACB2jA8RS/0DlIfpjKuxRpBc=;
	h=Date:To:From:Subject:Message-Id; b=Lb0JIJx4g8oBfCgo3zPwCFtuJC1LBvJk9Cg8sdltw5I8ZklbS5a4k5jPwArrW6xGu7xLQh1Wwhbayjp46vzGLIlf5scaAc2U2jUkLHy6eHv3DEPkV7k/rMZ0JiIMtRc5pjz2cX93OSuCvOkuouJVNfLcJ0ZK84VGjYTGxbwTBSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ak93smio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ak93smio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCBBC4CEF8;
	Fri, 14 Nov 2025 21:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156141;
	bh=nyMVx9701p+WNx+69cqACB2jA8RS/0DlIfpjKuxRpBc=;
	h=Date:To:From:Subject:From;
	b=ak93smiojkYdAb8RXvIeJXSKLFHhxKHzsu3TxqCfD4KVlP8BbLaf0nsRAVtBFtrkb
	 l/v748k5f2kZEtsGsfrJ/LJv6rRq22FTDkwTJqMNCIQJKy1bYOuIWmWGwGkFnlwUGN
	 hSDfPqBdOlJKW/hGMQlecBLRZzXKLkTT/d/StOTU=
Date: Fri, 14 Nov 2025 13:35:40 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-add-kconfig-option-to-enable-kho-by-default.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213541.CFCBBC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: add Kconfig option to enable KHO by default
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-add-kconfig-option-to-enable-kho-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-add-kconfig-option-to-enable-kho-by-default.patch

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
Subject: kho: add Kconfig option to enable KHO by default
Date: Fri, 14 Nov 2025 14:00:02 -0500

Currently, Kexec Handover must be explicitly enabled via the kernel
command line parameter `kho=on`.

For workloads that rely on KHO as a foundational requirement (such as the
upcoming Live Update Orchestrator), requiring an explicit boot parameter
adds redundant configuration steps.

Introduce CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT.  When selected, KHO
defaults to enabled.  This is equivalent to passing kho=on at boot.  The
behavior can still be disabled at runtime by passing kho=off.

Link: https://lkml.kernel.org/r/20251114190002.3311679-14-pasha.tatashin@soleen.com
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

 kernel/liveupdate/Kconfig          |   14 ++++++++++++++
 kernel/liveupdate/kexec_handover.c |    2 +-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/Kconfig~kho-add-kconfig-option-to-enable-kho-by-default
+++ a/kernel/liveupdate/Kconfig
@@ -37,4 +37,18 @@ config KEXEC_HANDOVER_DEBUGFS
 	  Also, enables inspecting the KHO fdt trees with the debugfs binary
 	  blobs.
 
+config KEXEC_HANDOVER_ENABLE_DEFAULT
+	bool "Enable kexec handover by default"
+	depends on KEXEC_HANDOVER
+	help
+	  Enable Kexec Handover by default. This avoids the need to
+	  explicitly pass 'kho=on' on the kernel command line.
+
+	  This is useful for systems where KHO is a prerequisite for other
+	  features, such as Live Update, ensuring the mechanism is always
+	  active.
+
+	  The default behavior can still be overridden at boot time by
+	  passing 'kho=off'.
+
 endmenu
--- a/kernel/liveupdate/kexec_handover.c~kho-add-kconfig-option-to-enable-kho-by-default
+++ a/kernel/liveupdate/kexec_handover.c
@@ -52,7 +52,7 @@ union kho_page_info {
 
 static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
 
-static bool kho_enable __ro_after_init;
+static bool kho_enable __ro_after_init = IS_ENABLED(CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT);
 
 bool kho_is_enabled(void)
 {
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

