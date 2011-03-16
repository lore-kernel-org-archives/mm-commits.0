From: akpm@linux-foundation.org
Subject: + scatterlist-new-helper-functions-update.patch added to -mm tree
Date: Tue, 15 Mar 2011 18:01:49 -0700
Message-ID: <201103160104.p2G141xa022965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab1CPBEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 21:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, oakad@yahoo.com, tj@kernel.org


The patch titled
     scatterlist-new-helper-functions-update
has been added to the -mm tree.  Its filename is
     scatterlist-new-helper-functions-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scatterlist-new-helper-functions-update
From: Maxim Levitsky <maximlevitsky@gmail.com>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    8 ++--
 lib/scatterlist.c           |   58 +++++++++++++++++++---------------
 2 files changed, 38 insertions(+), 28 deletions(-)

diff -puN include/linux/scatterlist.h~scatterlist-new-helper-functions-update include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~scatterlist-new-helper-functions-update
+++ a/include/linux/scatterlist.h
@@ -199,10 +199,11 @@ static inline void *sg_virt(struct scatt
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
-struct scatterlist *sg_advance(struct scatterlist *sg, int consumed);
+struct scatterlist *sg_truncate(struct scatterlist *sg, int consumed);
 int sg_nents(struct scatterlist *sg);
 int sg_total_len(struct scatterlist *sg);
-int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len);
+int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to,
+							int to_nents, int len);
 
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
@@ -222,7 +223,8 @@ size_t sg_copy_from_buffer(struct scatte
 			   void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen);
-bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len);
+bool sg_compare_to_buffer(struct scatterlist *sg, unsigned int nents,
+							u8 *buffer, size_t len);
 
 /*
  * Maximum number of entries that will be allocated in one piece, if
diff -puN lib/scatterlist.c~scatterlist-new-helper-functions-update lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-new-helper-functions-update
+++ a/lib/scatterlist.c
@@ -39,11 +39,11 @@ struct scatterlist *sg_next(struct scatt
 EXPORT_SYMBOL(sg_next);
 
 /**
- * sg_advance - advance scatterlist by 'consumed' bytes
+ * sg_truncate - remove 'consumed' bytes from head of a scatterlist
  * @sg:		The current sg entry
- * @consumed:	How much bytes to advance
+ * @consumed:	How much bytes to remove
  */
-struct scatterlist *sg_advance(struct scatterlist *sg, int consumed)
+struct scatterlist *sg_truncate(struct scatterlist *sg, int consumed)
 {
 	while (consumed >= sg->length) {
 		consumed -= sg->length;
@@ -69,7 +69,7 @@ struct scatterlist *sg_advance(struct sc
 
 	return sg;
 }
-EXPORT_SYMBOL(sg_advance);
+EXPORT_SYMBOL(sg_truncate);
 
 /**
  * sg_nents - calculate number of sg entries in sg list
@@ -92,7 +92,7 @@ EXPORT_SYMBOL(sg_nents);
 
 /**
  * sg_total_len - calculate total length of scatterlist
- * @sg: The current sg entry
+ * @sg:		The current sg entry
  *
  * Dynamically calculate total number of bytes in an scatterlist
  * based on assumption that last entry is correctly marked by sg_mark_end
@@ -181,35 +181,43 @@ void sg_init_one(struct scatterlist *sg,
 EXPORT_SYMBOL(sg_init_one);
 
 /**
- * sg_copy - copy sg entries
- * @sg_from: source
- * @sg_to: destination
- *
- * Copies from @sg_from to @sg_to.  @sg_to covers first 'len' bytes from
- * @sg_from.
+ * sg_copy - copies sg entries from sg_from to sg_to, such
+ * as sg_to covers first 'len' bytes from sg_from.
+ * @sg_from:	SG list to copy entries from
+ * @sg_to:	SG list to write entries to
+ * @to_nents:	number of usable entries in 'sg_to'
+ * @len:	maximum number of bytes the 'sg_to' will cover
  *
- * Returns zero on success, else a -ve errno.
+ * Returns actual number of bytes covered by sg_to
  */
-int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len)
+int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to,
+							int to_nents, int len)
 {
-	while (len > sg_from->length) {
+	int copied = 0;
+
+	while (len > sg_from->length && to_nents--) {
+
 		len -= sg_from->length;
+		copied += sg_from->length;
 
 		sg_set_page(sg_to, sg_page(sg_from),
 				sg_from->length, sg_from->offset);
 
-		sg_to = sg_next(sg_to);
+		if (sg_is_last(sg_from) || !len) {
+			sg_mark_end(sg_to);
+			return copied;
+		}
+
 		sg_from = sg_next(sg_from);
+		sg_to = sg_next(sg_to);
+	}
 
-		if (len && (!sg_from || !sg_to))
-			return -ENOMEM;
+	if (to_nents) {
+		sg_set_page(sg_to, sg_page(sg_from), len, sg_from->offset);
+		sg_mark_end(sg_to);
 	}
 
-	if (len)
-		sg_set_page(sg_to, sg_page(sg_from),
-				len, sg_from->offset);
-	sg_mark_end(sg_to);
-	return 0;
+	return copied;
 }
 EXPORT_SYMBOL(sg_copy);
 
@@ -632,15 +640,15 @@ EXPORT_SYMBOL(sg_copy_to_buffer);
  *
  * Returns 0 if equal and memcmp compliant result otherwise
  */
-bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len)
+bool sg_compare_to_buffer(struct scatterlist *sg, unsigned int nents,
+							u8 *buffer, size_t len)
 {
 	unsigned long flags;
 	int retval = 0;
 	struct sg_mapping_iter miter;
 
 	local_irq_save(flags);
-	sg_miter_start(&miter, sg, sg_nents(sg),
-				SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	sg_miter_start(&miter, sg, nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
 
 	while (sg_miter_next(&miter) && len > 0) {
 
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
maintainers-update-media-path.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-support-for-legacy-memorysticks-update-2.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-alex-dubov-to-maintainers-of-the-memstick-core.patch

