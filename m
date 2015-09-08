From: akpm@linux-foundation.org
Subject: [folded-merged]
 zswap-change-zpool-compressor-at-runtime-fix.patch removed from -mm tree
Date: Tue, 08 Sep 2015 14:47:32 -0700
Message-ID: <55ef5774.Yy5iMbcWAD/m3tWO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbbIHVrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sergey.senozhatsky.work@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: comment clarifying maxlen
has been removed from the -mm tree.  Its filename was
     zswap-change-zpool-compressor-at-runtime-fix.patch

This patch was dropped because it was folded into zswap-change-zpool-compressor-at-runtime.patch

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

zpool-add-zpool_has_pool.patch
zswap-dynamic-pool-creation.patch
zswap-change-zpool-compressor-at-runtime.patch
zswap-update-docs-for-runtime-changeable-attributes.patch
zswap-update-docs-for-runtime-changeable-attributes-v2.patch
zpool-remove-no-op-module-init-exit.patch

