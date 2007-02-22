From: akpm@linux-foundation.org
Subject: + frv-no-zone_dma.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:04:54 -0800
Message-ID: <200702220004.l1M04s8g030755@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58877 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945914AbXBVAFG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:05:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: No ZONE_DMA
has been added to the -mm tree.  Its filename is
     frv-no-zone_dma.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: No ZONE_DMA
From: David Howells <dhowells@redhat.com>

FRV does not require a ZONE_DMA, so all DMA'able pages that aren't highmem
should be in ZONE_NORMAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/init.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

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

frv-no-zone_dma.patch
git-cpufreq.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
git-parisc.patch
frv-missing-error-defs.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch
