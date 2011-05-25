From: akpm@linux-foundation.org
Subject: [merged] include-linux-gfph-convert-bug_on-into-vm_bug_on.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:57 -0700
Message-ID: <201105252026.p4PKQKWk014487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756297Ab1EYUsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/gfp.h: convert BUG_ON() into VM_BUG_ON()
has been removed from the -mm tree.  Its filename was
     include-linux-gfph-convert-bug_on-into-vm_bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/gfp.h: convert BUG_ON() into VM_BUG_ON()
From: Dave Hansen <dave@linux.vnet.ibm.com>

VM_BUG_ON() if effectively a BUG_ON() undef #ifdef CONFIG_DEBUG_VM.  That
is exactly what we have here now, and two different folks have suggested
doing it this way.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/gfp.h~include-linux-gfph-convert-bug_on-into-vm_bug_on include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-gfph-convert-bug_on-into-vm_bug_on
+++ a/include/linux/gfp.h
@@ -249,9 +249,7 @@ static inline enum zone_type gfp_zone(gf
 
 	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
 					 ((1 << ZONES_SHIFT) - 1);
-#ifdef CONFIG_DEBUG_VM
-	BUG_ON((GFP_ZONE_BAD >> bit) & 1);
-#endif
+	VM_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	return z;
 }
 
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-increase-reclaim_distance-to-30.patch
flex_array-avoid-divisions-when-accessing-elements.patch

