From: akpm@linux-foundation.org
Subject: + zswap-change-zpool-compressor-at-runtime-fix.patch added to -mm tree
Date: Fri, 07 Aug 2015 15:15:47 -0700
Message-ID: <55c52e13.D+dIo239sWsHFcej%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946271AbbHGWPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 18:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sergey.senozhatsky.work@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: comment clarifying maxlen
has been added to the -mm tree.  Its filename is
     zswap-change-zpool-compressor-at-runtime-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-change-zpool-compressor-at-runtime-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-change-zpool-compressor-at-runtime-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: comment clarifying maxlen

Add a comment clarifying the variable-size array created on the stack will
always be either CRYPTO_MAX_ALG_NAME (64) or 32 bytes long.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/zswap.c~zswap-change-zpool-compressor-at-runtime-fix mm/zswap.c
--- a/mm/zswap.c~zswap-change-zpool-compressor-at-runtime-fix
+++ a/mm/zswap.c
@@ -691,6 +691,11 @@ static int __zswap_param_set(const char
 	char str[kp->str->maxlen], *s;
 	int ret;
 
+	/*
+	 * kp is either zswap_zpool_kparam or zswap_compressor_kparam, defined
+	 * at the top of this file, so maxlen is CRYPTO_MAX_ALG_NAME (64) or
+	 * 32 (arbitrary).
+	 */
 	strlcpy(str, val, kp->str->maxlen);
 	s = strim(str);
 
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zpool-constify-the-zpool_ops.patch
mm-zbud-constify-the-zbud_ops.patch
zpool-add-zpool_has_pool.patch
zpool-add-zpool_has_pool-fix.patch
zswap-dynamic-pool-creation.patch
zswap-dynamic-pool-creation-fix.patch
zswap-change-zpool-compressor-at-runtime.patch
zswap-change-zpool-compressor-at-runtime-fix.patch
linux-next.patch

