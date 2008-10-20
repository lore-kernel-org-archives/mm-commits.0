From: akpm@linux-foundation.org
Subject: - kdump-use-is_kdump_kernel-in-sba_init.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:07 -0700
Message-ID: <200810202037.m9KKb7rd011544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbYJTUqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kdump: use is_kdump_kernel() in sba_init()
has been removed from the -mm tree.  Its filename was
     kdump-use-is_kdump_kernel-in-sba_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: use is_kdump_kernel() in sba_init()
From: Simon Horman <horms@verge.net.au>

o Make use of is_kdump_kernel() rather than checking elfcorehdr_addr directly.

o Remove CONFIG_CRASH_DUMP as is_kdump_kernel() is safe to call anywhere

o Remove CONFIG_PROC_FS as it is bogus, the check
  should occur regardless of if CONFIG_PROC_FS is set or not.

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/ia64/hp/common/sba_iommu.c~kdump-use-is_kdump_kernel-in-sba_init arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~kdump-use-is_kdump_kernel-in-sba_init
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -2070,14 +2070,13 @@ sba_init(void)
 	if (!ia64_platform_is("hpzx1") && !ia64_platform_is("hpzx1_swiotlb"))
 		return 0;
 
-#if defined(CONFIG_IA64_GENERIC) && defined(CONFIG_CRASH_DUMP) && \
-        defined(CONFIG_PROC_FS)
+#if defined(CONFIG_IA64_GENERIC)
 	/* If we are booting a kdump kernel, the sba_iommu will
 	 * cause devices that were not shutdown properly to MCA
 	 * as soon as they are turned back on.  Our only option for
 	 * a successful kdump kernel boot is to use the swiotlb.
 	 */
-	if (elfcorehdr_addr < ELFCORE_ADDR_MAX) {
+	if (is_kdump_kernel()) {
 		if (swiotlb_late_init_with_default_size(64 * (1<<20)) != 0)
 			panic("Unable to initialize software I/O TLB:"
 				  " Try machvec=dig boot option");
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch

