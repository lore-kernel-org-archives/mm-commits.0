From: akpm@linux-foundation.org
Subject: + zram-use-crypto-api-to-check-alg-availability-v3.patch added to -mm tree
Date: Wed, 08 Jun 2016 14:12:50 -0700
Message-ID: <57588a52.tJMHYXWwALmpA5Hr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbcFHVMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 17:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-use-crypto-api-to-check-alg-availability-v3
has been added to the -mm tree.  Its filename is
     zram-use-crypto-api-to-check-alg-availability-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-crypto-api-to-check-alg-availability-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-crypto-api-to-check-alg-availability-v3.patch

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
Subject: zram-use-crypto-api-to-check-alg-availability-v3

Link: http://lkml.kernel.org/r/20160604024902.11778-4-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-use-crypto-api-to-check-alg-availability-v3 drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-use-crypto-api-to-check-alg-availability-v3
+++ a/drivers/block/zram/zcomp.c
@@ -59,14 +59,20 @@ static struct zcomp_strm *zcomp_strm_all
 
 bool zcomp_available_algorithm(const char *comp)
 {
+	int i = 0;
+
+	while (backends[i]) {
+		if (sysfs_streq(comp, backends[i]))
+			return true;
+		i++;
+	}
+
 	/*
 	 * Crypto does not ignore a trailing new line symbol,
 	 * so make sure you don't supply a string containing
 	 * one.
-	 * This also means that we keep `backends' array for
-	 * zcomp_available_show() only and will init a new zram
-	 * device with any compressing algorithm known to crypto
-	 * api.
+	 * This also means that we permit zcomp initialisation
+	 * with any compressing algorithm known to crypto api.
 	 */
 	return crypto_has_comp(comp, 0, 0) == 1;
 }
@@ -79,9 +85,6 @@ ssize_t zcomp_available_show(const char
 	int i = 0;
 
 	for (; backends[i]; i++) {
-		if (!zcomp_available_algorithm(backends[i]))
-			continue;
-
 		if (!strcmp(comp, backends[i])) {
 			known_algorithm = true;
 			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
@@ -96,7 +99,7 @@ ssize_t zcomp_available_show(const char
 	 * Out-of-tree module known to crypto api or a missing
 	 * entry in `backends'.
 	 */
-	if (!known_algorithm && zcomp_available_algorithm(comp))
+	if (!known_algorithm && crypto_has_comp(comp, 0, 0) == 1)
 		sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
 				"[%s] ", comp);
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-rename-zstrm-find-release-functions.patch
zram-switch-to-crypto-compress-api.patch
zram-use-crypto-api-to-check-alg-availability.patch
zram-use-crypto-api-to-check-alg-availability-v3.patch
zram-cosmetic-cleanup-documentation.patch
zram-delete-custom-lzo-lz4.patch
zram-delete-custom-lzo-lz4-v3.patch
zram-add-more-compression-algorithms.patch
zram-add-more-compression-algorithms-v3.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch

