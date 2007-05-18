From: akpm@linux-foundation.org
Subject: + make-proc-slabinfo-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:38:02 -0700
Message-ID: <200705181738.l4IHc2r3019887@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:39750 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754958AbXERRnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, clameter@sgi.com, penberg@cs.helsinki.fi, xemul@openvz.org


The patch titled
     Make /proc/slabinfo use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-proc-slabinfo-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make /proc/slabinfo use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

This entry prints a header in .start callback.  This is OK, but the more
elegant solution would be to move this into the .show callback and use
seq_list_start_head() in .start one.

I have left it as is in order to make the patch just switch to new API and
noting more.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   28 +++++-----------------------
 1 files changed, 5 insertions(+), 23 deletions(-)

diff -puN mm/slab.c~make-proc-slabinfo-use-seq_list_xxx-helpers mm/slab.c
--- a/mm/slab.c~make-proc-slabinfo-use-seq_list_xxx-helpers
+++ a/mm/slab.c
@@ -4146,26 +4146,17 @@ static void print_slabinfo_header(struct
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
@@ -4175,7 +4166,7 @@ static void s_stop(struct seq_file *m, v
 
 static int s_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *cachep = p;
+	struct kmem_cache *cachep = list_entry(p, struct kmem_cache, next);
 	struct slab *slabp;
 	unsigned long active_objs;
 	unsigned long num_objs;
@@ -4344,17 +4335,8 @@ ssize_t slabinfo_write(struct file *file
 
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
_

Patches currently in -mm which might be from xemul@sw.ru are

make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
make-afs-use-seq_list_xxx-helpers.patch
make-atm-driver-use-seq_list_xxx-helpers.patch
make-block-layer-proc-files-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-some-network-related-proc-files-use-seq_list_xxx.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
