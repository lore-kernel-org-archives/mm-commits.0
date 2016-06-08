From: akpm@linux-foundation.org
Subject: + zram-delete-custom-lzo-lz4-v3.patch added to -mm tree
Date: Wed, 08 Jun 2016 14:12:53 -0700
Message-ID: <57588a55.LMLl7hdnA4pvb8Z/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbcFHVMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 17:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-delete-custom-lzo-lz4-v3
has been added to the -mm tree.  Its filename is
     zram-delete-custom-lzo-lz4-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-delete-custom-lzo-lz4-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-delete-custom-lzo-lz4-v3.patch

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
Subject: zram-delete-custom-lzo-lz4-v3

Link: http://lkml.kernel.org/r/20160604024902.11778-6-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/zram/zcomp.c~zram-delete-custom-lzo-lz4-v3 drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-delete-custom-lzo-lz4-v3
+++ a/drivers/block/zram/zcomp.c
@@ -20,7 +20,9 @@
 
 static const char * const backends[] = {
 	"lzo",
+#if IS_ENABLED(CONFIG_CRYPTO_LZ4)
 	"lz4",
+#endif
 	NULL
 };
 
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

