From: akpm@linux-foundation.org
Subject: + slub-reduce-duplicate-creation-on-the-first-object.patch added
 to -mm tree
Date: Tue, 24 Jun 2014 14:56:55 -0700
Message-ID: <53a9f427.Eq83sqa+5UAuINPd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFXV44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: reduce duplicate creation on the first object
has been added to the -mm tree.  Its filename is
     slub-reduce-duplicate-creation-on-the-first-object.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-reduce-duplicate-creation-on-the-first-object.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-reduce-duplicate-creation-on-the-first-object.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slub-reduce-duplicate-creation-on-the-first-object.patch

