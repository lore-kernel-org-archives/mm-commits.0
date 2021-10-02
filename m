Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DE6C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  2 Oct 2021 17:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05637615A4
	for <mm-commits@archiver.kernel.org>; Sat,  2 Oct 2021 17:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhJBRlO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Oct 2021 13:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232043AbhJBRlN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 2 Oct 2021 13:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2F50615A4;
        Sat,  2 Oct 2021 17:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633196365;
        bh=d51DIKW7emsQw1H5o4FsiOn4LtLW9AVwgL89sJaaibo=;
        h=Date:From:To:Subject:From;
        b=dhZE0Vx7QD6xLMr++kCMYsaA53JIWRw76gmGRjawG941DWPDUsiFYaFem5cZtEVJJ
         ilakBDPtS4m2/d09wQunSoqAcNo/oMMAiuMk3/2D2Eu7HDAtC/N9uzIxA7nQYsaQrS
         nfBuumpd6O2rb6I8DlzH8vRegyt5Gwz/pcn6k3B8=
Date:   Sat, 02 Oct 2021 10:39:25 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  + seq_file-move-seq_escape-to-a-header.patch added to -mm
 tree
Message-ID: <20211002173925.sMnMTn4eL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: move seq_escape() to a header
has been added to the -mm tree.  Its filename is
     seq_file-move-seq_escape-to-a-header.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/seq_file-move-seq_escape-to-a-header.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/seq_file-move-seq_escape-to-a-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

seq_file-move-seq_escape-to-a-header.patch

