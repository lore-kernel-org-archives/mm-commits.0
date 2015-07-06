From: akpm@linux-foundation.org
Subject: [merged]
 lib-scatterlist-mark-input-buffer-parameters-as-const.patch removed from
 -mm tree
Date: Mon, 06 Jul 2015 12:47:33 -0700
Message-ID: <559adb55.GsIRGZuWkt3fL1HH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbbGFTre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.s.gordon@intel.com, akinobu.mita@gmail.com, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: mark input buffer parameters as 'const'
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-mark-input-buffer-parameters-as-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Gordon <david.s.gordon@intel.com>
Subject: lib/scatterlist: mark input buffer parameters as 'const'

The 'buf' parameter of sg(p)copy_from_buffer() can and should be
const-qualified, although because of the shared implementation of
_to_buffer() and _from_buffer(), we have to cast this away internally.

This means that callers who have a 'const' buffer containing the data to
be copied to the sg-list no longer have to cast away the const-ness
themselves.  It also enables improved coverage by code analysis tools.

Signed-off-by: Dave Gordon <david.s.gordon@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    4 ++--
 lib/scatterlist.c           |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/scatterlist.h~lib-scatterlist-mark-input-buffer-parameters-as-const include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~lib-scatterlist-mark-input-buffer-parameters-as-const
+++ a/include/linux/scatterlist.h
@@ -266,12 +266,12 @@ int sg_alloc_table_from_pages(struct sg_
 	gfp_t gfp_mask);
 
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
-			   void *buf, size_t buflen);
+			   const void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen);
 
 size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
-			    void *buf, size_t buflen, off_t skip);
+			    const void *buf, size_t buflen, off_t skip);
 size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			  void *buf, size_t buflen, off_t skip);
 
diff -puN lib/scatterlist.c~lib-scatterlist-mark-input-buffer-parameters-as-const lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-mark-input-buffer-parameters-as-const
+++ a/lib/scatterlist.c
@@ -701,9 +701,9 @@ static size_t sg_copy_buffer(struct scat
  *
  **/
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
-			   void *buf, size_t buflen)
+			   const void *buf, size_t buflen)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, 0, false);
+	return sg_copy_buffer(sgl, nents, (void *)buf, buflen, 0, false);
 }
 EXPORT_SYMBOL(sg_copy_from_buffer);
 
@@ -736,9 +736,9 @@ EXPORT_SYMBOL(sg_copy_to_buffer);
  *
  **/
 size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
-			    void *buf, size_t buflen, off_t skip)
+			    const void *buf, size_t buflen, off_t skip)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, skip, false);
+	return sg_copy_buffer(sgl, nents, (void *)buf, buflen, skip, false);
 }
 EXPORT_SYMBOL(sg_pcopy_from_buffer);
 
_

Patches currently in -mm which might be from david.s.gordon@intel.com are


