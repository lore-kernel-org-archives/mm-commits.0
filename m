From: akpm@linux-foundation.org
Subject: + zram-user-per-cpu-compression-streams-fix.patch added to -mm
 tree
Date: Tue, 03 May 2016 15:36:00 -0700
Message-ID: <572927d0.q3iAydzptjZCJdfh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbcECWgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2016 18:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-user-per-cpu-compression-streams-fix
has been added to the -mm tree.  Its filename is
     zram-user-per-cpu-compression-streams-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-user-per-cpu-compression-streams-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-user-per-cpu-compression-streams-fix.patch

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
Subject: zram-user-per-cpu-compression-streams-fix

a very minor clean up, noted by Minchan.

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    4 ++--
 drivers/block/zram/zcomp.h    |    2 +-
 drivers/block/zram/zram_drv.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-user-per-cpu-compression-streams-fix drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-user-per-cpu-compression-streams-fix
+++ a/drivers/block/zram/zcomp.c
@@ -209,9 +209,9 @@ void zcomp_destroy(struct zcomp *comp)
  * backend pointer or ERR_PTR if things went bad. ERR_PTR(-EINVAL)
  * if requested algorithm is not supported, ERR_PTR(-ENOMEM) in
  * case of allocation error, or any other error potentially
- * returned by functions zcomp_strm_{multi,single}_create.
+ * returned by zcomp_init().
  */
-struct zcomp *zcomp_create(const char *compress, int max_strm)
+struct zcomp *zcomp_create(const char *compress)
 {
 	struct zcomp *comp;
 	struct zcomp_backend *backend;
diff -puN drivers/block/zram/zcomp.h~zram-user-per-cpu-compression-streams-fix drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-user-per-cpu-compression-streams-fix
+++ a/drivers/block/zram/zcomp.h
@@ -45,7 +45,7 @@ struct zcomp {
 ssize_t zcomp_available_show(const char *comp, char *buf);
 bool zcomp_available_algorithm(const char *comp);
 
-struct zcomp *zcomp_create(const char *comp, int max_strm);
+struct zcomp *zcomp_create(const char *comp);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
diff -puN drivers/block/zram/zram_drv.c~zram-user-per-cpu-compression-streams-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-user-per-cpu-compression-streams-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1064,7 +1064,7 @@ static ssize_t disksize_store(struct dev
 	if (!meta)
 		return -ENOMEM;
 
-	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
+	comp = zcomp_create(zram->compressor);
 	if (IS_ERR(comp)) {
 		pr_err("Cannot initialise %s compressing backend\n",
 				zram->compressor);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-require-gfp-in-zs_malloc.patch
zsmalloc-require-gfp-in-zs_malloc-v2.patch
zram-user-per-cpu-compression-streams.patch
zram-user-per-cpu-compression-streams-fix.patch

