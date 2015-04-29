From: akpm@linux-foundation.org
Subject: + lib-scatterlist-mark-input-buffer-parameters-as-const.patch
 added to -mm tree
Date: Wed, 29 Apr 2015 13:15:17 -0700
Message-ID: <55413bd5.LCeeCm62a5b89Nn8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbbD2UPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 16:15:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.s.gordon@intel.com, akinobu.mita@gmail.com, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: mark input buffer parameters as 'const'
has been added to the -mm tree.  Its filename is
     lib-scatterlist-mark-input-buffer-parameters-as-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-mark-input-buffer-parameters-as-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-mark-input-buffer-parameters-as-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -240,12 +240,12 @@ int sg_alloc_table_from_pages(struct sg_
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
@@ -669,9 +669,9 @@ static size_t sg_copy_buffer(struct scat
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
 
@@ -704,9 +704,9 @@ EXPORT_SYMBOL(sg_copy_to_buffer);
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

lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch

