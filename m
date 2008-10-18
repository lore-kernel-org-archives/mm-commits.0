From: akpm@linux-foundation.org
Subject: - agp-reduce-extraneous-pci-posting-reads-during-intel-agp-initialization.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:50 -0700
Message-ID: <200810182320.m9INKovI029838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948AbYJRXVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keithp@keithp.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     agp: reduce extraneous PCI posting reads during Intel AGP initialization
has been removed from the -mm tree.  Its filename was
     agp-reduce-extraneous-pci-posting-reads-during-intel-agp-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: agp: reduce extraneous PCI posting reads during Intel AGP initialization
From: Keith Packard <keithp@keithp.com>

Instead of doing a posting read after each GTT entry update, do a single
on= e at the end of the writes.  This should reduce boot time a tiny
amount by avoiding a lot of extra uncached reads.

Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~agp-reduce-extraneous-pci-posting-reads-during-intel-agp-initialization drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~agp-reduce-extraneous-pci-posting-reads-during-intel-agp-initialization
+++ a/drivers/char/agp/intel-agp.c
@@ -214,8 +214,8 @@ static int intel_i810_configure(void)
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i = 0; i < current_size->num_entries; i++) {
 			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
-			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI posting. */
 		}
+		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI posting. */
 	}
 	global_cache_flush();
 	return 0;
@@ -773,8 +773,8 @@ static int intel_i830_configure(void)
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
 			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
-			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI Posting. */
 		}
+		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI Posting. */
 	}
 
 	global_cache_flush();
@@ -989,8 +989,8 @@ static int intel_i915_configure(void)
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
 			writel(agp_bridge->scratch_page, intel_private.gtt+i);
-			readl(intel_private.gtt+i);	/* PCI Posting. */
 		}
+		readl(intel_private.gtt+i-1);	/* PCI Posting. */
 	}
 
 	global_cache_flush();
_

Patches currently in -mm which might be from keithp@keithp.com are

origin.patch

