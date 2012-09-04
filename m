From: akpm@linux-foundation.org
Subject: + slab-fix-starting-index-for-finding-another-object.patch added to -mm tree
Date: Tue, 04 Sep 2012 13:44:40 -0700
Message-ID: <20120904204441.4BC9A10004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:43119 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab2IDUom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 16:44:42 -0400
Received: by ggnu1 with SMTP id u1so767472ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 13:44:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, chuck.lever@oracle.com, davem@davemloft.net, mgorman@suse.de, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: slab: fix starting index for finding another object
has been added to the -mm tree.  Its filename is
     slab-fix-starting-index-for-finding-another-object.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slab-do-clearslabpfmemalloc-for-all-pages-of-slab.patch
slab-fix-starting-index-for-finding-another-object.patch
slub-consider-pfmemalloc_match-in-get_partial_node.patch
include-net-sockh-squelch-compiler-warning-in-sk_rmem_schedule.patch
linux-next.patch

