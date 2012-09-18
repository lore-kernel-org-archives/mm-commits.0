From: akpm@linux-foundation.org
Subject: [merged] slab-fix-starting-index-for-finding-another-object.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:05:01 -0700
Message-ID: <20120918190501.CCD181E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:41620 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2IRTFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:05:02 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so27127vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:05:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, chuck.lever@oracle.com, davem@davemloft.net, mgorman@suse.de, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix starting index for finding another object
has been removed from the -mm tree.  Its filename was
     slab-fix-starting-index-for-finding-another-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: slab: fix starting index for finding another object

In array cache, there is a object at index 0, check it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-fix-starting-index-for-finding-another-object mm/slab.c
--- a/mm/slab.c~slab-fix-starting-index-for-finding-another-object
+++ a/mm/slab.c
@@ -983,7 +983,7 @@ static void *__ac_get_obj(struct kmem_ca
 		}
 
 		/* The caller cannot use PFMEMALLOC objects, find another one */
-		for (i = 1; i < ac->avail; i++) {
+		for (i = 0; i < ac->avail; i++) {
 			/* If a !PFMEMALLOC object is found, swap them */
 			if (!is_obj_pfmemalloc(ac->entry[i])) {
 				objp = ac->entry[i];
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
linux-next.patch

