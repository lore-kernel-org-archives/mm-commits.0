From: akpm@linux-foundation.org
Subject: +
 mm-slubc-fix-wrong-address-during-slab-padding-restoration.patch added to
 -mm tree
Date: Tue, 23 Jan 2018 14:50:49 -0800
Message-ID: <5a67bc49.Kam1OpwRc4xeGY1w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932364AbeAWWuv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 Jan 2018 17:50:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balasubramani_vivekanandan@mentor.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: fix wrong address during slab padding restoration
has been added to the -mm tree.  Its filename is
     mm-slubc-fix-wrong-address-during-slab-padding-restoration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slubc-fix-wrong-address-during-slab-padding-restoration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slubc-fix-wrong-address-during-slab-padding-restoration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slubc-fix-wrong-address-during-slab-padding-restoration.patch

