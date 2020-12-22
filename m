Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7027FC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D6AA22AB9
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgLVUjG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:39:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgLVUjF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:39:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3FD1224F4;
        Tue, 22 Dec 2020 20:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608669505;
        bh=gisp+0ZrWn7mV5tIl4pOTt+FmMAf48I3fG2aucB8CGc=;
        h=Date:From:To:Subject:From;
        b=cu9OWDDvjm1j/dKG4HDGCU1kZnwAjn1fOjsIWgi8eIkWkIR/4PIWW2MzMIPgntadH
         gqp4vRReVu5AwhekW5FdAGPdviiX5vRnv45/+IFw5RlUTO5y+m3/TIQ+pr7JzjwUwb
         2w0FuysXmerqZOjWXWLmhl+h8/LfIilX0lnpE2FE=
Date:   Tue, 22 Dec 2020 12:38:24 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zaslonko@linux.ibm.com,
        iii@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, rdunlap@infradead.org
Subject:  +
 zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch added to
 -mm tree
Message-ID: <20201222203824.9CBem%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zlib: move EXPORT_SYMBOL() and MODULE_LICENSE() out of dfltcc_syms.c
has been added to the -mm tree.  Its filename is
     zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20201219052530.28461-1-rdunlap@infradead.org
Fixes: 11fb479ff5d9 ("zlib: export S390 symbols for zlib modules")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Zaslonko Mikhail <zaslonko@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_dfltcc/dfltcc.c         |    6 +++++-
 lib/zlib_dfltcc/dfltcc_deflate.c |    3 +++
 lib/zlib_dfltcc/dfltcc_syms.c    |   17 -----------------
 3 files changed, 8 insertions(+), 18 deletions(-)

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
_

Patches currently in -mm which might be from rdunlap@infradead.org are

zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch

