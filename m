From: akpm@linux-foundation.org
Subject: - frv-no-zone_dma.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:10 -0800
Message-ID: <200703020506.l2256AN2000771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42272 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422715AbXCBFG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FRV: No ZONE_DMA
has been removed from the -mm tree.  Its filename was
     frv-no-zone_dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: No ZONE_DMA
From: David Howells <dhowells@redhat.com>

FRV does not require a ZONE_DMA, so all DMA'able pages that aren't highmem
should be in ZONE_NORMAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/frv/mm/init.c~frv-no-zone_dma arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~frv-no-zone_dma
+++ a/arch/frv/mm/init.c
@@ -126,8 +126,7 @@ void __init paging_init(void)
 
 	/* distribute the allocatable pages across the various zones and pass them to the allocator
 	 */
-	zones_size[ZONE_DMA]     = max_low_pfn - min_low_pfn;
-	zones_size[ZONE_NORMAL]  = 0;
+	zones_size[ZONE_NORMAL]  = max_low_pfn - min_low_pfn;
 #ifdef CONFIG_HIGHMEM
 	zones_size[ZONE_HIGHMEM] = num_physpages - num_mappedpages;
 #endif
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch
