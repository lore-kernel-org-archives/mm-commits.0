Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF558C56202
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67CB82075A
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o8f3ropT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgKXBTY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727520AbgKXBTX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 20:19:23 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D224820729;
        Tue, 24 Nov 2020 01:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606180763;
        bh=mx+ya3LPJmMBG1CNgn5KegUTfRV/Cgqt9RG/LyqojMU=;
        h=Date:From:To:Subject:From;
        b=o8f3ropTx36xPoO0qvczEBgyx0upPeFkTkPH1G/igKMQV+sw+MAD6nFR7bbLgu54u
         wu4vUIeFDAizuzIP9DHxfmQ4dmJy1QpYxQCROE6HTD852ro6joJjrZpjxi0upPzoWt
         C3EJC2WniBRSCOdgZKXnrA3KpgTgSrXEkXW4WZLQ=
Date:   Mon, 23 Nov 2020 17:19:22 -0800
From:   akpm@linux-foundation.org
To:     danielmicay@gmail.com, dja@axtens.net, keescook@chromium.org,
        laniel_francis@privacyrequired.com, mm-commits@vger.kernel.org
Subject:  + stringh-add-fortify-coverage-for-strscpy.patch added to
 -mm tree
Message-ID: <20201124011922.rYwwQyGK0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: string.h: add FORTIFY coverage for strscpy()
has been added to the -mm tree.  Its filename is
     stringh-add-fortify-coverage-for-strscpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/stringh-add-fortify-coverage-for-strscpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/stringh-add-fortify-coverage-for-strscpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Francis Laniel <laniel_francis@privacyrequired.com>
Subject: string.h: add FORTIFY coverage for strscpy()

The fortified version of strscpy ensures the following before vanilla strscpy
is called:

1. There is no read overflow because we either size is smaller than
   src length or we shrink size to src length by calling fortified
   strnlen.

2. There is no write overflow because we either failed during
   compilation or at runtime by checking that size is smaller than dest
   size.

Link: https://lkml.kernel.org/r/20201122162451.27551-4-laniel_francis@privacyrequired.com
Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |   48 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/include/linux/string.h~stringh-add-fortify-coverage-for-strscpy
+++ a/include/linux/string.h
@@ -6,6 +6,7 @@
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
+#include <linux/errno.h>	/* for E2BIG */
 #include <stdarg.h>
 #include <uapi/linux/string.h>
 
@@ -357,6 +358,53 @@ __FORTIFY_INLINE size_t strlcpy(char *p,
 	return ret;
 }
 
+/* defined after fortified strnlen to reuse it */
+extern ssize_t __real_strscpy(char *, const char *, size_t) __RENAME(strscpy);
+__FORTIFY_INLINE ssize_t strscpy(char *p, const char *q, size_t size)
+{
+	size_t len;
+	/* Use string size rather than possible enclosing struct size. */
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
+
+	/* If we cannot get size of p and q default to call strscpy. */
+	if (p_size == (size_t) -1 && q_size == (size_t) -1)
+		return __real_strscpy(p, q, size);
+
+	/*
+	 * If size can be known at compile time and is greater than
+	 * p_size, generate a compile time write overflow error.
+	 */
+	if (__builtin_constant_p(size) && size > p_size)
+		__write_overflow();
+
+	/*
+	 * This call protects from read overflow, because len will default to q
+	 * length if it smaller than size.
+	 */
+	len = strnlen(q, size);
+	/*
+	 * If len equals size, we will copy only size bytes which leads to
+	 * -E2BIG being returned.
+	 * Otherwise we will copy len + 1 because of the final '\O'.
+	 */
+	len = len == size ? size : len + 1;
+
+	/*
+	 * Generate a runtime write overflow error if len is greater than
+	 * p_size.
+	 */
+	if (len > p_size)
+		fortify_panic(__func__);
+
+	/*
+	 * We can now safely call vanilla strscpy because we are protected from:
+	 * 1. Read overflow thanks to call to strnlen().
+	 * 2. Write overflow thanks to above ifs.
+	 */
+	return __real_strscpy(p, q, len);
+}
+
 /* defined after fortified strlen and strnlen to reuse them */
 __FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
 {
_

Patches currently in -mm which might be from laniel_francis@privacyrequired.com are

stringh-add-fortify-coverage-for-strscpy.patch
add-new-file-in-lkdtm-to-test-fortified-strscpy.patch
correct-wrong-filenames-in-comment.patch

