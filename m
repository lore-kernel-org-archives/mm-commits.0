Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E8AC433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526A76142D
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhEIDte (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:49:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhEIDte (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E232161401;
        Sun,  9 May 2021 03:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620532112;
        bh=bv5VfVfeEEGDCddLw1wnCzTYohDkzd/degh9Akb7awY=;
        h=Date:From:To:Subject:From;
        b=R8gcpqUWp9Kw2ivYjhteU95ZPJgYB6+7ieZKu9GDJwYoh/CSXyWninwmC6lzL+QGZ
         v8JeaygVn3h3X3OUfZ6xy5xM+0ALLueWgFLwSyfozGwdABgXx7+8CckPc1pJRTtINO
         waUJL4foFlvdagpiGPlBqLyhGJuvqWETanZMhdOk=
Date:   Sat, 08 May 2021 20:48:31 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + lib-string_helpers-switch-to-use-bit-macro.patch added
 to -mm tree
Message-ID: <20210509034831.AN3LnS2Hw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: switch to use BIT() macro
has been added to the -mm tree.  Its filename is
     lib-string_helpers-switch-to-use-bit-macro.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpers-switch-to-use-bit-macro.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpers-switch-to-use-bit-macro.patch

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
Subject: lib/string_helpers: switch to use BIT() macro

Patch series "lib/string_helpers: get rid of ugly *_escape_mem_ascii()", v3.

Get rid of ugly *_escape_mem_ascii() API since it's not flexible and has
the only single user.  Provide better approach based on usage of the
string_escape_mem() with appropriate flags.

Test cases has been expanded accordingly to cover new functionality.


This patch (of 15):

Switch to use BIT() macro for flag definitions.  No changes implied.

Link: https://lkml.kernel.org/r/20210504180819.73127-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20210504180819.73127-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/include/linux/string_helpers.h~lib-string_helpers-switch-to-use-bit-macro
+++ a/include/linux/string_helpers.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_STRING_HELPERS_H_
 #define _LINUX_STRING_HELPERS_H_
 
+#include <linux/bits.h>
 #include <linux/ctype.h>
 #include <linux/types.h>
 
@@ -18,10 +19,10 @@ enum string_size_units {
 void string_get_size(u64 size, u64 blk_size, enum string_size_units units,
 		     char *buf, int len);
 
-#define UNESCAPE_SPACE		0x01
-#define UNESCAPE_OCTAL		0x02
-#define UNESCAPE_HEX		0x04
-#define UNESCAPE_SPECIAL	0x08
+#define UNESCAPE_SPACE		BIT(0)
+#define UNESCAPE_OCTAL		BIT(1)
+#define UNESCAPE_HEX		BIT(2)
+#define UNESCAPE_SPECIAL	BIT(3)
 #define UNESCAPE_ANY		\
 	(UNESCAPE_SPACE | UNESCAPE_OCTAL | UNESCAPE_HEX | UNESCAPE_SPECIAL)
 
@@ -42,15 +43,15 @@ static inline int string_unescape_any_in
 	return string_unescape_any(buf, buf, 0);
 }
 
-#define ESCAPE_SPACE		0x01
-#define ESCAPE_SPECIAL		0x02
-#define ESCAPE_NULL		0x04
-#define ESCAPE_OCTAL		0x08
+#define ESCAPE_SPACE		BIT(0)
+#define ESCAPE_SPECIAL		BIT(1)
+#define ESCAPE_NULL		BIT(2)
+#define ESCAPE_OCTAL		BIT(3)
 #define ESCAPE_ANY		\
 	(ESCAPE_SPACE | ESCAPE_OCTAL | ESCAPE_SPECIAL | ESCAPE_NULL)
-#define ESCAPE_NP		0x10
+#define ESCAPE_NP		BIT(4)
 #define ESCAPE_ANY_NP		(ESCAPE_ANY | ESCAPE_NP)
-#define ESCAPE_HEX		0x20
+#define ESCAPE_HEX		BIT(5)
 
 int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
 		unsigned int flags, const char *only);
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

