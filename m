From: akpm@linux-foundation.org
Subject: + zram-use-crypto-api-to-check-alg-availability.patch added to
 -mm tree
Date: Tue, 31 May 2016 12:10:46 -0700
Message-ID: <574de1b6.Ro55ZtbJfX1Hea7S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbcEaTKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use crypto api to check alg availability
has been added to the -mm tree.  Its filename is
     zram-use-crypto-api-to-check-alg-availability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-crypto-api-to-check-alg-availability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-crypto-api-to-check-alg-availability.patch

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
Subject: zram: use crypto api to check alg availability

There is no way to get a string with all the crypto comp algorithms
supported by the crypto comp engine, so we need to maintain our own
backends list.  At the same time we additionally need to use
crypto_has_comp() to make sure that the user has requested a compression
algorithm that is recognized by the crypto comp engine.  Relying on
/proc/crypto is not an options here, because it does not show
not-yet-inserted compression modules.

Example:

 modprobe zram
 cat /proc/crypto | grep -i lz4
 modprobe lz4
 cat /proc/crypto | grep -i lz4
name         : lz4
driver       : lz4-generic
module       : lz4

So the user can't tell exactly if the lz4 is really supported from
/proc/crypto output, unless someone or something has loaded it.

This patch also adds crypto_has_comp() to zcomp_available_show().  We
store all the compression algorithms names in zcomp's `backends' array,
regardless the CONFIG_CRYPTO_FOO configuration, but show only those that
are also supported by crypto engine.  This helps user to know the exact
list of compression algorithms that can be used.

Example:
  module lz4 is not loaded yet, but is supported by the crypto
  engine. /proc/crypto has no information on this module, while
  zram's `comp_algorithm' lists it:

 cat /proc/crypto | grep -i lz4

 cat /sys/block/zram0/comp_algorithm
[lzo] lz4 deflate lz4hc 842

We also now fully rely on crypto_has_comp() when configure a new device. 
The existing `backends' array is kept for user's convenience only -- there
is no way to list all of the compression algorithms supported by crypto --
and is not guaranteed to contain every compression module name supported
by the kernel.  Switch to crypto_has_comp() has an advantage of permitting
the usage of out-of-tree crypto compression modules (implementing S/W or
H/W compression).

Link: http://lkml.kernel.org/r/20160531122017.2878-5-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |   11 +++++
 drivers/block/zram/zcomp.c      |   58 +++++++++++++++++-------------
 drivers/block/zram/zram_drv.c   |   16 ++++----
 drivers/block/zram/zram_drv.h   |    5 +-
 4 files changed, 57 insertions(+), 33 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-use-crypto-api-to-check-alg-availability Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-use-crypto-api-to-check-alg-availability
+++ a/Documentation/blockdev/zram.txt
@@ -83,6 +83,17 @@ pre-created. Default: 1.
 	#select lzo compression algorithm
 	echo lzo > /sys/block/zram0/comp_algorithm
 
+	For the time being, the `comp_algorithm' content does not necessarily
+	show every compression algorithm supported by the kernel. We keep this
+	list primarily to simplify device configuration and one can configure
+	a new device with a compression algorithm that is not listed in
+	`comp_algorithm'. The thing is that, internally, ZRAM uses Crypto API
+	and, if some of the algorithms were built as modules, it's impossible
+	to list all of them using, for instance, /proc/crypto or any other
+	method. This, however, has an advantage of permitting the usage of
+	custom crypto compression modules (implementing S/W or H/W
+	compression).
+
 4) Set Disksize
         Set disk size by writing the value to sysfs node 'disksize'.
         The value can be either in bytes or you can use mem suffixes.
diff -puN drivers/block/zram/zcomp.c~zram-use-crypto-api-to-check-alg-availability drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-use-crypto-api-to-check-alg-availability
+++ a/drivers/block/zram/zcomp.c
@@ -26,17 +26,6 @@ static const char * const backends[] = {
 	NULL
 };
 
-static const char *find_backend(const char *compress)
-{
-	int i = 0;
-	while (backends[i]) {
-		if (sysfs_streq(compress, backends[i]))
-			break;
-		i++;
-	}
-	return backends[i];
-}
-
 static void zcomp_strm_free(struct zcomp_strm *zstrm)
 {
 	if (!IS_ERR_OR_NULL(zstrm->tfm))
@@ -68,30 +57,53 @@ static struct zcomp_strm *zcomp_strm_all
 	return zstrm;
 }
 
+bool zcomp_available_algorithm(const char *comp)
+{
+	/*
+	 * Crypto does not ignore a trailing new line symbol,
+	 * so make sure you don't supply a string containing
+	 * one.
+	 * This also means that we keep `backends' array for
+	 * zcomp_available_show() only and will init a new zram
+	 * device with any compressing algorithm known to crypto
+	 * api.
+	 */
+	return crypto_has_comp(comp, 0, 0) == 1;
+}
+
 /* show available compressors */
 ssize_t zcomp_available_show(const char *comp, char *buf)
 {
+	bool known_algorithm = false;
 	ssize_t sz = 0;
 	int i = 0;
 
-	while (backends[i]) {
-		if (!strcmp(comp, backends[i]))
+	for (; backends[i]; i++) {
+		if (!zcomp_available_algorithm(backends[i]))
+			continue;
+
+		if (!strcmp(comp, backends[i])) {
+			known_algorithm = true;
 			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
 					"[%s] ", backends[i]);
-		else
+		} else {
 			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
 					"%s ", backends[i]);
-		i++;
+		}
 	}
+
+	/*
+	 * Out-of-tree module known to crypto api or a missing
+	 * entry in `backends'.
+	 */
+	if (!known_algorithm && zcomp_available_algorithm(comp))
+		sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
+				"[%s] ", comp);
+
 	sz += scnprintf(buf + sz, PAGE_SIZE - sz, "\n");
 	return sz;
 }
 
-bool zcomp_available_algorithm(const char *comp)
-{
-	return find_backend(comp) != NULL;
-}
-
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
 {
 	return *get_cpu_ptr(comp->stream);
@@ -227,18 +239,16 @@ void zcomp_destroy(struct zcomp *comp)
 struct zcomp *zcomp_create(const char *compress)
 {
 	struct zcomp *comp;
-	const char *backend;
 	int error;
 
-	backend = find_backend(compress);
-	if (!backend)
+	if (!zcomp_available_algorithm(compress))
 		return ERR_PTR(-EINVAL);
 
 	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
 	if (!comp)
 		return ERR_PTR(-ENOMEM);
 
-	comp->name = backend;
+	comp->name = compress;
 	error = zcomp_init(comp);
 	if (error) {
 		kfree(comp);
diff -puN drivers/block/zram/zram_drv.c~zram-use-crypto-api-to-check-alg-availability drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-crypto-api-to-check-alg-availability
+++ a/drivers/block/zram/zram_drv.c
@@ -342,9 +342,16 @@ static ssize_t comp_algorithm_store(stru
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
+	char compressor[CRYPTO_MAX_ALG_NAME];
 	size_t sz;
 
-	if (!zcomp_available_algorithm(buf))
+	strlcpy(compressor, buf, sizeof(compressor));
+	/* ignore trailing newline */
+	sz = strlen(compressor);
+	if (sz > 0 && compressor[sz - 1] == '\n')
+		compressor[sz - 1] = 0x00;
+
+	if (!zcomp_available_algorithm(compressor))
 		return -EINVAL;
 
 	down_write(&zram->init_lock);
@@ -353,13 +360,8 @@ static ssize_t comp_algorithm_store(stru
 		pr_info("Can't change algorithm for initialized device\n");
 		return -EBUSY;
 	}
-	strlcpy(zram->compressor, buf, sizeof(zram->compressor));
-
-	/* ignore trailing newline */
-	sz = strlen(zram->compressor);
-	if (sz > 0 && zram->compressor[sz - 1] == '\n')
-		zram->compressor[sz - 1] = 0x00;
 
+	strlcpy(zram->compressor, compressor, sizeof(compressor));
 	up_write(&zram->init_lock);
 	return len;
 }
diff -puN drivers/block/zram/zram_drv.h~zram-use-crypto-api-to-check-alg-availability drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-use-crypto-api-to-check-alg-availability
+++ a/drivers/block/zram/zram_drv.h
@@ -15,8 +15,9 @@
 #ifndef _ZRAM_DRV_H_
 #define _ZRAM_DRV_H_
 
-#include <linux/spinlock.h>
+#include <linux/rwsem.h>
 #include <linux/zsmalloc.h>
+#include <linux/crypto.h>
 
 #include "zcomp.h"
 
@@ -113,7 +114,7 @@ struct zram {
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
-	char compressor[10];
+	char compressor[CRYPTO_MAX_ALG_NAME];
 	/*
 	 * zram is claimed so open request will be failed
 	 */
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-rename-zstrm-find-release-functions.patch
zram-switch-to-crypto-compress-api.patch
zram-align-zcomp-interface-to-crypto-comp-api.patch
zram-use-crypto-api-to-check-alg-availability.patch
zram-cosmetic-cleanup-documentation.patch
zram-delete-custom-lzo-lz4.patch
zram-add-more-compression-algorithms.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch

