From: akpm@linux-foundation.org
Subject: - sis-drm-fix-a-pointer-cast-warning.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:23 -0700
Message-ID: <200808042006.m74K6NRx027686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760937AbYHDUHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     SiS DRM: fix a pointer cast warning
has been removed from the -mm tree.  Its filename was
     sis-drm-fix-a-pointer-cast-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SiS DRM: fix a pointer cast warning
From: David Howells <dhowells@redhat.com>

Fix a pointer cast warning in the SIS DRM code.

This was introduced in patch ce65a44de07f73ceda1749812b75086b7add408d.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/sis/sis_mm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/sis/sis_mm.c~sis-drm-fix-a-pointer-cast-warning drivers/gpu/drm/sis/sis_mm.c
--- a/drivers/gpu/drm/sis/sis_mm.c~sis-drm-fix-a-pointer-cast-warning
+++ a/drivers/gpu/drm/sis/sis_mm.c
@@ -57,7 +57,7 @@ static void *sis_sman_mm_allocate(void *
 	if (req.size == 0)
 		return NULL;
 	else
-		return (void *)~req.offset;
+		return (void *)(unsigned long)~req.offset;
 }
 
 static void sis_sman_mm_free(void *private, void *ref)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
mutex-subsystem-synchro-test-module.patch

