From: akpm@linux-foundation.org
Subject: [patch 022/114] arch/openrisc: add option to skip DMA sync as a
 part of mapping
Date: Wed, 14 Dec 2016 15:05:03 -0800
Message-ID: <5851d01f.QNrSfjtSISS+0Hxg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34490 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933070AbcLNXF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, jonas@southpole.se

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/openrisc: add option to skip DMA sync as a part of mapping

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113524.76501.87966.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/dma.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/openrisc/kernel/dma.c~arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping arch/openrisc/kernel/dma.c
--- a/arch/openrisc/kernel/dma.c~arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping
+++ a/arch/openrisc/kernel/dma.c
@@ -141,6 +141,9 @@ or1k_map_page(struct device *dev, struct
 	unsigned long cl;
 	dma_addr_t addr = page_to_phys(page) + offset;
 
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return addr;
+
 	switch (dir) {
 	case DMA_TO_DEVICE:
 		/* Flush the dcache for the requested range */
_
