From: akpm@linux-foundation.org
Subject: + zram-add-more-compression-algorithms.patch added to -mm tree
Date: Tue, 31 May 2016 12:10:52 -0700
Message-ID: <574de1bc.jZktzHf+S39HUOkv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbcEaTKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:10:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add more compression algorithms
has been added to the -mm tree.  Its filename is
     zram-add-more-compression-algorithms.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-add-more-compression-algorithms.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-add-more-compression-algorithms.patch

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
Subject: zram: add more compression algorithms

Add "deflate", "lz4hc", "842" algorithms to the list of known compression
backends.  The real availability of those algorithms, however, depends on
the corresponding CONFIG_CRYPTO_FOO config options.

Link: http://lkml.kernel.org/r/20160531122017.2878-8-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/block/zram/zcomp.c~zram-add-more-compression-algorithms drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-add-more-compression-algorithms
+++ a/drivers/block/zram/zcomp.c
@@ -21,6 +21,9 @@
 static const char * const backends[] = {
 	"lzo",
 	"lz4",
+	"deflate",
+	"lz4hc",
+	"842",
 	NULL
 };
 
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

