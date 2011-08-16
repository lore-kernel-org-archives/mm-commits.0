From: akpm@linux-foundation.org
Subject: + slab-add-taint-flag-outputting-to-debug-paths.patch added to -mm tree
Date: Tue, 16 Aug 2011 09:41:03 -0700
Message-ID: <201108161638.p7GGcAau002991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab1HPQiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 12:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, penberg@cs.helsinki.fi


The patch titled
     slab: add taint flag outputting to debug paths.
has been added to the -mm tree.  Its filename is
     slab-add-taint-flag-outputting-to-debug-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slab: add taint flag outputting to debug paths.
From: Dave Jones <davej@redhat.com>

When we get corruption reports, it's useful to see if the kernel was
tainted, to rule out problems we can't do anything about.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~slab-add-taint-flag-outputting-to-debug-paths mm/slab.c
--- a/mm/slab.c~slab-add-taint-flag-outputting-to-debug-paths
+++ a/mm/slab.c
@@ -1887,8 +1887,8 @@ static void check_poison_obj(struct kmem
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
@@ -2987,8 +2987,8 @@ static void check_slabp(struct kmem_cach
 	if (entries != cachep->num - slabp->inuse) {
 bad:
 		printk(KERN_ERR "slab: Internal list corruption detected in "
-				"cache '%s'(%d), slabp %p(%d). Hexdump:\n",
-			cachep->name, cachep->num, slabp, slabp->inuse);
+				"cache '%s'(%d), slabp %p(%d). Tainted(%s). Hexdump:\n",
+			cachep->name, cachep->num, slabp, slabp->inuse, print_tainted());
 		for (i = 0;
 		     i < sizeof(*slabp) + cachep->num * sizeof(kmem_bufctl_t);
 		     i++) {
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
slab-add-taint-flag-outputting-to-debug-paths.patch
slub-add-taint-flag-outputting-to-debug-paths.patch
mm-output-a-list-of-loaded-modules-when-we-hit-bad_page.patch

