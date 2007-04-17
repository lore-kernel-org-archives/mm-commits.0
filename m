From: akpm@linux-foundation.org
Subject: - cache_k8_northbridges-overflows-beyond-allocation.patch removed from -mm tree
Date: Mon, 16 Apr 2007 22:20:02 -0700
Message-ID: <200704170520.l3H5K2r7021039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36282 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031100AbXDQFVW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 01:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@gmail.com, ak@suse.de, pbadari@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cache_k8_northbridges() overflows beyond allocation
has been removed from the -mm tree.  Its filename was
     cache_k8_northbridges-overflows-beyond-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cache_k8_northbridges() overflows beyond allocation
From: Badari Pulavarty <pbadari@gmail.com>

cache_k8_northbridges() is storing config values to incorrect locations
(in flush_words) and also its overflowing beyond the allocation, causing
slab verification failures.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>a
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/k8.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/k8.c~cache_k8_northbridges-overflows-beyond-allocation arch/x86_64/kernel/k8.c
--- a/arch/x86_64/kernel/k8.c~cache_k8_northbridges-overflows-beyond-allocation
+++ a/arch/x86_64/kernel/k8.c
@@ -61,8 +61,8 @@ int cache_k8_northbridges(void)
 	dev = NULL;
 	i = 0;
 	while ((dev = next_k8_northbridge(dev)) != NULL) {
-		k8_northbridges[i++] = dev;
-		pci_read_config_dword(dev, 0x9c, &flush_words[i]);
+		k8_northbridges[i] = dev;
+		pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
 	}
 	k8_northbridges[i] = NULL;
 	return 0;
_

Patches currently in -mm which might be from pbadari@gmail.com are

origin.patch
