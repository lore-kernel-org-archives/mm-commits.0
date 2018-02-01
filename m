From: akpm@linux-foundation.org
Subject: [merged]
 mm-slubc-fix-wrong-address-during-slab-padding-restoration.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:30:19 -0800
Message-ID: <20180201193019.MgUE9gb-X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752839AbeBATaV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:30:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balasubramani_vivekanandan@mentor.com, cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm/slub.c: fix wrong address during slab padding restoration
has been removed from the -mm tree.  Its filename was
     mm-slubc-fix-wrong-address-during-slab-padding-restoration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
Subject: mm/slub.c: fix wrong address during slab padding restoration

Start address calculated for slab padding restoration was wrong.  Wrong
address would point to some section before padding and could cause
corruption

Link: http://lkml.kernel.org/r/1516604578-4577-1-git-send-email-balasubramani_vivekanandan@mentor.com
Signed-off-by: Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~mm-slubc-fix-wrong-address-during-slab-padding-restoration mm/slub.c
--- a/mm/slub.c~mm-slubc-fix-wrong-address-during-slab-padding-restoration
+++ a/mm/slub.c
@@ -838,6 +838,7 @@ static int slab_pad_check(struct kmem_ca
 	u8 *start;
 	u8 *fault;
 	u8 *end;
+	u8 *pad;
 	int length;
 	int remainder;
 
@@ -851,8 +852,9 @@ static int slab_pad_check(struct kmem_ca
 	if (!remainder)
 		return 1;
 
+	pad = end - remainder;
 	metadata_access_enable();
-	fault = memchr_inv(end - remainder, POISON_INUSE, remainder);
+	fault = memchr_inv(pad, POISON_INUSE, remainder);
 	metadata_access_disable();
 	if (!fault)
 		return 1;
@@ -860,9 +862,9 @@ static int slab_pad_check(struct kmem_ca
 		end--;
 
 	slab_err(s, page, "Padding overwritten. 0x%p-0x%p", fault, end - 1);
-	print_section(KERN_ERR, "Padding ", end - remainder, remainder);
+	print_section(KERN_ERR, "Padding ", pad, remainder);
 
-	restore_bytes(s, "slab padding", POISON_INUSE, end - remainder, end);
+	restore_bytes(s, "slab padding", POISON_INUSE, fault, end);
 	return 0;
 }
 
_

Patches currently in -mm which might be from balasubramani_vivekanandan@mentor.com are


