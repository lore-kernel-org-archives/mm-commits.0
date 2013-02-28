From: akpm@linux-foundation.org
Subject: + hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix.patch added to -mm tree
Date: Thu, 28 Feb 2013 13:49:42 -0800
Message-ID: <20130228214942.941F931C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:51814 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3B1Vtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 16:49:43 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so257161vcd.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 13:49:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix
has been added to the -mm tree.  Its filename is
     hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

