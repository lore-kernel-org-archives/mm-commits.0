Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795DEC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbjDFCy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbjDFCxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F232C1
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F6B963237
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF44C433D2;
        Thu,  6 Apr 2023 02:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749596;
        bh=d8GInPibHE+2D/MYPOuXUty6SMRaQR6nplKTE3XxSZ0=;
        h=Date:To:From:Subject:From;
        b=RlCYRGaScC096oOPyEEzZR2annlQibeo0WPNQNhqrUCpnYHWIcB6rghpd/Tok/QcW
         Dnr/NWVsYG/fBUduBwKh0S33k+ySqR4vgWtiWc6FzgTQCpCjdG/5aW2n18Mj0vIbEm
         9T6vRZMMwLVTPbxFuBDPeqILGGFfkEZzppze2Xec=
Date:   Wed, 05 Apr 2023 19:53:16 -0700
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernelh-split-the-hexadecimal-related-helpers-to-hexh.patch removed from -mm tree
Message-Id: <20230406025316.CAF44C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel.h: split the hexadecimal related helpers to hex.h
has been removed from the -mm tree.  Its filename was
     kernelh-split-the-hexadecimal-related-helpers-to-hexh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: split the hexadecimal related helpers to hex.h
Date: Thu, 23 Mar 2023 17:50:29 +0200

For the sake of cleaning up the kernel.h split the hexadecimal related
helpers to own header called 'hex.h'.

Link: https://lkml.kernel.org/r/20230323155029.40000-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hex.h    |   35 +++++++++++++++++++++++++++++++++++
 include/linux/kernel.h |   29 +----------------------------
 2 files changed, 36 insertions(+), 28 deletions(-)

--- /dev/null
+++ a/include/linux/hex.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_HEX_H
+#define _LINUX_HEX_H
+
+#include <linux/types.h>
+
+extern const char hex_asc[];
+#define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
+#define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
+
+static inline char *hex_byte_pack(char *buf, u8 byte)
+{
+	*buf++ = hex_asc_hi(byte);
+	*buf++ = hex_asc_lo(byte);
+	return buf;
+}
+
+extern const char hex_asc_upper[];
+#define hex_asc_upper_lo(x)	hex_asc_upper[((x) & 0x0f)]
+#define hex_asc_upper_hi(x)	hex_asc_upper[((x) & 0xf0) >> 4]
+
+static inline char *hex_byte_pack_upper(char *buf, u8 byte)
+{
+	*buf++ = hex_asc_upper_hi(byte);
+	*buf++ = hex_asc_upper_lo(byte);
+	return buf;
+}
+
+extern int hex_to_bin(unsigned char ch);
+extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
+extern char *bin2hex(char *dst, const void *src, size_t count);
+
+bool mac_pton(const char *s, u8 *mac);
+
+#endif
--- a/include/linux/kernel.h~kernelh-split-the-hexadecimal-related-helpers-to-hexh
+++ a/include/linux/kernel.h
@@ -20,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/container_of.h>
 #include <linux/bitops.h>
+#include <linux/hex.h>
 #include <linux/kstrtox.h>
 #include <linux/log2.h>
 #include <linux/math.h>
@@ -263,34 +264,6 @@ extern enum system_states {
 	SYSTEM_SUSPEND,
 } system_state;
 
-extern const char hex_asc[];
-#define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
-#define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
-
-static inline char *hex_byte_pack(char *buf, u8 byte)
-{
-	*buf++ = hex_asc_hi(byte);
-	*buf++ = hex_asc_lo(byte);
-	return buf;
-}
-
-extern const char hex_asc_upper[];
-#define hex_asc_upper_lo(x)	hex_asc_upper[((x) & 0x0f)]
-#define hex_asc_upper_hi(x)	hex_asc_upper[((x) & 0xf0) >> 4]
-
-static inline char *hex_byte_pack_upper(char *buf, u8 byte)
-{
-	*buf++ = hex_asc_upper_hi(byte);
-	*buf++ = hex_asc_upper_lo(byte);
-	return buf;
-}
-
-extern int hex_to_bin(unsigned char ch);
-extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
-extern char *bin2hex(char *dst, const void *src, size_t count);
-
-bool mac_pton(const char *s, u8 *mac);
-
 /*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


