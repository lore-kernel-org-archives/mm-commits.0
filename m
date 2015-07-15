From: akpm@linux-foundation.org
Subject: + dma-debug-skip-debug_dma_assert_idle-when-disabled.patch added
 to -mm tree
Date: Wed, 15 Jul 2015 13:35:12 -0700
Message-ID: <55a6c400.3HCwmKNay0bDHa5d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbbGOUfN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 16:35:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haggaie@mellanox.com, JBottomley@Parallels.com, dan.j.williams@intel.com, f.fainelli@gmail.com, horia.geanta@freescale.com, jkosina@suse.cz, joro@8bytes.org, rmk+kernel@arm.linux.org.uk, sebott@linux.vnet.ibm.com, stable@vger.kernel.org, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: skip debug_dma_assert_idle() when disabled
has been added to the -mm tree.  Its filename is
     dma-debug-skip-debug_dma_assert_idle-when-disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-skip-debug_dma_assert_idle-when-disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-skip-debug_dma_assert_idle-when-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Haggai Eran <haggaie@mellanox.com>
Subject: dma-debug: skip debug_dma_assert_idle() when disabled

If dma-debug is disabled due to a memory error, DMA unmaps do not affect
the dma_active_cacheline radix tree anymore, and debug_dma_assert_idle()
can print false warnings.

Disable debug_dma_assert_idle() when dma_debug_disabled() is true.

Signed-off-by: Haggai Eran <haggaie@mellanox.com>
Fixes: 0abdd7a81b7e ("dma-debug: introduce debug_dma_assert_idle()")
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Horia Geanta <horia.geanta@freescale.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/dma-debug.c~dma-debug-skip-debug_dma_assert_idle-when-disabled lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-skip-debug_dma_assert_idle-when-disabled
+++ a/lib/dma-debug.c
@@ -574,6 +574,9 @@ void debug_dma_assert_idle(struct page *
 	unsigned long flags;
 	phys_addr_t cln;
 
+	if (dma_debug_disabled())
+		return;
+
 	if (!page)
 		return;
 
_

Patches currently in -mm which might be from haggaie@mellanox.com are

dma-debug-skip-debug_dma_assert_idle-when-disabled.patch

