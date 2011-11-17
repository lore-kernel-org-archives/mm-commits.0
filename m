From: akpm@linux-foundation.org
Subject: [merged] slab-add-taint-flag-outputting-to-debug-paths.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:57 -0800
Message-ID: <201111172021.pAHKLvig018696@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bw0-f74.google.com ([209.85.214.74]:41741 "EHLO
	mail-bw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1KQUWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:22:01 -0500
Received: by bkat2 with SMTP id t2so53126bka.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: add taint flag outputting to debug paths.
has been removed from the -mm tree.  Its filename was
     slab-add-taint-flag-outputting-to-debug-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: slab: add taint flag outputting to debug paths.

When we get corruption reports, it's useful to see if the kernel was
tainted, to rule out problems we can't do anything about.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~slab-add-taint-flag-outputting-to-debug-paths mm/slab.c
--- a/mm/slab.c~slab-add-taint-flag-outputting-to-debug-paths
+++ a/mm/slab.c
@@ -1941,8 +1941,8 @@ static void check_poison_obj(struct kmem
 			/* Print header */
 			if (lines == 0) {
 				printk(KERN_ERR
-					"Slab corruption: %s start=%p, len=%d\n",
-					cachep->name, realobj, size);
+					"Slab corruption (%s): %s start=%p, len=%d\n",
+					print_tainted(), cachep->name, realobj, size);
 				print_objinfo(cachep, objp, 0);
 			}
 			/* Hexdump the affected line */
@@ -3051,8 +3051,9 @@ static void check_slabp(struct kmem_cach
 	if (entries != cachep->num - slabp->inuse) {
 bad:
 		printk(KERN_ERR "slab: Internal list corruption detected in "
-				"cache '%s'(%d), slabp %p(%d). Hexdump:\n",
-			cachep->name, cachep->num, slabp, slabp->inuse);
+			"cache '%s'(%d), slabp %p(%d). Tainted(%s). Hexdump:\n",
+			cachep->name, cachep->num, slabp, slabp->inuse,
+			print_tainted());
 		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1, slabp,
 			sizeof(*slabp) + cachep->num * sizeof(kmem_bufctl_t),
 			1);
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch

