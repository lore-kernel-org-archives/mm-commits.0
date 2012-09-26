From: akpm@linux-foundation.org
Subject: + scatterlist-add-sg_nents.patch added to -mm tree
Date: Wed, 26 Sep 2012 14:11:47 -0700
Message-ID: <20120926211148.4D619100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:52813 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2IZVLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 17:11:49 -0400
Received: by vbis24 with SMTP id s24so129713vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 14:11:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, axboe@kernel.dk, oakad@yahoo.com, tj@kernel.org


The patch titled
     Subject: scatterlist: add sg_nents
has been added to the -mm tree.  Its filename is
     scatterlist-add-sg_nents.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scatterlist-atomic-sg_mapping_iter-no-longer-needs-disabled-irqs.patch
scatterlist-add-sg_nents.patch
memstick-add-support-for-legacy-memorysticks.patch

