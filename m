Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14158C56202
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D52EE20729
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pn+6iAjU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgKXBT0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:19:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727520AbgKXBTZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 20:19:25 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5B7020758;
        Tue, 24 Nov 2020 01:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606180765;
        bh=0aVItbxAHQtuQ7vy+0gZc6BkqQWvvUWHCxbwJ9d+9mg=;
        h=Date:From:To:Subject:From;
        b=Pn+6iAjUis/AhEwpxgeduvBG/Rp6YQbvtRwTMiSAyiQpiQX6oMtwBN/T0ljyFp8K8
         d8CSfWOiuc83Qh8i6J+ycT0HuEbyKhsmq/okzN8ck0+bvRNZsX1hopSU/BtEw2J7wa
         tqXe2CQfBzBS8JlFwTIvWicAeT9SzcGnaiHLa7us=
Date:   Mon, 23 Nov 2020 17:19:24 -0800
From:   akpm@linux-foundation.org
To:     danielmicay@gmail.com, dja@axtens.net, keescook@chromium.org,
        laniel_francis@privacyrequired.com, mm-commits@vger.kernel.org
Subject:  + add-new-file-in-lkdtm-to-test-fortified-strscpy.patch
 added to -mm tree
Message-ID: <20201124011924.ESsUQSX4p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/lkdtm: add new file in LKDTM to test fortified strscpy
has been added to the -mm tree.  Its filename is
     add-new-file-in-lkdtm-to-test-fortified-strscpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/add-new-file-in-lkdtm-to-test-fortified-strscpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/add-new-file-in-lkdtm-to-test-fortified-strscpy.patch

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
Subject: drivers/misc/lkdtm: add new file in LKDTM to test fortified strscpy

This new test ensures that fortified strscpy has the same behavior than
vanilla strscpy (e.g.  returning -E2BIG when src content is truncated). 
Finally, it generates a crash at runtime because there is a write overflow
in destination string.

Link: https://lkml.kernel.org/r/20201122162451.27551-5-laniel_francis@privacyrequired.com
Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm/Makefile             |    1 
 drivers/misc/lkdtm/core.c               |    1 
 drivers/misc/lkdtm/fortify.c            |   82 ++++++++++++++++++++++
 drivers/misc/lkdtm/lkdtm.h              |    3 
 tools/testing/selftests/lkdtm/tests.txt |    1 
 5 files changed, 88 insertions(+)

--- a/drivers/misc/lkdtm/core.c~add-new-file-in-lkdtm-to-test-fortified-strscpy
+++ a/drivers/misc/lkdtm/core.c
@@ -175,6 +175,7 @@ static const struct crashtype crashtypes
 	CRASHTYPE(USERCOPY_KERNEL),
 	CRASHTYPE(STACKLEAK_ERASING),
 	CRASHTYPE(CFI_FORWARD_PROTO),
+	CRASHTYPE(FORTIFIED_STRSCPY),
 #ifdef CONFIG_X86_32
 	CRASHTYPE(DOUBLE_FAULT),
 #endif
--- /dev/null
+++ a/drivers/misc/lkdtm/fortify.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Francis Laniel <laniel_francis@privacyrequired.com>
+ *
+ * Add tests related to fortified functions in this file.
+ */
+#include "lkdtm.h"
+#include <linux/string.h>
+#include <linux/slab.h>
+
+
+/*
+ * Calls fortified strscpy to test that it returns the same result as vanilla
+ * strscpy and generate a panic because there is a write overflow (i.e. src
+ * length is greater than dst length).
+ */
+void lkdtm_FORTIFIED_STRSCPY(void)
+{
+	char *src;
+	char dst[5];
+
+	struct {
+		union {
+			char big[10];
+			char src[5];
+		};
+	} weird = { .big = "hello!" };
+	char weird_dst[sizeof(weird.src) + 1];
+
+	src = kstrdup("foobar", GFP_KERNEL);
+
+	if (src == NULL)
+		return;
+
+	/* Vanilla strscpy returns -E2BIG if size is 0. */
+	if (strscpy(dst, src, 0) != -E2BIG)
+		pr_warn("FAIL: strscpy() of 0 length did not return -E2BIG\n");
+
+	/* Vanilla strscpy returns -E2BIG if src is truncated. */
+	if (strscpy(dst, src, sizeof(dst)) != -E2BIG)
+		pr_warn("FAIL: strscpy() did not return -E2BIG while src is truncated\n");
+
+	/* After above call, dst must contain "foob" because src was truncated. */
+	if (strncmp(dst, "foob", sizeof(dst)) != 0)
+		pr_warn("FAIL: after strscpy() dst does not contain \"foob\" but \"%s\"\n",
+			dst);
+
+	/* Shrink src so the strscpy() below succeeds. */
+	src[3] = '\0';
+
+	/*
+	 * Vanilla strscpy returns number of character copied if everything goes
+	 * well.
+	 */
+	if (strscpy(dst, src, sizeof(dst)) != 3)
+		pr_warn("FAIL: strscpy() did not return 3 while src was copied entirely truncated\n");
+
+	/* After above call, dst must contain "foo" because src was copied. */
+	if (strncmp(dst, "foo", sizeof(dst)) != 0)
+		pr_warn("FAIL: after strscpy() dst does not contain \"foo\" but \"%s\"\n",
+			dst);
+
+	/* Test when src is embedded inside a union. */
+	strscpy(weird_dst, weird.src, sizeof(weird_dst));
+
+	if (strcmp(weird_dst, "hello") != 0)
+		pr_warn("FAIL: after strscpy() weird_dst does not contain \"hello\" but \"%s\"\n",
+			weird_dst);
+
+	/* Restore src to its initial value. */
+	src[3] = 'b';
+
+	/*
+	 * Use strlen here so size cannot be known at compile time and there is
+	 * a runtime write overflow.
+	 */
+	strscpy(dst, src, strlen(src));
+
+	pr_warn("FAIL: No overflow in above strscpy()\n");
+
+	kfree(src);
+}
--- a/drivers/misc/lkdtm/lkdtm.h~add-new-file-in-lkdtm-to-test-fortified-strscpy
+++ a/drivers/misc/lkdtm/lkdtm.h
@@ -104,4 +104,7 @@ void lkdtm_STACKLEAK_ERASING(void);
 /* cfi.c */
 void lkdtm_CFI_FORWARD_PROTO(void);
 
+/* fortify.c */
+void lkdtm_FORTIFIED_STRSCPY(void);
+
 #endif
--- a/drivers/misc/lkdtm/Makefile~add-new-file-in-lkdtm-to-test-fortified-strscpy
+++ a/drivers/misc/lkdtm/Makefile
@@ -10,6 +10,7 @@ lkdtm-$(CONFIG_LKDTM)		+= rodata_objcopy
 lkdtm-$(CONFIG_LKDTM)		+= usercopy.o
 lkdtm-$(CONFIG_LKDTM)		+= stackleak.o
 lkdtm-$(CONFIG_LKDTM)		+= cfi.o
+lkdtm-$(CONFIG_LKDTM)		+= fortify.o
 
 KASAN_SANITIZE_stackleak.o	:= n
 KCOV_INSTRUMENT_rodata.o	:= n
--- a/tools/testing/selftests/lkdtm/tests.txt~add-new-file-in-lkdtm-to-test-fortified-strscpy
+++ a/tools/testing/selftests/lkdtm/tests.txt
@@ -68,3 +68,4 @@ USERCOPY_STACK_BEYOND
 USERCOPY_KERNEL
 STACKLEAK_ERASING OK: the rest of the thread stack is properly erased
 CFI_FORWARD_PROTO
+FORTIFIED_STRSCPY
_

Patches currently in -mm which might be from laniel_francis@privacyrequired.com are

stringh-add-fortify-coverage-for-strscpy.patch
add-new-file-in-lkdtm-to-test-fortified-strscpy.patch
correct-wrong-filenames-in-comment.patch

