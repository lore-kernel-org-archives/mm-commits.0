From: akpm@linux-foundation.org
Subject: - dm-bio-list-helpers.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:08 -0700
Message-ID: <200705092149.l49Ln8jc002670@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289AbXEIVtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hjm@redhat.com, agk@redhat.com, breeves@redhat.com, mbroz@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: bio list helpers
has been removed from the -mm tree.  Its filename was
     dm-bio-list-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: bio list helpers
From: Heinz Mauelshagen <hjm@redhat.com>

More bio_list helper functions for new targets (including dm-delay and
dm-loop) to manipulate lists of bios.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Bryn Reeves <breeves@redhat.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-bio-list.h |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN drivers/md/dm-bio-list.h~dm-bio-list-helpers drivers/md/dm-bio-list.h
--- a/drivers/md/dm-bio-list.h~dm-bio-list-helpers
+++ a/drivers/md/dm-bio-list.h
@@ -8,17 +8,43 @@
 #define DM_BIO_LIST_H
 
 #include <linux/bio.h>
+#include <linux/prefetch.h>
 
 struct bio_list {
 	struct bio *head;
 	struct bio *tail;
 };
 
+static inline int bio_list_empty(const struct bio_list *bl)
+{
+	return bl->head == NULL;
+}
+
+#define BIO_LIST_INIT { .head = NULL, .tail = NULL }
+
+#define BIO_LIST(bl) \
+	struct bio_list bl = BIO_LIST_INIT
+
 static inline void bio_list_init(struct bio_list *bl)
 {
 	bl->head = bl->tail = NULL;
 }
 
+#define bio_list_for_each(bio, bl) \
+	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
+	     bio = bio->bi_next)
+
+static inline unsigned bio_list_size(const struct bio_list *bl)
+{
+	unsigned sz = 0;
+	struct bio *bio;
+
+	bio_list_for_each(bio, bl)
+		sz++;
+
+	return sz;
+}
+
 static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
 {
 	bio->bi_next = NULL;
_

Patches currently in -mm which might be from hjm@redhat.com are

origin.patch
