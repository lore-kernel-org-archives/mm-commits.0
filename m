From: akpm@linux-foundation.org
Subject: +
 lib-scatterlist-introduce-sg_pcopy_from_buffer-and-sg_pcopy_to_buffer.patch added to -mm tree
Date: Tue, 25 Jun 2013 13:52:48 -0700
Message-ID: <51ca0320.erw5FNob4bTfeFFP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3FYUwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 16:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, imre.deak@intel.com, horia.geanta@freescale.com, herbert@gondor.apana.org.au, dgilbert@interlog.com, davem@davemloft.net, JBottomley@parallels.com, akinobu.mita@gmail.com

Subject: + lib-scatterlist-introduce-sg_pcopy_from_buffer-and-sg_pcopy_to_buffer.patch added to -mm tree
To: akinobu.mita@gmail.com,JBottomley@parallels.com,davem@davemloft.net,dgilbert@interlog.com,herbert@gondor.apana.org.au,horia.geanta@freescale.com,imre.deak@intel.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 13:52:48 -0700


The patch titled
     Subject: lib/scatterlist: introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()
has been added to the -mm tree.  Its filename is
     lib-scatterlist-introduce-sg_pcopy_from_buffer-and-sg_pcopy_to_buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: lib/scatterlist: introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()

The only difference between sg_pcopy_{from,to}_buffer() and
sg_copy_{from,to}_buffer() is an additional argument that specifies the
number of bytes to skip the SG list before copying.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
Cc: Imre Deak <imre.deak@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    5 +
 lib/scatterlist.c           |   88 ++++++++++++++++++++++++++++++++--
 2 files changed, 88 insertions(+), 5 deletions(-)

diff -puN include/linux/scatterlist.h~lib-scatterlist-introduce-sg_pcopy_from_buffer-and-sg_pcopy_to_buffer include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~lib-scatterlist-introduce-sg_pcopy_from_buffer-and-sg_pcopy_to_buffer
+++ a/include/linux/scatterlist.h
@@ -244,6 +244,11 @@ size_t sg_copy_from_buffer(struct scatte
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen);
 
+size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			    void *buf, size_t buflen, off_t skip);
+size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+			  void *buf, size_t buflen, off_t skip);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff -puN lib/scatterlist.c~lib-scatterlist-introduce-sg_pcopy_from_buffer-and-sg_pcopy_to_buffer lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-introduce-sg_pcopy_from_buffer-and-sg_pcopy_to_buffer
+++ a/lib/scatterlist.c
@@ -476,6 +476,43 @@ static bool sg_miter_get_next_page(struc
 }
 
 /**
+ * sg_miter_skip - reposition mapping iterator
+ * @miter: sg mapping iter to be skipped
+ * @offset: number of bytes to plus the current location
+ *
+ * Description:
+ *   Sets the offset of @miter to its current location plus @offset bytes.
+ *   If mapping iterator @miter has been proceeded by sg_miter_next(), this
+ *   stops @miter.
+ *
+ * Context:
+ *   Don't care if @miter is stopped, or not proceeded yet.
+ *   Otherwise, preemption disabled if the SG_MITER_ATOMIC is set.
+ *
+ * Returns:
+ *   true if @miter contains the valid mapping.  false if end of sg
+ *   list is reached.
+ */
+static bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset)
+{
+	sg_miter_stop(miter);
+
+	while (offset) {
+		off_t consumed;
+
+		if (!sg_miter_get_next_page(miter))
+			return false;
+
+		consumed = min_t(off_t, offset, miter->__remaining);
+		miter->__offset += consumed;
+		miter->__remaining -= consumed;
+		offset -= consumed;
+	}
+
+	return true;
+}
+
+/**
  * sg_miter_next - proceed mapping iterator to the next mapping
  * @miter: sg mapping iter to proceed
  *
@@ -561,14 +598,16 @@ EXPORT_SYMBOL(sg_miter_stop);
  * @nents:		 Number of SG entries
  * @buf:		 Where to copy from
  * @buflen:		 The number of bytes to copy
- * @to_buffer: 		 transfer direction (non zero == from an sg list to a
- * 			 buffer, 0 == from a buffer to an sg list
+ * @skip:		 Number of bytes to skip before copying
+ * @to_buffer:		 transfer direction (true == from an sg list to a
+ *			 buffer, false == from a buffer to an sg list
  *
  * Returns the number of copied bytes.
  *
  **/
 static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
-			     void *buf, size_t buflen, int to_buffer)
+			     void *buf, size_t buflen, off_t skip,
+			     bool to_buffer)
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
@@ -582,6 +621,9 @@ static size_t sg_copy_buffer(struct scat
 
 	sg_miter_start(&miter, sgl, nents, sg_flags);
 
+	if (!sg_miter_skip(&miter, skip))
+		return false;
+
 	local_irq_save(flags);
 
 	while (sg_miter_next(&miter) && offset < buflen) {
@@ -616,7 +658,7 @@ static size_t sg_copy_buffer(struct scat
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   void *buf, size_t buflen)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, 0);
+	return sg_copy_buffer(sgl, nents, buf, buflen, 0, false);
 }
 EXPORT_SYMBOL(sg_copy_from_buffer);
 
@@ -633,6 +675,42 @@ EXPORT_SYMBOL(sg_copy_from_buffer);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
+	return sg_copy_buffer(sgl, nents, buf, buflen, 0, true);
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
+
+/**
+ * sg_pcopy_from_buffer - Copy from a linear buffer to an SG list
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy from
+ * @skip:		 Number of bytes to skip before copying
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied bytes.
+ *
+ **/
+size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			    void *buf, size_t buflen, off_t skip)
+{
+	return sg_copy_buffer(sgl, nents, buf, buflen, skip, false);
+}
+EXPORT_SYMBOL(sg_pcopy_from_buffer);
+
+/**
+ * sg_pcopy_to_buffer - Copy from an SG list to a linear buffer
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy to
+ * @skip:		 Number of bytes to skip before copying
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied bytes.
+ *
+ **/
+size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+			  void *buf, size_t buflen, off_t skip)
+{
+	return sg_copy_buffer(sgl, nents, buf, buflen, skip, true);
+}
+EXPORT_SYMBOL(sg_pcopy_to_buffer);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
lib-scatterlist-factor-out-sg_miter_get_next_page-from-sg_miter_next.patch
lib-scatterlist-introduce-sg_pcopy_from_buffer-and-sg_pcopy_to_buffer.patch
crypto-talitos-use-sg_pcopy_to_buffer.patch
scsi_debug-fix-do_device_access-with-wrap-around-range.patch

