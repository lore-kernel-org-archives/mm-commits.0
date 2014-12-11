From: akpm@linux-foundation.org
Subject: [merged] mm-slub-fix-format-mismatches-in-slab_err-callers.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:43 -0800
Message-ID: <5489e8af.MFXkA1i0EP3JzgFJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbaLKSzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: fix format mismatches in slab_err() callers
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-format-mismatches-in-slab_err-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: slub: fix format mismatches in slab_err() callers

Adding __printf(3, 4) to slab_err exposed following:

mm/slub.c: In function `check_slab':
mm/slub.c:852:4: warning: format `%u' expects argument of type `unsigned int', but argument 4 has type `const char *' [-Wformat=]
    s->name, page->objects, maxobj);
    ^
mm/slub.c:852:4: warning: too many arguments for format [-Wformat-extra-args]
mm/slub.c:857:4: warning: format `%u' expects argument of type `unsigned int', but argument 4 has type `const char *' [-Wformat=]
    s->name, page->inuse, page->objects);
    ^
mm/slub.c:857:4: warning: too many arguments for format [-Wformat-extra-args]

mm/slub.c: In function `on_freelist':
mm/slub.c:905:4: warning: format `%d' expects argument of type `int', but argument 5 has type `long unsigned int' [-Wformat=]
    "should be %d", page->objects, max_objects);

Fix first two warnings by removing redundant s->name.
Fix the last by changing type of max_object from unsigned long to int.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~mm-slub-fix-format-mismatches-in-slab_err-callers mm/slub.c
--- a/mm/slub.c~mm-slub-fix-format-mismatches-in-slab_err-callers
+++ a/mm/slub.c
@@ -849,12 +849,12 @@ static int check_slab(struct kmem_cache
 	maxobj = order_objects(compound_order(page), s->size, s->reserved);
 	if (page->objects > maxobj) {
 		slab_err(s, page, "objects %u > max %u",
-			s->name, page->objects, maxobj);
+			page->objects, maxobj);
 		return 0;
 	}
 	if (page->inuse > page->objects) {
 		slab_err(s, page, "inuse %u > max %u",
-			s->name, page->inuse, page->objects);
+			page->inuse, page->objects);
 		return 0;
 	}
 	/* Slab_pad_check fixes things up after itself */
@@ -871,7 +871,7 @@ static int on_freelist(struct kmem_cache
 	int nr = 0;
 	void *fp;
 	void *object = NULL;
-	unsigned long max_objects;
+	int max_objects;
 
 	fp = page->freelist;
 	while (fp && nr <= page->objects) {
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
linux-next.patch

