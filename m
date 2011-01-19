From: akpm@linux-foundation.org
Subject: + scatterlist-new-helper-functions-update.patch added to -mm tree
Date: Wed, 19 Jan 2011 11:37:10 -0800
Message-ID: <201101191937.p0JJbAaS031322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab1ASTiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 14:38:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, oakad@yahoo.com, tj@kernel.org


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

I hopefully addressed all comments on this code.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN lib/scatterlist.c~scatterlist-new-helper-functions-update lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-new-helper-functions-update
+++ a/lib/scatterlist.c
@@ -40,9 +40,8 @@ EXPORT_SYMBOL(sg_next);
 
 /**
  * sg_advance - advance scatterlist by 'consumed' bytes
- * @sg - the current sg entry
- * @consumed - how much bytes to advance
- *
+ * @sg:		The current sg entry
+ * @consumed: 	How much bytes to advance
  */
 struct scatterlist *sg_advance(struct scatterlist *sg, int consumed)
 {
@@ -74,10 +73,10 @@ EXPORT_SYMBOL(sg_advance);
 
 /**
  * sg_nents - calculate number of sg entries in sg list
- * @sg - the current sg entry
+ * @sg:		The current sg entry
  *
- * Allows to calculate dynamicly the lenght of the sg table, based on
- * assumption that last entry is NULL
+ * Allows to calculate dynamically the length of the sg table, based on
+ * assumption that last entry is correctly marked by sg_mark_end
  */
 int sg_nents(struct scatterlist *sg)
 {
@@ -92,11 +91,11 @@ int sg_nents(struct scatterlist *sg)
 EXPORT_SYMBOL(sg_nents);
 
 /**
- * sg_total_len - calculate total lenght of scatterlist
- * @sg - the current sg entry
+ * sg_total_len - calculate total length of scatterlist
+ * @sg: 	The current sg entry
  *
- * Dynamicly calculate total number of bytes in a sg list
- * based on assumption that list ends with a NULL entry
+ * Dynamically calculate total number of bytes in an scatterlist
+ * based on assumption that last entry is correctly marked by sg_mark_end
  */
 int sg_total_len(struct scatterlist *sg)
 {
@@ -618,11 +617,14 @@ EXPORT_SYMBOL(sg_copy_to_buffer);
 
 
 /**
- * sg_compare_to_buffer - compare contents of the data pointeted by sg table
+ * sg_compare_to_buffer - compare contents of the data pointed by sg table
  * to a kernel ram buffer
- * @sg - the current sg entry
- * @buffer - linear buffer to compare with
- * @len - lenght of that buffer
+ *
+ * @sg:		The current sg entry
+ * @buffer: 	Linear kernel buffer to compare with
+ * @len:	Length of that buffer
+ *
+ * Returns 0 if equal and memcmp compliant result otherwise
  */
 bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len)
 {
@@ -630,9 +632,6 @@ bool sg_compare_to_buffer(struct scatter
 	int retval = 0;
 	struct sg_mapping_iter miter;
 
-	if (sg_total_len(sg) < len)
-		return 1;
-
 	local_irq_save(flags);
 	sg_miter_start(&miter, sg, sg_nents(sg),
 				SG_MITER_ATOMIC | SG_MITER_FROM_SG);
@@ -640,15 +639,17 @@ bool sg_compare_to_buffer(struct scatter
 	while (sg_miter_next(&miter) && len > 0) {
 
 		int cmplen = min(miter.length, len);
-		if (memcmp(miter.addr, buffer, cmplen)) {
-			retval = 1;
+		retval = memcmp(miter.addr, buffer, cmplen);
+		if (retval)
 			break;
-		}
 
 		buffer += cmplen;
 		len -= cmplen;
 	}
 
+	if (!retval && len)
+		retval = -1;
+
 	sg_miter_stop(&miter);
 	local_irq_restore(flags);
 	return retval;
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-support-for-legacy-memorysticks-update.patch
memstick-add-alex-dubov-to-maintainers-of-the-memstick-core.patch

