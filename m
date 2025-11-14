Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BC327A904
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156108; cv=none; b=aBxpR4laZ66sUI7BSow3XjMTkkQoe9vqGnPX+cUf2NtrMorx/Bh1d2rnqu/nWE9TRc45pOtP2S1ze/dmY9PCB0Oel7n+6pRMbOMTsqvwUWwZ5hab3L6XPgDpT/OVql4SKoD3U4oJTkyOlEmWmw2TrAhzKC6ug/60KlnBHUnmPl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156108; c=relaxed/simple;
	bh=QIVCqaCUq3hAaHKnfOdBeqKnFx+yTCceJi8hZpGmXbE=;
	h=Date:To:From:Subject:Message-Id; b=eBRbVQRZaprlLyO3eQ+938MrE1+krqBbs/rPNe08MJtAscnnPsq3q4FQ7I9J8CEGpApNY2Opax8WwxN7miPt9qLSF0ePX+/6SeiInkYnb6RhYuQh2B6spjKZY5sJxW2ysae+sbAcH6BaXo0czgJ8ECLV7reAuXkAcIrYP3h5fxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cv+IK8ta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cv+IK8ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17437C19421;
	Fri, 14 Nov 2025 21:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156107;
	bh=QIVCqaCUq3hAaHKnfOdBeqKnFx+yTCceJi8hZpGmXbE=;
	h=Date:To:From:Subject:From;
	b=cv+IK8taLFfJPnybWenD0V6IvJY1yU0EK/vFuge159qUqXRGVNJFkh3f+cndg9ghC
	 /swbboj4HKyqeqyUA0GVvIYlPzMNizw9x6jUhUXfxr4DQm7ZQMmyJc/VvJjBvVcYpy
	 qC4305WOoOGPOLBZ8QxwtXTumkMXcYPkmlBzc19I=
Date: Fri, 14 Nov 2025 13:35:05 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-misleading-log-message-in-kho_populate.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213507.17437C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix misleading log message in kho_populate()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-fix-misleading-log-message-in-kho_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-misleading-log-message-in-kho_populate.patch

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
Subject: kho: fix misleading log message in kho_populate()
Date: Fri, 14 Nov 2025 13:59:50 -0500

Patch series "kho: simplify state machine and enable dynamic updates", v2.

This patch series refactors the Kexec Handover subsystem to transition
from a rigid, state-locked model to a dynamic, re-entrant architecture. 
It also introduces usability improvements.

Motivation
Currently, KHO relies on a strict state machine where memory
preservation is locked upon finalization. If a change is required, the
user must explicitly "abort" to reset the state. Additionally, the kexec
image cannot be loaded until KHO is finalized, and the FDT is rebuilt
from scratch on every finalization.

This series simplifies this workflow to support "load early, finalize
late" scenarios.

Key Changes

State Machine Simplification:
- Removed kho_abort(). kho_finalize() is now re-entrant; calling it a
  second time automatically flushes the previous serialized state and
  generates a fresh one.

- Removed kho_out.finalized checks from preservation APIs, allowing
  drivers to add/remove pages even after an initial finalization.

- Decoupled kexec_file_load from KHO finalization. The KHO FDT physical
  address is now stable from boot, allowing the kexec image to be loaded
  before the handover metadata is finalized.

FDT Management:
- The FDT is now updated in-place dynamically when subtrees are added or
  removed, removing the need for complex reconstruction logic.

- The output FDT is always exposed in debugfs (initialized and zeroed at
  boot), improving visibility and debugging capabilities throughout the
  system lifecycle.

- Removed the redundant global preserved_mem_map pointer, establishing
  the FDT property as the single source of truth.

New Features & API Enhancements:
- High-Level Allocators: Introduced kho_alloc_preserve() and friends to
  reduce boilerplate for drivers that need to allocate, preserve, and
  eventually restore simple memory buffers.

- Configuration: Added CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT to allow KHO
  to be active by default without requiring the kho=on command line
  parameter.

Fixes:
- Fixed potential alignment faults when accessing 64-bit FDT properties.

- Fixed the lifecycle of the FDT folio preservation (now preserved once
  at init).


This patch (of 13):

The log message in kho_populate() currently states "Will skip init for
some devices".  This implies that Kexec Handover always involves skipping
device initialization.

However, KHO is a generic mechanism used to preserve kernel memory across
reboot for various purposes, such as memfd, telemetry, or reserve_mem. 
Skipping device initialization is a specific property of live update
drivers using KHO, not a property of the mechanism itself.

Remove the misleading suffix to accurately reflect the generic nature of
KHO discovery.

Link: https://lkml.kernel.org/r/20251114190002.3311679-2-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-misleading-log-message-in-kho_populate
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1470,7 +1470,7 @@ void __init kho_populate(phys_addr_t fdt
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data. Will skip init for some devices\n");
+	pr_info("found kexec handover data.\n");
 
 out:
 	if (fdt)
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

