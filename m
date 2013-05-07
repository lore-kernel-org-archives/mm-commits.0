From: akpm@linux-foundation.org
Subject: [merged] frontswap-get-rid-of-swap_lock-dependency.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:30 -0700
Message-ID: <20130507174630.92B1231C284@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:57808 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3EGRqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:32 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so109449qab.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, andor.daam@googlemail.com, dan.magenheimer@oracle.com, fschmaus@gmail.com, ilendir@googlemail.com, konrad@darnok.org, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: get rid of swap_lock dependency
has been removed from the -mm tree.  Its filename was
     frontswap-get-rid-of-swap_lock-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: frontswap: get rid of swap_lock dependency

Frontswap initialization routine depends on swap_lock, which want to be
atomic about frontswap's first appearance.  IOW, frontswap is not present
and will fail all calls OR frontswap is fully functional but if new
swap_info_struct isn't registered by enable_swap_info, swap subsystem
doesn't start I/O so there is no race between init procedure and page I/O
working on frontswap.

So let's remove unnecessary swap_lock dependency.

Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
[v1: Rebased on my branch, reworked to work with backends loading late]
[v2: Added a check for !map]
[v3: Made the invalidate path follow the init path]
[v4: Address comments by Wanpeng Li <liwanp@linux.vnet.ibm.com>]
Signed-off-by: Konrad Rzeszutek Wilk <konrad@darnok.org>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/frontswap.h |    6 +++---
 mm/frontswap.c            |   31 +++++++++++++++++++++++--------
 mm/swapfile.c             |   17 +++++++++--------
 3 files changed, 35 insertions(+), 19 deletions(-)

diff -puN include/linux/frontswap.h~frontswap-get-rid-of-swap_lock-dependency include/linux/frontswap.h
--- a/include/linux/frontswap.h~frontswap-get-rid-of-swap_lock-dependency
+++ a/include/linux/frontswap.h
@@ -23,7 +23,7 @@ extern void frontswap_writethrough(bool)
 extern void frontswap_tmem_exclusive_gets(bool);
 
 extern bool __frontswap_test(struct swap_info_struct *, pgoff_t);
-extern void __frontswap_init(unsigned type);
+extern void __frontswap_init(unsigned type, unsigned long *map);
 extern int __frontswap_store(struct page *page);
 extern int __frontswap_load(struct page *page);
 extern void __frontswap_invalidate_page(unsigned, pgoff_t);
@@ -98,10 +98,10 @@ static inline void frontswap_invalidate_
 		__frontswap_invalidate_area(type);
 }
 
-static inline void frontswap_init(unsigned type)
+static inline void frontswap_init(unsigned type, unsigned long *map)
 {
 	if (frontswap_enabled)
-		__frontswap_init(type);
+		__frontswap_init(type, map);
 }
 
 #endif /* _LINUX_FRONTSWAP_H */
diff -puN mm/frontswap.c~frontswap-get-rid-of-swap_lock-dependency mm/frontswap.c
--- a/mm/frontswap.c~frontswap-get-rid-of-swap_lock-dependency
+++ a/mm/frontswap.c
@@ -121,8 +121,13 @@ struct frontswap_ops *frontswap_register
 	int i;
 
 	for (i = 0; i < MAX_SWAPFILES; i++) {
-		if (test_and_clear_bit(i, need_init))
+		if (test_and_clear_bit(i, need_init)) {
+			struct swap_info_struct *sis = swap_info[i];
+			/* __frontswap_init _should_ have set it! */
+			if (!sis->frontswap_map)
+				return ERR_PTR(-EINVAL);
 			ops->init(i);
+		}
 	}
 	/*
 	 * We MUST have frontswap_ops set _after_ the frontswap_init's
@@ -156,20 +161,30 @@ EXPORT_SYMBOL(frontswap_tmem_exclusive_g
 /*
  * Called when a swap device is swapon'd.
  */
-void __frontswap_init(unsigned type)
+void __frontswap_init(unsigned type, unsigned long *map)
 {
 	struct swap_info_struct *sis = swap_info[type];
 
-	if (frontswap_ops) {
-		BUG_ON(sis == NULL);
-		if (sis->frontswap_map == NULL)
-			return;
+	BUG_ON(sis == NULL);
+
+	/*
+	 * p->frontswap is a bitmap that we MUST have to figure out which page
+	 * has gone in frontswap. Without it there is no point of continuing.
+	 */
+	if (WARN_ON(!map))
+		return;
+	/*
+	 * Irregardless of whether the frontswap backend has been loaded
+	 * before this function or it will be later, we _MUST_ have the
+	 * p->frontswap set to something valid to work properly.
+	 */
+	frontswap_map_set(sis, map);
+	if (frontswap_ops)
 		frontswap_ops->init(type);
-	} else {
+	else {
 		BUG_ON(type > MAX_SWAPFILES);
 		set_bit(type, need_init);
 	}
-
 }
 EXPORT_SYMBOL(__frontswap_init);
 
diff -puN mm/swapfile.c~frontswap-get-rid-of-swap_lock-dependency mm/swapfile.c
--- a/mm/swapfile.c~frontswap-get-rid-of-swap_lock-dependency
+++ a/mm/swapfile.c
@@ -1509,8 +1509,7 @@ static int setup_swap_extents(struct swa
 }
 
 static void _enable_swap_info(struct swap_info_struct *p, int prio,
-				unsigned char *swap_map,
-				unsigned long *frontswap_map)
+				unsigned char *swap_map)
 {
 	int i, prev;
 
@@ -1519,7 +1518,6 @@ static void _enable_swap_info(struct swa
 	else
 		p->prio = --least_priority;
 	p->swap_map = swap_map;
-	frontswap_map_set(p, frontswap_map);
 	p->flags |= SWP_WRITEOK;
 	atomic_long_add(p->pages, &nr_swap_pages);
 	total_swap_pages += p->pages;
@@ -1542,10 +1540,10 @@ static void enable_swap_info(struct swap
 				unsigned char *swap_map,
 				unsigned long *frontswap_map)
 {
+	frontswap_init(p->type, frontswap_map);
 	spin_lock(&swap_lock);
 	spin_lock(&p->lock);
-	_enable_swap_info(p, prio, swap_map, frontswap_map);
-	frontswap_init(p->type);
+	 _enable_swap_info(p, prio, swap_map);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 }
@@ -1554,7 +1552,7 @@ static void reinsert_swap_info(struct sw
 {
 	spin_lock(&swap_lock);
 	spin_lock(&p->lock);
-	_enable_swap_info(p, p->prio, p->swap_map, frontswap_map_get(p));
+	_enable_swap_info(p, p->prio, p->swap_map);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 }
@@ -1563,6 +1561,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 {
 	struct swap_info_struct *p = NULL;
 	unsigned char *swap_map;
+	unsigned long *frontswap_map;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
@@ -1662,12 +1661,14 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
 	p->flags = 0;
-	frontswap_invalidate_area(type);
+	frontswap_map = frontswap_map_get(p);
+	frontswap_map_set(p, NULL);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
+	frontswap_invalidate_area(type);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
-	vfree(frontswap_map_get(p));
+	vfree(frontswap_map);
 	/* Destroy swap account informatin */
 	swap_cgroup_swapoff(type);
 
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
block-aio-batch-completion-for-bios-kiocbs.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

