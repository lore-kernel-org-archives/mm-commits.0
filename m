From: akpm@linux-foundation.org
Subject: [merged] zram-factor-out-single-stream-compression.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:07:09 -0700
Message-ID: <534464fd.YNc7qtPzDCf4U9gX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbaDHVHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:07:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-factor-out-single-stream-compression.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:07:09 -0700


The patch titled
     Subject: zram: factor out single stream compression
has been removed from the -mm tree.  Its filename was
     zram-factor-out-single-stream-compression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: factor out single stream compression

This is preparation patch to add multi stream support to zcomp.

Introduce struct zcomp_strm_single and a set of functions to manage
zcomp_strm stream access.  zcomp_strm_single implements single compession
stream, same way as current zcomp implementation.  This moves zcomp_strm
stream control and locking from zcomp, so compressing backend zcomp is not
aware of required locking.

Single and multi streams require different locking schemes.  Minchan Kim
reported that spinlock-based locking scheme (which is used in multi stream
implementation) has demonstrated a severe perfomance regression for single
compression stream case, comparing to mutex-based.  see
https://lkml.org/lkml/2014/2/18/16

The following set of functions added:
- zcomp_strm_single_find()/zcomp_strm_single_release()
  find and release a compression stream, implement required locking
- zcomp_strm_single_create()/zcomp_strm_single_destroy()
  create and destroy zcomp_strm_single

New ->strm_find() and ->strm_release() callbacks added to zcomp, which are
set to zcomp_strm_single_find() and zcomp_strm_single_release() during
initialisation.  Instead of direct locking and zcomp_strm access from
zcomp_strm_find() and zcomp_strm_release(), zcomp now calls ->strm_find()
and ->strm_release() correspondingly.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |   62 ++++++++++++++++++++++++++++++-----
 drivers/block/zram/zcomp.h |    7 ++-
 2 files changed, 59 insertions(+), 10 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-factor-out-single-stream-compression drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-factor-out-single-stream-compression
+++ a/drivers/block/zram/zcomp.c
@@ -16,6 +16,14 @@
 #include "zcomp.h"
 #include "zcomp_lzo.h"
 
+/*
+ * single zcomp_strm backend
+ */
+struct zcomp_strm_single {
+	struct mutex strm_lock;
+	struct zcomp_strm *zstrm;
+};
+
 static struct zcomp_backend *find_backend(const char *compress)
 {
 	if (strncmp(compress, "lzo", 3) == 0)
@@ -54,15 +62,56 @@ static struct zcomp_strm *zcomp_strm_all
 	return zstrm;
 }
 
+static struct zcomp_strm *zcomp_strm_single_find(struct zcomp *comp)
+{
+	struct zcomp_strm_single *zs = comp->stream;
+	mutex_lock(&zs->strm_lock);
+	return zs->zstrm;
+}
+
+static void zcomp_strm_single_release(struct zcomp *comp,
+		struct zcomp_strm *zstrm)
+{
+	struct zcomp_strm_single *zs = comp->stream;
+	mutex_unlock(&zs->strm_lock);
+}
+
+static void zcomp_strm_single_destroy(struct zcomp *comp)
+{
+	struct zcomp_strm_single *zs = comp->stream;
+	zcomp_strm_free(comp, zs->zstrm);
+	kfree(zs);
+}
+
+static int zcomp_strm_single_create(struct zcomp *comp)
+{
+	struct zcomp_strm_single *zs;
+
+	comp->destroy = zcomp_strm_single_destroy;
+	comp->strm_find = zcomp_strm_single_find;
+	comp->strm_release = zcomp_strm_single_release;
+	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
+	if (!zs)
+		return -ENOMEM;
+
+	comp->stream = zs;
+	mutex_init(&zs->strm_lock);
+	zs->zstrm = zcomp_strm_alloc(comp);
+	if (!zs->zstrm) {
+		kfree(zs);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
 {
-	mutex_lock(&comp->strm_lock);
-	return comp->zstrm;
+	return comp->strm_find(comp);
 }
 
 void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	mutex_unlock(&comp->strm_lock);
+	comp->strm_release(comp, zstrm);
 }
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
@@ -80,7 +129,7 @@ int zcomp_decompress(struct zcomp *comp,
 
 void zcomp_destroy(struct zcomp *comp)
 {
-	zcomp_strm_free(comp, comp->zstrm);
+	comp->destroy(comp);
 	kfree(comp);
 }
 
@@ -104,10 +153,7 @@ struct zcomp *zcomp_create(const char *c
 		return NULL;
 
 	comp->backend = backend;
-	mutex_init(&comp->strm_lock);
-
-	comp->zstrm = zcomp_strm_alloc(comp);
-	if (!comp->zstrm) {
+	if (zcomp_strm_single_create(comp) != 0) {
 		kfree(comp);
 		return NULL;
 	}
diff -puN drivers/block/zram/zcomp.h~zram-factor-out-single-stream-compression drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-factor-out-single-stream-compression
+++ a/drivers/block/zram/zcomp.h
@@ -39,9 +39,12 @@ struct zcomp_backend {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	struct mutex strm_lock;
-	struct zcomp_strm *zstrm;
+	void *stream;
 	struct zcomp_backend *backend;
+
+	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
+	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
+	void (*destroy)(struct zcomp *comp);
 };
 
 struct zcomp *zcomp_create(const char *comp);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

