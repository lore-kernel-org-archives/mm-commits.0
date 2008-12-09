From: akpm@linux-foundation.org
Subject: - parisc-lib-make-code-static.patch removed from -mm tree
Date: Tue, 09 Dec 2008 10:45:49 -0800
Message-ID: <200812091845.mB9Ijnik027108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371AbYLISqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 13:46:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     parisc/lib/: make code static
has been removed from the -mm tree.  Its filename was
     parisc-lib-make-code-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc/lib/: make code static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global code static:

- iomap.c: struct iomap_ops[]
- memcpy.c: pa_memcpy()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/lib/iomap.c  |    2 +-
 arch/parisc/lib/memcpy.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/parisc/lib/iomap.c~parisc-lib-make-code-static arch/parisc/lib/iomap.c
--- a/arch/parisc/lib/iomap.c~parisc-lib-make-code-static
+++ a/arch/parisc/lib/iomap.c
@@ -261,7 +261,7 @@ static const struct iomap_ops iomem_ops 
 	iomem_write32r,
 };
 
-const struct iomap_ops *iomap_ops[8] = {
+static const struct iomap_ops *iomap_ops[8] = {
 	[0] = &ioport_ops,
 	[7] = &iomem_ops
 };
diff -puN arch/parisc/lib/memcpy.c~parisc-lib-make-code-static arch/parisc/lib/memcpy.c
--- a/arch/parisc/lib/memcpy.c~parisc-lib-make-code-static
+++ a/arch/parisc/lib/memcpy.c
@@ -275,7 +275,7 @@ handle_store_error:
 
 
 /* Returns 0 for success, otherwise, returns number of bytes not transferred. */
-unsigned long pa_memcpy(void *dstp, const void *srcp, unsigned long len)
+static unsigned long pa_memcpy(void *dstp, const void *srcp, unsigned long len)
 {
 	register unsigned long src, dst, t1, t2, t3;
 	register unsigned char *pcs, *pcd;
_

Patches currently in -mm which might be from bunk@kernel.org are

linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m68knommu-set-no_dma.patch
reiser4.patch

