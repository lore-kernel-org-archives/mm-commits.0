Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC42C6FD1C
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 21:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjCWV35 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 17:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjCWV34 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 17:29:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6198BDC9
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 14:29:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F7D1B82278
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 21:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45205C433EF;
        Thu, 23 Mar 2023 21:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679606992;
        bh=LzvNGPGxatd6x7IeF4lQ1ZpA6QwrRwRLyqDypoTNV1I=;
        h=Date:To:From:Subject:From;
        b=FxkTT/blEnAV8zVFM1ilf39OzHNec7Ne+xzz+ZE/6BlBKTGNCodrIDXEgm7Wbu9ep
         ofyBzpIkx0LMLFuKE4XvCQlGUwgzRmppH7bugumQ+yjcOdkVUfIoZ6faHxFhrd/kvl
         CiPiWT8acMUp6l67FsMT2AUm4V/jKI9sV1G3g4+k=
Date:   Thu, 23 Mar 2023 14:29:51 -0700
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-split-the-hexadecimal-related-helpers-to-hexh.patch added to mm-nonmm-unstable branch
Message-Id: <20230323212952.45205C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: split the hexadecimal related helpers to hex.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernelh-split-the-hexadecimal-related-helpers-to-hexh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelh-split-the-hexadecimal-related-helpers-to-hexh.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

kernelh-split-the-hexadecimal-related-helpers-to-hexh.patch

