From: akpm@linux-foundation.org
Subject: [merged] scatterlist-add-sg_nents.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:29:13 -0700
Message-ID: <20121001192913.B6FD2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46624 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2JAT3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:29:16 -0400
Received: by vcbfy27 with SMTP id fy27so687115vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:29:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maximlevitsky@gmail.com, axboe@kernel.dk, oakad@yahoo.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: add sg_nents
has been removed from the -mm tree.  Its filename was
     scatterlist-add-sg_nents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: scatterlist: add sg_nents

Useful helper to know the number of entries in scatterlist.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    1 +
 lib/scatterlist.c           |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff -puN include/linux/scatterlist.h~scatterlist-add-sg_nents include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~scatterlist-add-sg_nents
+++ a/include/linux/scatterlist.h
@@ -201,6 +201,7 @@ static inline void *sg_virt(struct scatt
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
+int sg_nents(struct scatterlist *sg);
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
diff -puN lib/scatterlist.c~scatterlist-add-sg_nents lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-add-sg_nents
+++ a/lib/scatterlist.c
@@ -39,6 +39,28 @@ struct scatterlist *sg_next(struct scatt
 EXPORT_SYMBOL(sg_next);
 
 /**
+ * sg_nents - return total count of entries in scatterlist
+ * @sg:		The scatterlist
+ *
+ * Description:
+ * Allows to know how many entries are in sg, taking into acount
+ * chaining as well
+ *
+ **/
+int sg_nents(struct scatterlist *sg)
+{
+	int nents = 0;
+	while (sg) {
+		nents++;
+		sg = sg_next(sg);
+	}
+
+	return nents;
+}
+EXPORT_SYMBOL(sg_nents);
+
+
+/**
  * sg_last - return the last scatterlist entry in a list
  * @sgl:	First entry in the scatterlist
  * @nents:	Number of entries in the scatterlist
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
scatterlist-atomic-sg_mapping_iter-no-longer-needs-disabled-irqs.patch

