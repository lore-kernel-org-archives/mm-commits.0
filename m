Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B60C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFC3161452
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbhKICiC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKICiB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BEA96137F;
        Tue,  9 Nov 2021 02:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425316;
        bh=bOzUB8ET3FOeLS2tw/7bWe/I8VFKnh845VYNWKIX+bU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JY+SS3+12uVTMlnzonqB3AdayF8BvePM3/+pAO0UoOs8M29TpsZLb7YB6ui32DIX7
         1wjxU5uwfeFCfsyLssKBeFZLur8HoqCKqxNqsPl4fX/VEItfy6+i3NJK2je8uowGIk
         9Q8liJ8/C7TRSmDfjYw+o595hUzZWkPZFHBJCfxY=
Date:   Mon, 08 Nov 2021 18:35:16 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 72/87] seq_file: move seq_escape() to a header
Message-ID: <20211109023516.l5Dniqrh2%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: seq_file: move seq_escape() to a header

Move seq_escape() to the header as inliner, for a small kernel text size
reduction.

Link: https://lkml.kernel.org/r/20211001122917.67228-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   16 ----------------
 include/linux/seq_file.h |   17 ++++++++++++++++-
 2 files changed, 16 insertions(+), 17 deletions(-)

--- a/fs/seq_file.c~seq_file-move-seq_escape-to-a-header
+++ a/fs/seq_file.c
@@ -383,22 +383,6 @@ void seq_escape_mem(struct seq_file *m,
 }
 EXPORT_SYMBOL(seq_escape_mem);
 
-/**
- *	seq_escape -	print string into buffer, escaping some characters
- *	@m:	target buffer
- *	@s:	string
- *	@esc:	set of characters that need escaping
- *
- *	Puts string into buffer, replacing each occurrence of character from
- *	@esc with usual octal escape.
- *	Use seq_has_overflowed() to check for errors.
- */
-void seq_escape(struct seq_file *m, const char *s, const char *esc)
-{
-	seq_escape_str(m, s, ESCAPE_OCTAL, esc);
-}
-EXPORT_SYMBOL(seq_escape);
-
 void seq_vprintf(struct seq_file *m, const char *f, va_list args)
 {
 	int len;
--- a/include/linux/seq_file.h~seq_file-move-seq_escape-to-a-header
+++ a/include/linux/seq_file.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/bug.h>
 #include <linux/mutex.h>
 #include <linux/cpumask.h>
@@ -135,7 +136,21 @@ static inline void seq_escape_str(struct
 	seq_escape_mem(m, src, strlen(src), flags, esc);
 }
 
-void seq_escape(struct seq_file *m, const char *s, const char *esc);
+/**
+ * seq_escape - print string into buffer, escaping some characters
+ * @m: target buffer
+ * @s: NULL-terminated string
+ * @esc: set of characters that need escaping
+ *
+ * Puts string into buffer, replacing each occurrence of character from
+ * @esc with usual octal escape.
+ *
+ * Use seq_has_overflowed() to check for errors.
+ */
+static inline void seq_escape(struct seq_file *m, const char *s, const char *esc)
+{
+	seq_escape_str(m, s, ESCAPE_OCTAL, esc);
+}
 
 void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
 		  int rowsize, int groupsize, const void *buf, size_t len,
_
