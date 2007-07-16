From: akpm@linux-foundation.org
Subject: - make-proc-slabinfo-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:47 -0700
Message-ID: <200707162048.l6GKmlcg001093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763079AbXGPUtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, adobriyan@sw.ru, clameter@sgi.com, penberg@cs.helsinki.fi, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make /proc/slabinfo use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-proc-slabinfo-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make /proc/slabinfo use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

This entry prints a header in .start callback.  This is OK, but the more
elegant solution would be to move this into the .show callback and use
seq_list_start_head() in .start one.

I have left it as is in order to make the patch just switch to new API and
noting more.

[adobriyan@sw.ru: Wrong pointer was used as kmem_cache pointer]
Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff -puN mm/slab.c~make-proc-slabinfo-use-seq_list_xxx-helpers mm/slab.c
--- a/mm/slab.c~make-proc-slabinfo-use-seq_list_xxx-helpers
+++ a/mm/slab.c
@@ -4157,26 +4157,17 @@ static void print_slabinfo_header(struct
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	loff_t n = *pos;
-	struct list_head *p;
 
 	mutex_lock(&cache_chain_mutex);
 	if (!n)
 		print_slabinfo_header(m);
-	p = cache_chain.next;
-	while (n--) {
-		p = p->next;
-		if (p == &cache_chain)
-			return NULL;
-	}
-	return list_entry(p, struct kmem_cache, next);
+
+	return seq_list_start(&cache_chain, *pos);
 }
 
 static void *s_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	struct kmem_cache *cachep = p;
-	++*pos;
-	return cachep->next.next == &cache_chain ?
-		NULL : list_entry(cachep->next.next, struct kmem_cache, next);
+	return seq_list_next(p, &cache_chain, pos);
 }
 
 static void s_stop(struct seq_file *m, void *p)
@@ -4186,7 +4177,7 @@ static void s_stop(struct seq_file *m, v
 
 static int s_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *cachep = p;
+	struct kmem_cache *cachep = list_entry(p, struct kmem_cache, next);
 	struct slab *slabp;
 	unsigned long active_objs;
 	unsigned long num_objs;
@@ -4355,17 +4346,8 @@ ssize_t slabinfo_write(struct file *file
 
 static void *leaks_start(struct seq_file *m, loff_t *pos)
 {
-	loff_t n = *pos;
-	struct list_head *p;
-
 	mutex_lock(&cache_chain_mutex);
-	p = cache_chain.next;
-	while (n--) {
-		p = p->next;
-		if (p == &cache_chain)
-			return NULL;
-	}
-	return list_entry(p, struct kmem_cache, next);
+	return seq_list_start(&cache_chain, *pos);
 }
 
 static inline int add_caller(unsigned long *n, unsigned long v)
@@ -4430,7 +4412,7 @@ static void show_symbol(struct seq_file 
 
 static int leaks_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *cachep = p;
+	struct kmem_cache *cachep = list_entry(p, struct kmem_cache, next);
 	struct slab *slabp;
 	struct kmem_list3 *l3;
 	const char *name;
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
