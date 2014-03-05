From: akpm@linux-foundation.org
Subject: + zram-return-error-valued-pointer-from-zcomp_create.patch added
 to -mm tree
Date: Wed, 05 Mar 2014 12:13:38 -0800
Message-ID: <53178572.eElLUR7qIwSgwg14%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaCEUNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 15:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-return-error-valued-pointer-from-zcomp_create.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 12:13:38 -0800


The patch titled
     Subject: zram: return error-valued pointer from zcomp_create()
has been added to the -mm tree.  Its filename is
     zram-return-error-valued-pointer-from-zcomp_create.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-return-error-valued-pointer-from-zcomp_create.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-return-error-valued-pointer-from-zcomp_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: return error-valued pointer from zcomp_create()

Instead of returning just NULL, return ERR_PTR from zcomp_create() if
compressing backend creation has failed.  ERR_PTR(-EINVAL) for unsupported
compression algorithm request, ERR_PTR(-ENOMEM) for allocation (zcomp or
compression stream) error.

Perform IS_ERR() check of returned from zcomp_create() value in
disksize_store() and set return code to PTR_ERR().

Change suggested by Jerome Marchand.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |   13 +++++++------
 drivers/block/zram/zram_drv.c |    8 ++++----
 2 files changed, 11 insertions(+), 10 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-return-error-valued-pointer-from-zcomp_create drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-return-error-valued-pointer-from-zcomp_create
+++ a/drivers/block/zram/zcomp.c
@@ -319,9 +319,10 @@ void zcomp_destroy(struct zcomp *comp)
 
 /*
  * search available compressors for requested algorithm.
- * allocate new zcomp and initialize it. return NULL
- * if requested algorithm is not supported or in case
- * of init error
+ * allocate new zcomp and initialize it. return compressing
+ * backend pointer or ERR_PTR if things went bad. ERR_PTR(-EINVAL)
+ * if requested algorithm is not supported, ERR_PTR(-ENOMEM) in
+ * case of allocation error.
  */
 struct zcomp *zcomp_create(const char *compress, int max_strm)
 {
@@ -330,11 +331,11 @@ struct zcomp *zcomp_create(const char *c
 
 	backend = find_backend(compress);
 	if (!backend)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
 	if (!comp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	comp->backend = backend;
 	if (max_strm > 1)
@@ -343,7 +344,7 @@ struct zcomp *zcomp_create(const char *c
 		zcomp_strm_single_create(comp);
 	if (!comp->stream) {
 		kfree(comp);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	return comp;
 }
diff -puN drivers/block/zram/zram_drv.c~zram-return-error-valued-pointer-from-zcomp_create drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-return-error-valued-pointer-from-zcomp_create
+++ a/drivers/block/zram/zram_drv.c
@@ -583,7 +583,7 @@ static ssize_t disksize_store(struct dev
 	struct zcomp *comp;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
-	int err = -EINVAL;
+	int err = -EBUSY;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -595,9 +595,10 @@ static ssize_t disksize_store(struct dev
 		return -ENOMEM;
 
 	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
-	if (!comp) {
+	if (IS_ERR(comp)) {
 		pr_info("Cannot initialise %s compressing backend\n",
 				zram->compressor);
+		err = PTR_ERR(comp);
 		goto out_cleanup;
 	}
 
@@ -605,7 +606,6 @@ static ssize_t disksize_store(struct dev
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
-		err = -EBUSY;
 		goto out_cleanup;
 	}
 
@@ -618,7 +618,7 @@ static ssize_t disksize_store(struct dev
 	return len;
 
 out_cleanup:
-	if (comp)
+	if (!IS_ERR(comp))
 		zcomp_destroy(comp);
 	zram_meta_free(meta);
 	return err;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch
zram-delete-zram_init_device.patch
zram-delete-zram_init_device-fix.patch
zram-introduce-compressing-backend-abstraction.patch
zram-use-zcomp-compressing-backends.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-factor-out-single-stream-compression.patch
zram-add-multi-stream-functionality.patch
zram-add-set_max_streams-knob.patch
zram-make-compression-algorithm-selection-possible.patch
zram-add-lz4-algorithm-backend.patch
zram-move-comp-allocation-out-of-init_lock.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch

