Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F76C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ECC661430
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhEIDt4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhEIDt4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:49:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCA4761431;
        Sun,  9 May 2021 03:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620532134;
        bh=XwwtLNzHkGtwvWsf34uCiH97Vnn9DnEUHJ0qgwWaeH8=;
        h=Date:From:To:Subject:From;
        b=QCqj33dojZnmYIqf8Lfq1KtKfbIDF+oxmXHRIKwpBflM2txszD4Pb0rcecQPNS5iD
         Eeux8paKvPmRIXdC0buHjeNqvmxyM+lnX3soPG935+BGBA4nuNp2VfCxh4jMcnSQw/
         BeeMwU5ZzEPi+Aa7sCAUIVTcsQcswsOpHSISBCfs=
Date:   Sat, 08 May 2021 20:48:53 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  +
 seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch added to
 -mm tree
Message-ID: <20210509034853.b4Yi3JfNM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: add seq_escape_str() as replica of string_escape_str()
has been added to the -mm tree.  Its filename is
     seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch

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
Subject: seq_file: add seq_escape_str() as replica of string_escape_str()

In some cases we want to escape characters from NULL-terminated strings. 
Add seq_escape_str() as replica of string_escape_str() for that.

Link: https://lkml.kernel.org/r/20210504180819.73127-13-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seq_file.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/seq_file.h~seq_file-add-seq_escape_str-as-replica-of-string_escape_str
+++ a/include/linux/seq_file.h
@@ -128,6 +128,13 @@ void seq_put_hex_ll(struct seq_file *m,
 
 void seq_escape_mem(struct seq_file *m, const char *src, size_t len,
 		    unsigned int flags, const char *esc);
+
+static inline void seq_escape_str(struct seq_file *m, const char *src,
+				  unsigned int flags, const char *esc)
+{
+	seq_escape_mem(m, src, strlen(src), flags, esc);
+}
+
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

