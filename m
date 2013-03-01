From: akpm@linux-foundation.org
Subject: [merged] hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix.patch removed from -mm tree
Date: Fri, 01 Mar 2013 12:47:08 -0800
Message-ID: <20130301204710.7189931C1B5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:63776 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3CAUrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 15:47:12 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so74096vbb.4
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 12:47:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-cache-policy-cleaner.c |    3 +--
 drivers/md/dm-cache-policy-mq.c      |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm-cache-policy-cleaner.c~hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix drivers/md/dm-cache-policy-cleaner.c
--- a/drivers/md/dm-cache-policy-cleaner.c~hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix
+++ a/drivers/md/dm-cache-policy-cleaner.c
@@ -142,10 +142,9 @@ static struct wb_cache_entry *lookup_cac
 	struct hash *hash = &p->chash;
 	unsigned h = hash_64(from_oblock(oblock), hash->hash_bits);
 	struct wb_cache_entry *cur;
-	struct hlist_node *tmp;
 	struct hlist_head *bucket = &hash->table[h];
 
-	hlist_for_each_entry(cur, tmp, bucket, hlist) {
+	hlist_for_each_entry(cur, bucket, hlist) {
 		if (cur->oblock == oblock) {
 			/* Move upfront bucket for faster access. */
 			hlist_del(&cur->hlist);
diff -puN drivers/md/dm-cache-policy-mq.c~hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix drivers/md/dm-cache-policy-mq.c
--- a/drivers/md/dm-cache-policy-mq.c~hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix
+++ a/drivers/md/dm-cache-policy-mq.c
@@ -369,10 +369,9 @@ static struct entry *hash_lookup(struct 
 {
 	unsigned h = hash_64(from_oblock(oblock), mq->hash_bits);
 	struct hlist_head *bucket = mq->table + h;
-	struct hlist_node *tmp;
 	struct entry *e;
 
-	hlist_for_each_entry(e, tmp, bucket, hlist)
+	hlist_for_each_entry(e, bucket, hlist)
 		if (e->oblock == oblock) {
 			hlist_del(&e->hlist);
 			hlist_add_head(&e->hlist, bucket);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch
kernel-forkc-export-kernel_thread-to-modules.patch

