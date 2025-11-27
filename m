Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7FB321457
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282372; cv=none; b=TJHk4ujGX9Rpg01a+JzbP+Eqaa9euiP3H4sk06dY+x2Ko9StvzBL/5ZDI8mcYF2p0xqMFKNfiBG5g2sFX8oRxEhvVq+xd8yly5df59a0pYofN9DdFpRkoZ1mDeoBr3iD/kpAEpl/XasoisXqkSEMDxFDZff5ZBpwrW1bp716lu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282372; c=relaxed/simple;
	bh=D0YvsRQRVyHouHkXNRtNiHFSEwlSqhwdhqzllBka3DY=;
	h=Date:To:From:Subject:Message-Id; b=OkCP4/+qu35C5FDO1S0YDtgCfxz7+n0u6OkvbNVQvSK/smEMh6MqynMgW0fOmx8b+e+Pr7fYjnZDlneCBE4JxQFiEqqLysuBuuuKY4XpBvBL55BVYRBk/F0itgIZyMv4Lim1JtYpY8XAalCZwTAZVEECRGAL2dIFGJ/mCovyow0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dji2UFF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dji2UFF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BCFC4CEF8;
	Thu, 27 Nov 2025 22:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282371;
	bh=D0YvsRQRVyHouHkXNRtNiHFSEwlSqhwdhqzllBka3DY=;
	h=Date:To:From:Subject:From;
	b=Dji2UFF64F7VIl8TnSuBj1ORrOJhVI2SYHmtPBtKjB3G11zr4UWQqEwwHjq2SrC9z
	 bGwr4DutDWXT0NCIU5G8+AuHDXpMdnPoHN1/qYQpyUph5R/hTHfIiTV1qlom2zoUGQ
	 zS8T90iNLrtVFaMqtmE1rq07qJFihvly5pa7/AQU=
Date: Thu, 27 Nov 2025 14:26:10 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-fix-misleading-log-message-in-kho_populate.patch removed from -mm tree
Message-Id: <20251127222610.E1BCFC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix misleading log message in kho_populate()
has been removed from the -mm tree.  Its filename was
     kho-fix-misleading-log-message-in-kho_populate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

