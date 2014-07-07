From: akpm@linux-foundation.org
Subject: [to-be-updated]
 slub-reduce-duplicate-creation-on-the-first-object.patch removed from -mm
 tree
Date: Mon, 07 Jul 2014 12:08:43 -0700
Message-ID: <53baf03b.cIsEsnqr1zFCieCR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:34292 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaGGTIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 15:08:44 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1010718obb.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 12:08:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: reduce duplicate creation on the first object
has been removed from the -mm tree.  Its filename was
     slub-reduce-duplicate-creation-on-the-first-object.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: slub: reduce duplicate creation on the first object

When a kmem_cache is created with ctor, each object in the kmem_cache will
be initialized before use.  In the slub implementation, the first object
will be initialized twice.

This patch avoids the duplication of initialization of the first object.

Fixes commit 7656c72b5a63: ("SLUB: add macros for scanning objects in a
slab").

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-reduce-duplicate-creation-on-the-first-object mm/slub.c
--- a/mm/slub.c~slub-reduce-duplicate-creation-on-the-first-object
+++ a/mm/slub.c
@@ -1403,7 +1403,7 @@ static struct page *new_slab(struct kmem
 		memset(start, POISON_INUSE, PAGE_SIZE << order);
 
 	last = start;
-	for_each_object(p, s, start, page->objects) {
+	for_each_object(p, s, start + s->size, page->objects - 1) {
 		setup_object(s, page, last);
 		set_freepointer(s, last, p);
 		last = p;
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are


