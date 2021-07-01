Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC382C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 942926147D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbhGAB6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB6F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47CBE61420;
        Thu,  1 Jul 2021 01:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104535;
        bh=6CIP4YdyeHYqf6rxoBTLM+Y1uFHyq+GNWeCSjMEm7SA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DTiNRv50MDwfrW/+DKk6ZLV1SwRN3c2DplidHf3q1MnL6csZrMQCeG0pzfX9t01VS
         6mSpJFya4Kj3gWIsIfa5dt8CK2FNHvHdIUH0klDz9mZzEtAOqQlQFKVV4OYrbCFNNc
         wpuivQ0nzEKMEaMtK4YI1ScATlkTVsjuEt9jLuXU=
Date:   Wed, 30 Jun 2021 18:55:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 158/192] seq_file: introduce seq_escape_mem()
Message-ID: <20210701015534.dRLur5WZy%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
