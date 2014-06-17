From: akpm@linux-foundation.org
Subject: + slub-use-new-node-functions-fix.patch added to -mm tree
Date: Tue, 17 Jun 2014 14:17:58 -0700
Message-ID: <53a0b086.H1jhIgKnvkGLLs4q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965387AbaFQVST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, cl@gentwo.org


The patch titled
     Subject: slub-use-new-node-functions-fix
has been added to the -mm tree.  Its filename is
     slub-use-new-node-functions-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-use-new-node-functions-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-use-new-node-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@gentwo.org>
Subject: slub-use-new-node-functions-fix

On Wed, 11 Jun 2014, David Rientjes wrote:

> > +	for_each_kmem_cache_node(s, node, n) {
> >
> >  		free_partial(s, n);
> >  		if (n->nr_partial || slabs_node(s, node))
>
> Newline not removed?

Ok got through the file and removed all the lines after
for_each_kmem_cache_node.

>
> > @@ -3407,11 +3401,7 @@ int __kmem_cache_shrink(struct kmem_cach
> >  		return -ENOMEM;
> >
> >  	flush_all(s);
> > -	for_each_node_state(node, N_NORMAL_MEMORY) {
> > -		n = get_node(s, node);
> > -
> > -		if (!n->nr_partial)
> > -			continue;
> > +	for_each_kmem_cache_node(s, node, n) {
> >
> >  		for (i = 0; i < objects; i++)
> >  			INIT_LIST_HEAD(slabs_by_inuse + i);
>
> Is there any reason not to keep the !n->nr_partial check to avoid taking
> n->list_lock unnecessarily?

No this was simply a mistake the check needs to be preserved.

Subject: slub: Fix up earlier patch

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-use-new-node-functions-fix mm/slub.c
--- a/mm/slub.c~slub-use-new-node-functions-fix
+++ a/mm/slub.c
@@ -3216,7 +3216,6 @@ static inline int kmem_cache_close(struc
 	flush_all(s);
 	/* Attempt to free all objects */
 	for_each_kmem_cache_node(s, node, n) {
-
 		free_partial(s, n);
 		if (n->nr_partial || slabs_node(s, node))
 			return 1;
@@ -3402,6 +3401,8 @@ int __kmem_cache_shrink(struct kmem_cach
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
+		if (!n->nr_partial)
+			continue;
 
 		for (i = 0; i < objects; i++)
 			INIT_LIST_HEAD(slabs_by_inuse + i);
@@ -4334,7 +4335,6 @@ static ssize_t show_slab_objects(struct
 		struct kmem_cache_node *n;
 
 		for_each_kmem_cache_node(s, node, n) {
-
 			if (flags & SO_TOTAL)
 				x = count_partial(n, count_total);
 			else if (flags & SO_OBJECTS)
@@ -5324,7 +5324,6 @@ void get_slabinfo(struct kmem_cache *s,
 	struct kmem_cache_node *n;
 
 	for_each_kmem_cache_node(s, node, n) {
