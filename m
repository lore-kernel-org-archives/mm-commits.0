Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D330BC07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B658661C9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhGFTZD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhGFTZC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A02561C9E;
        Tue,  6 Jul 2021 19:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599342;
        bh=44ioY4bh0HuVzVR3bSac0mDbWaWYTlY0kdUrJaed4VQ=;
        h=Date:From:To:Subject:From;
        b=fepjhZAXpwS5yFHG5D3oNXIan4RVAciqtOXdSlq46BpfklCnviCHH/v9h/r5TmBVM
         YdqO/sbuzTg2o30mwnTkjJaZloFeN0Gg6i9yk6J9IPG2Wl1mkp+7fGqfO2auMY8dY+
         nEvbwtMzRkgoOIgGljQGnbGk3pXU7wTH5EVJtJJ8=
Date:   Tue, 06 Jul 2021 12:22:22 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged] seq_file-introduce-seq_escape_mem.patch removed
 from -mm tree
Message-ID: <20210706192222.jCdZ6WKis%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: introduce seq_escape_mem()
has been removed from the -mm tree.  Its filename was
     seq_file-introduce-seq_escape_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: seq_file: introduce seq_escape_mem()

Introduce seq_escape_mem() to allow users to pass additional parameters to
string_escape_mem().

Link: https://lkml.kernel.org/r/20210504180819.73127-12-andriy.shevchenko@linux.intel.com
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   25 +++++++++++++++++++++++++
 include/linux/seq_file.h |    2 ++
 2 files changed, 27 insertions(+)

--- a/fs/seq_file.c~seq_file-introduce-seq_escape_mem
+++ a/fs/seq_file.c
@@ -356,6 +356,31 @@ int seq_release(struct inode *inode, str
 EXPORT_SYMBOL(seq_release);
 
 /**
+ * seq_escape_mem - print data into buffer, escaping some characters
+ * @m: target buffer
+ * @src: source buffer
+ * @len: size of source buffer
+ * @flags: flags to pass to string_escape_mem()
+ * @esc: set of characters that need escaping
+ *
+ * Puts data into buffer, replacing each occurrence of character from
+ * given class (defined by @flags and @esc) with printable escaped sequence.
+ *
+ * Use seq_has_overflowed() to check for errors.
+ */
+void seq_escape_mem(struct seq_file *m, const char *src, size_t len,
+		    unsigned int flags, const char *esc)
+{
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int ret;
+
+	ret = string_escape_mem(src, len, buf, size, flags, esc);
+	seq_commit(m, ret < size ? ret : -1);
+}
+EXPORT_SYMBOL(seq_escape_mem);
+
+/**
  *	seq_escape -	print string into buffer, escaping some characters
  *	@m:	target buffer
  *	@s:	string
--- a/include/linux/seq_file.h~seq_file-introduce-seq_escape_mem
+++ a/include/linux/seq_file.h
@@ -126,6 +126,8 @@ void seq_put_decimal_ll(struct seq_file
 void seq_put_hex_ll(struct seq_file *m, const char *delimiter,
 		    unsigned long long v, unsigned int width);
 
+void seq_escape_mem(struct seq_file *m, const char *src, size_t len,
+		    unsigned int flags, const char *esc);
 void seq_escape(struct seq_file *m, const char *s, const char *esc);
 void seq_escape_mem_ascii(struct seq_file *m, const char *src, size_t isz);
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


