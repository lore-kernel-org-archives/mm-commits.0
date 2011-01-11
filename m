From: akpm@linux-foundation.org
Subject: + scatterlist-new-helper-functions.patch added to -mm tree
Date: Tue, 11 Jan 2011 14:28:32 -0800
Message-ID: <201101112228.p0BMSXvh010463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932283Ab1AKW2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 17:28:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, oakad@yahoo.com, tj@kernel.org


The patch titled
     scatterlist: new helper functions
has been added to the -mm tree.  Its filename is
     scatterlist-new-helper-functions.patch

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
Subject: scatterlist: new helper functions
From: Maxim Levitsky <maximlevitsky@gmail.com>

While developing memstick driver for legacy memsticks I found the need in
few helpers that I think are ok to have in common sg library

The functions that were added:

* sg_nents/sg_total_len - iterate over sg list to figure out its total
  len, number of entries.  Useful for not keeping that information in side
  channels.

* sg_copy/sg_advance - Alow to break sg lists apart into smaller chunks.
   sg_copy creates smaller sg list spanning first 'len' bytes, while
  sg_advance edits the sg list in such way that it skips over 'len' bytes.

* sg_compare_to_buffer - another function to hide gory details of access
  to sg list by CPU.  Allows to transparetly compare contents of the sg
  list to given linear buffer.  If needed later, a function that compares
  two sgs can be added.

All of this code is used by my ms_block.c driver.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    6 +
 lib/scatterlist.c           |  137 ++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

diff -puN include/linux/scatterlist.h~scatterlist-new-helper-functions include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~scatterlist-new-helper-functions
+++ a/include/linux/scatterlist.h
@@ -199,6 +199,11 @@ static inline void *sg_virt(struct scatt
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
+struct scatterlist *sg_advance(struct scatterlist *sg, int consumed);
+int sg_nents(struct scatterlist *sg);
+int sg_total_len(struct scatterlist *sg);
+int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len);
+
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
@@ -217,6 +222,7 @@ size_t sg_copy_from_buffer(struct scatte
 			   void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen);
+bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len);
 
 /*
  * Maximum number of entries that will be allocated in one piece, if
diff -puN lib/scatterlist.c~scatterlist-new-helper-functions lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-new-helper-functions
+++ a/lib/scatterlist.c
@@ -39,6 +39,77 @@ struct scatterlist *sg_next(struct scatt
 EXPORT_SYMBOL(sg_next);
 
 /**
+ * sg_advance - advance scatterlist by 'consumed' bytes
+ * @sg - the current sg entry
+ * @consumed - how much bytes to advance
+ *
+ */
+struct scatterlist *sg_advance(struct scatterlist *sg, int consumed)
+{
+	while (consumed >= sg->length) {
+		consumed -= sg->length;
+
+		sg = sg_next(sg);
+		if (!sg)
+			break;
+	}
+
+	WARN_ON(!sg && consumed);
+
+	if (!sg)
+		return NULL;
+
+	sg->offset += consumed;
+	sg->length -= consumed;
+
+	if (sg->offset >= PAGE_SIZE) {
+		struct page *page =
+			nth_page(sg_page(sg), sg->offset / PAGE_SIZE);
+		sg_set_page(sg, page, sg->length, sg->offset % PAGE_SIZE);
+	}
+
+	return sg;
+}
+EXPORT_SYMBOL(sg_advance);
+
+/**
+ * sg_nents - calculate number of sg entries in sg list
+ * @sg - the current sg entry
+ *
+ * Allows to calculate dynamicly the lenght of the sg table, based on
+ * assumption that last entry is NULL
+ */
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
+/**
+ * sg_total_len - calculate total lenght of scatterlist
+ * @sg - the current sg entry
+ *
+ * Dynamicly calculate total number of bytes in a sg list
+ * based on assumption that list ends with a NULL entry
+ */
+int sg_total_len(struct scatterlist *sg)
+{
+	int len = 0;
+	while (sg) {
+		len += sg->length;
+		sg = sg_next(sg);
+	}
+	return len;
+}
+EXPORT_SYMBOL(sg_total_len);
+
+/**
  * sg_last - return the last scatterlist entry in a list
  * @sgl:	First entry in the scatterlist
  * @nents:	Number of entries in the scatterlist
@@ -110,6 +181,33 @@ void sg_init_one(struct scatterlist *sg,
 }
 EXPORT_SYMBOL(sg_init_one);
 
+/**
+ * sg_copy - copies sg entries from sg_from to sg_to, such
+ * as sg_to covers first 'len' bytes from sg_from.
+ */
+int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len)
+{
+	while (len > sg_from->length) {
+		len -= sg_from->length;
+
+		sg_set_page(sg_to, sg_page(sg_from),
+				sg_from->length, sg_from->offset);
+
+		sg_to = sg_next(sg_to);
+		sg_from = sg_next(sg_from);
+
+		if (len && (!sg_from || !sg_to))
+			return -ENOMEM;
+	}
+
+	if (len)
+		sg_set_page(sg_to, sg_page(sg_from),
+				len, sg_from->offset);
+	sg_mark_end(sg_to);
+	return 0;
+}
+EXPORT_SYMBOL(sg_copy);
+
 /*
  * The default behaviour of sg_alloc_table() is to use these kmalloc/kfree
  * helpers.
@@ -517,3 +615,42 @@ size_t sg_copy_to_buffer(struct scatterl
 	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
+
+
+/**
+ * sg_compare_to_buffer - compare contents of the data pointeted by sg table
+ * to a kernel ram buffer
+ * @sg - the current sg entry
+ * @buffer - linear buffer to compare with
+ * @len - lenght of that buffer
+ */
+bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len)
+{
+	unsigned long flags;
+	int retval = 0;
+	struct sg_mapping_iter miter;
+
+	if (sg_total_len(sg) < len)
+		return 1;
+
+	local_irq_save(flags);
+	sg_miter_start(&miter, sg, sg_nents(sg),
+				SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+
+	while (sg_miter_next(&miter) && len > 0) {
+
+		int cmplen = min(miter.length, len);
+		if (memcmp(miter.addr, buffer, cmplen)) {
+			retval = 1;
+			break;
+		}
+
+		buffer += cmplen;
+		len -= cmplen;
+	}
+
+	sg_miter_stop(&miter);
+	local_irq_restore(flags);
+	return retval;
+}
+EXPORT_SYMBOL(sg_compare_to_buffer);
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

origin.patch
memstick-core-fix-device_register-error-handling.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
memstick-add-support-for-mspro-specific-data-transfer-method.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-alex-dubov-to-maintainers-of-the-memstick-core.patch

