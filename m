Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAB4C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4743021D1B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgL2XP4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL2XPz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:15:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B18021D1B;
        Tue, 29 Dec 2020 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283705;
        bh=GE5GHuwFJDT3/4zIbtS3dpOWvJuWmD7rRTXESYC96L4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DEKaykU0wisJrXLXHIfVVO8KMhaN4y0AWqNGagv9lm+L9cCY5fsBihnP1lMQbuGUr
         /HqXEffZ5KqtJ2jBLjgvjR8+cV1yZx7ayt4LvGk7LCQOZDti8y2YwAYdMZ5sysYtYq
         7Grjn7MfBaJc32MdEgqV3NoLeGknxqV4VQX+qoYA=
Date:   Tue, 29 Dec 2020 15:15:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, iii@linux.ibm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        zaslonko@linux.ibm.com
Subject:  [patch 15/16] zlib: move EXPORT_SYMBOL() and
 MODULE_LICENSE() out of dfltcc_syms.c
Message-ID: <20201229231504.R7cT98sub%akpm@linux-foundation.org>
In-Reply-To: <20201229151349.3285926ec0d1f65a27ac8534@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: zlib: move EXPORT_SYMBOL() and MODULE_LICENSE() out of dfltcc_syms.c

In 11fb479ff5d9 ("zlib: export S390 symbols for zlib modules"), I added
EXPORT_SYMBOL()s to dfltcc_inflate.c but then Mikhail said that these
should probably be in dfltcc_syms.c with the other EXPORT_SYMBOL()s.

However, that is contrary to the current kernel style, which places
EXPORT_SYMBOL() immediately after the function that it applies to,
so move all EXPORT_SYMBOL()s to their respective function locations
and drop the dfltcc_syms.c file. Also move MODULE_LICENSE() from the
deleted file to dfltcc.c.

[rdunlap@infradead.org: remove dfltcc_syms.o from Makefile]
  Link: https://lkml.kernel.org/r/20201227171837.15492-1-rdunlap@infradead.org
Link: https://lkml.kernel.org/r/20201219052530.28461-1-rdunlap@infradead.org
Fixes: 11fb479ff5d9 ("zlib: export S390 symbols for zlib modules")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Zaslonko Mikhail <zaslonko@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_dfltcc/Makefile         |    2 +-
 lib/zlib_dfltcc/dfltcc.c         |    6 +++++-
 lib/zlib_dfltcc/dfltcc_deflate.c |    3 +++
 lib/zlib_dfltcc/dfltcc_syms.c    |   17 -----------------
 4 files changed, 9 insertions(+), 19 deletions(-)

--- a/lib/zlib_dfltcc/dfltcc.c~zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc
+++ a/lib/zlib_dfltcc/dfltcc.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: Zlib
 /* dfltcc.c - SystemZ DEFLATE CONVERSION CALL support. */
 
-#include <linux/zutil.h>
+#include <linux/export.h>
+#include <linux/module.h>
 #include "dfltcc_util.h"
 #include "dfltcc.h"
 
@@ -53,3 +54,6 @@ void dfltcc_reset(
     dfltcc_state->dht_threshold = DFLTCC_DHT_MIN_SAMPLE_SIZE;
     dfltcc_state->param.ribm = DFLTCC_RIBM;
 }
+EXPORT_SYMBOL(dfltcc_reset);
+
+MODULE_LICENSE("GPL");
--- a/lib/zlib_dfltcc/dfltcc_deflate.c~zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc
+++ a/lib/zlib_dfltcc/dfltcc_deflate.c
@@ -4,6 +4,7 @@
 #include "dfltcc_util.h"
 #include "dfltcc.h"
 #include <asm/setup.h>
+#include <linux/export.h>
 #include <linux/zutil.h>
 
 /*
@@ -34,6 +35,7 @@ int dfltcc_can_deflate(
 
     return 1;
 }
+EXPORT_SYMBOL(dfltcc_can_deflate);
 
 static void dfltcc_gdht(
     z_streamp strm
@@ -277,3 +279,4 @@ again:
         goto again; /* deflate() must use all input or all output */
     return 1;
 }
+EXPORT_SYMBOL(dfltcc_deflate);
--- a/lib/zlib_dfltcc/dfltcc_syms.c
+++ /dev/null
@@ -1,17 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * linux/lib/zlib_dfltcc/dfltcc_syms.c
- *
- * Exported symbols for the s390 zlib dfltcc support.
- *
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/zlib.h>
-#include "dfltcc.h"
-
-EXPORT_SYMBOL(dfltcc_can_deflate);
-EXPORT_SYMBOL(dfltcc_deflate);
-EXPORT_SYMBOL(dfltcc_reset);
-MODULE_LICENSE("GPL");
--- a/lib/zlib_dfltcc/Makefile~zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc
+++ a/lib/zlib_dfltcc/Makefile
@@ -8,4 +8,4 @@
 
 obj-$(CONFIG_ZLIB_DFLTCC) += zlib_dfltcc.o
 
-zlib_dfltcc-objs := dfltcc.o dfltcc_deflate.o dfltcc_inflate.o dfltcc_syms.o
+zlib_dfltcc-objs := dfltcc.o dfltcc_deflate.o dfltcc_inflate.o
_
