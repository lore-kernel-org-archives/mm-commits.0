Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72B3C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC4606142B
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhEIDtz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhEIDtz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:49:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5B1F61401;
        Sun,  9 May 2021 03:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620532132;
        bh=+YlcP3alVY5OadIGm5IJD+XEnlsQoPxOkkRMqS/eFkA=;
        h=Date:From:To:Subject:From;
        b=I5C1TlB9j/iWK0Paqs9Lx47RLRhZ45EsY1FZ5qFqfOULLJ+8fYbMlSHAfd29uQuDx
         tXPWElgXr0CpUm/PcRHv3j4UUklVI6utS2Uh+ZgRQ/I3ajaLeXQJyXBfbiWads/rZZ
         229r/YAmuT8XrM/uWVu268YJjLLfwEwRCifFQj3k=
Date:   Sat, 08 May 2021 20:48:51 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + seq_file-introduce-seq_escape_mem.patch added to -mm
 tree
Message-ID: <20210509034851.tZ3k0LwoV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: introduce seq_escape_mem()
has been added to the -mm tree.  Its filename is
     seq_file-introduce-seq_escape_mem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/seq_file-introduce-seq_escape_mem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/seq_file-introduce-seq_escape_mem.patch

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

lib-string_helpers-switch-to-use-bit-macro.patch
lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop.patch
lib-string_helpers-drop-indentation-level-in-string_escape_mem.patch
lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch
lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printable.patch
lib-string_helpers-allow-to-append-additional-characters-to-be-escaped.patch
lib-test-string_helpers-print-flags-in-hexadecimal-format.patch
lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
lib-test-string_helpers-add-test-cases-for-new-features.patch
maintainers-add-myself-as-designated-reviewer-for-generic-string-library.patch
seq_file-introduce-seq_escape_mem.patch
seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch
seq_file-convert-seq_escape-to-use-seq_escape_str.patch
nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch
seq_file-drop-unused-_escape_mem_ascii.patch

