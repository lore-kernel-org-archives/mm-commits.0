From: akpm@osdl.org
Subject: - mm-slob-is-broken-by-recent-cleanup-of-slabh.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:30 -0800
Message-ID: <200701020724.l027OUNS012952@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37362 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831AbXABHYv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dimitri.gorokhovik@free.fr, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     MM: SLOB is broken by recent cleanup of slab.h
has been removed from the -mm tree.  Its filename was
     mm-slob-is-broken-by-recent-cleanup-of-slabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MM: SLOB is broken by recent cleanup of slab.h
From: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>

Recent cleanup of slab.h broke SLOB allocator: the routine kmem_cache_init
has now the __init attribute for both slab.c and slob.c.  This routine
cannot be removed after init in the case of slob.c -- it serves as a timer
callback.

Provide a separate timer callback routine, call it once from kmem_cache_init,
keep the __init attribute on the latter.

Signed-off-by: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slob.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/slob.c~mm-slob-is-broken-by-recent-cleanup-of-slabh mm/slob.c
--- a/mm/slob.c~mm-slob-is-broken-by-recent-cleanup-of-slabh
+++ a/mm/slob.c
@@ -60,6 +60,8 @@ static DEFINE_SPINLOCK(slob_lock);
 static DEFINE_SPINLOCK(block_lock);
 
 static void slob_free(void *b, int size);
+static void slob_timer_cbk(void);
+
 
 static void *slob_alloc(size_t size, gfp_t gfp, int align)
 {
@@ -326,7 +328,7 @@ const char *kmem_cache_name(struct kmem_
 EXPORT_SYMBOL(kmem_cache_name);
 
 static struct timer_list slob_timer = TIMER_INITIALIZER(
-	(void (*)(unsigned long))kmem_cache_init, 0, 0);
+	(void (*)(unsigned long))slob_timer_cbk, 0, 0);
 
 int kmem_cache_shrink(struct kmem_cache *d)
 {
@@ -339,7 +341,12 @@ int kmem_ptr_validate(struct kmem_cache 
 	return 0;
 }
 
-void kmem_cache_init(void)
+void __init kmem_cache_init(void)
+{
+	slob_timer_cbk();
+}
+
+static void slob_timer_cbk(void)
 {
 	void *p = slob_alloc(PAGE_SIZE, 0, PAGE_SIZE-1);
 
_

Patches currently in -mm which might be from dimitri.gorokhovik@free.fr are
