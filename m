From: akpm@linux-foundation.org
Subject: - make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:36:08 -0700
Message-ID: <200707092036.l69Ka93X009829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368AbXGIUhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, clameter@sgi.com, penberg@cs.helsinki.fi, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Fix /proc/slab_allocators re seq_list_next() conversion
has been removed from the -mm tree.  Its filename was
     make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch

This patch was dropped because it was folded into make-proc-slabinfo-use-seq_list_xxx-helpers.patch

------------------------------------------------------
Subject: Fix /proc/slab_allocators re seq_list_next() conversion
From: Alexey Dobriyan <adobriyan@sw.ru>

Wrong pointer was used as kmem_cache pointer.

[Here /proc/slab_allocators appears as empty file, but it's just me, probably]

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Pavel Emelianov <xemul@openvz.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~make-proc-slabinfo-use-seq_list_xxx-helpers-fix mm/slab.c
--- a/mm/slab.c~make-proc-slabinfo-use-seq_list_xxx-helpers-fix
+++ a/mm/slab.c
@@ -4412,7 +4412,7 @@ static void show_symbol(struct seq_file 
 
 static int leaks_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *cachep = p;
+	struct kmem_cache *cachep = list_entry(p, struct kmem_cache, next);
 	struct slab *slabp;
 	struct kmem_list3 *l3;
 	const char *name;
_

Patches currently in -mm which might be from adobriyan@sw.ru are

make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
seq_file-more-atomicity-in-traverse.patch
gitignore-update.patch
