From: akpm@linux-foundation.org
Subject: +
 zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch
 added to -mm tree
Date: Fri, 12 May 2017 13:44:07 -0700
Message-ID: <59161e97.lxGBMTGGvMbkoXUh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754846AbdELUoI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 16:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: compare all the entries with same checksum for deduplication
has been added to the -mm tree.  Its filename is
     zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: zram: compare all the entries with same checksum for deduplication

Until now, we compare just one entry with same checksum when checking
duplication since it is the simplest way to implement.  However, for the
completeness, checking all the entries is better so this patch implement
to compare all the entries with same checksum.  Since this event would be
rare so there would be no performance loss.

Link: http://lkml.kernel.org/r/1494556204-25796-5-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_dedup.c |   59 +++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 12 deletions(-)

diff -puN drivers/block/zram/zram_dedup.c~zram-compare-all-the-entries-with-same-checksum-for-deduplication drivers/block/zram/zram_dedup.c
--- a/drivers/block/zram/zram_dedup.c~zram-compare-all-the-entries-with-same-checksum-for-deduplication
+++ a/drivers/block/zram/zram_dedup.c
@@ -109,6 +109,51 @@ static unsigned long zram_dedup_put(stru
 	return entry->refcount;
 }
 
+static struct zram_entry *__zram_dedup_get(struct zram *zram,
+				struct zram_hash *hash, unsigned char *mem,
+				struct zram_entry *entry)
+{
+	struct zram_entry *tmp, *prev = NULL;
+	struct rb_node *rb_node;
+
+	/* find left-most entry with same checksum */
+	while ((rb_node = rb_prev(&entry->rb_node))) {
+		tmp = rb_entry(rb_node, struct zram_entry, rb_node);
+		if (tmp->checksum != entry->checksum)
+			break;
+
+		entry = tmp;
+	}
+
+again:
+	entry->refcount++;
+	atomic64_add(entry->len, &zram->stats.dup_data_size);
+	spin_unlock(&hash->lock);
+
+	if (prev)
+		zram_entry_free(zram, prev);
+
+	if (zram_dedup_match(zram, entry, mem))
+		return entry;
+
+	spin_lock(&hash->lock);
+	tmp = NULL;
+	rb_node = rb_next(&entry->rb_node);
+	if (rb_node)
+		tmp = rb_entry(rb_node, struct zram_entry, rb_node);
+
+	if (tmp && (tmp->checksum == entry->checksum)) {
+		prev = entry;
+		entry = tmp;
+		goto again;
+	}
+
+	spin_unlock(&hash->lock);
+	zram_entry_free(zram, entry);
+
+	return NULL;
+}
+
 static struct zram_entry *zram_dedup_get(struct zram *zram,
 				unsigned char *mem, u32 checksum)
 {
@@ -122,18 +167,8 @@ static struct zram_entry *zram_dedup_get
 	rb_node = hash->rb_root.rb_node;
 	while (rb_node) {
 		entry = rb_entry(rb_node, struct zram_entry, rb_node);
-		if (checksum == entry->checksum) {
-			entry->refcount++;
-			atomic64_add(entry->len, &zram->stats.dup_data_size);
-			spin_unlock(&hash->lock);
-
-			if (zram_dedup_match(zram, entry, mem))
-				return entry;
-
-			zram_entry_free(zram, entry);
