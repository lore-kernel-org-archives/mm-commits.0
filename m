From: akpm@linux-foundation.org
Subject: +
 lib-scatterlist-factor-out-sg_miter_get_next_page-from-sg_miter_next.patch
 added to -mm tree
Date: Tue, 25 Jun 2013 13:52:47 -0700
Message-ID: <51ca031f.tKUqlX7WlQzvc0g5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3FYUws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 16:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, imre.deak@intel.com, horia.geanta@freescale.com, herbert@gondor.apana.org.au, dgilbert@interlog.com, davem@davemloft.net, JBottomley@parallels.com, akinobu.mita@gmail.com

Subject: + lib-scatterlist-factor-out-sg_miter_get_next_page-from-sg_miter_next.patch added to -mm tree
To: akinobu.mita@gmail.com,JBottomley@parallels.com,davem@davemloft.net,dgilbert@interlog.com,herbert@gondor.apana.org.au,horia.geanta@freescale.com,imre.deak@intel.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 13:52:47 -0700


The patch titled
     Subject: lib/scatterlist: factor out sg_miter_get_next_page() from sg_miter_next()
has been added to the -mm tree.  Its filename is
     lib-scatterlist-factor-out-sg_miter_get_next_page-from-sg_miter_next.patch

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
Subject: lib/scatterlist: factor out sg_miter_get_next_page() from sg_miter_next()

This patchset introduces sg_pcopy_from_buffer() and sg_pcopy_to_buffer(),
which copy data between a linear buffer and an SG list.

The only difference between sg_pcopy_{from,to}_buffer() and
sg_copy_{from,to}_buffer() is an additional argument that specifies the
number of bytes to skip the SG list before copying.

The main reason for introducing these functions is to fix a problem in
scsi_debug module.  And there is a local function in crypto/talitos
module, which can be replaced by sg_pcopy_to_buffer().


This patch:

sg_miter_get_next_page() is used to proceed page iterator to the next page
if necessary, and will be used to implement the variants of
sg_copy_{from,to}_buffer() later.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff -puN lib/scatterlist.c~lib-scatterlist-factor-out-sg_miter_get_next_page-from-sg_miter_next lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-factor-out-sg_miter_get_next_page-from-sg_miter_next
+++ a/lib/scatterlist.c
@@ -453,6 +453,28 @@ void sg_miter_start(struct sg_mapping_it
 }
 EXPORT_SYMBOL(sg_miter_start);
 
+static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
+{
+	if (!miter->__remaining) {
+		struct scatterlist *sg;
+		unsigned long pgoffset;
+
+		if (!__sg_page_iter_next(&miter->piter))
+			return false;
+
+		sg = miter->piter.sg;
+		pgoffset = miter->piter.sg_pgoffset;
+
+		miter->__offset = pgoffset ? 0 : sg->offset;
+		miter->__remaining = sg->offset + sg->length -
+				(pgoffset << PAGE_SHIFT) - miter->__offset;
+		miter->__remaining = min_t(unsigned long, miter->__remaining,
+					   PAGE_SIZE - miter->__offset);
+	}
+
+	return true;
+}
+
 /**
  * sg_miter_next - proceed mapping iterator to the next mapping
  * @miter: sg mapping iter to proceed
@@ -478,22 +500,9 @@ bool sg_miter_next(struct sg_mapping_ite
 	 * Get to the next page if necessary.
 	 * __remaining, __offset is adjusted by sg_miter_stop
 	 */
-	if (!miter->__remaining) {
-		struct scatterlist *sg;
-		unsigned long pgoffset;
+	if (!sg_miter_get_next_page(miter))
+		return false;
 
-		if (!__sg_page_iter_next(&miter->piter))
-			return false;
-
-		sg = miter->piter.sg;
-		pgoffset = miter->piter.sg_pgoffset;
