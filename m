Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702E9C2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 335D720758
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jubhPlkd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgKXBTU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:19:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727520AbgKXBTU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 20:19:20 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00C022073C;
        Tue, 24 Nov 2020 01:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606180760;
        bh=POkvfmDGhKrtHYSz+twQ+lC2CK46xTEg6wsODS/C/mM=;
        h=Date:From:To:Subject:From;
        b=jubhPlkd3q1RTpomHbKcxislVxmA0fwfhcGqw7bQ4R1H6pTeJIToYvqnKDjyRUKWA
         7ujE82WH4+/zyyxqSeNVcEOuqesf6kuy8ecUUf5efcMr4Hou9cqXUALYB+Vm7/lQDP
         BfhkW8IyB7vypfgrfOJv/WdLJHR3AzS9u/LWmX4o=
Date:   Mon, 23 Nov 2020 17:19:19 -0800
From:   akpm@linux-foundation.org
To:     danielmicay@gmail.com, dja@axtens.net, keescook@chromium.org,
        laniel_francis@privacyrequired.com, mm-commits@vger.kernel.org
Subject:  + lkdtm-tests-for-fortify_source.patch added to -mm tree
Message-ID: <20201124011919.2CpXr6yj_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lkdtm: tests for FORTIFY_SOURCE
has been added to the -mm tree.  Its filename is
     lkdtm-tests-for-fortify_source.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lkdtm-tests-for-fortify_source.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lkdtm-tests-for-fortify_source.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: lkdtm: tests for FORTIFY_SOURCE

Add code to test both:

 - runtime detection of the overrun of a structure. This covers the
   __builtin_object_size(x, 0) case. This test is called FORTIFY_OBJECT.

 - runtime detection of the overrun of a char array within a structure.
   This covers the __builtin_object_size(x, 1) case which can be used
   for some string functions. This test is called FORTIFY_SUBOBJECT.

Link: https://lkml.kernel.org/r/20201122162451.27551-3-laniel_francis@privacyrequired.com
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm/bugs.c  |   50 +++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |    2 +
 drivers/misc/lkdtm/lkdtm.h |    2 +
 3 files changed, 54 insertions(+)

--- a/drivers/misc/lkdtm/bugs.c~lkdtm-tests-for-fortify_source
+++ a/drivers/misc/lkdtm/bugs.c
@@ -482,3 +482,53 @@ noinline void lkdtm_CORRUPT_PAC(void)
 	pr_err("XFAIL: this test is arm64-only\n");
 #endif
 }
+
+void lkdtm_FORTIFY_OBJECT(void)
+{
+	struct target {
+		char a[10];
+	} target[2] = {};
+	int result;
+
+	/*
+	 * Using volatile prevents the compiler from determining the value of
+	 * 'size' at compile time. Without that, we would get a compile error
+	 * rather than a runtime error.
+	 */
+	volatile int size = 11;
+
+	pr_info("trying to read past the end of a struct\n");
+
+	result = memcmp(&target[0], &target[1], size);
+
+	/* Print result to prevent the code from being eliminated */
+	pr_err("FAIL: fortify did not catch an object overread!\n"
+	       "\"%d\" was the memcmp result.\n", result);
+}
+
+void lkdtm_FORTIFY_SUBOBJECT(void)
+{
+	struct target {
+		char a[10];
+		char b[10];
+	} target;
+	char *src;
+
+	src = kmalloc(20, GFP_KERNEL);
+	strscpy(src, "over ten bytes", 20);
+
+	pr_info("trying to strcpy past the end of a member of a struct\n");
+
+	/*
+	 * strncpy(target.a, src, 20); will hit a compile error because the
+	 * compiler knows at build time that target.a < 20 bytes. Use strcpy()
+	 * to force a runtime error.
+	 */
+	strcpy(target.a, src);
+
+	/* Use target.a to prevent the code from being eliminated */
+	pr_err("FAIL: fortify did not catch an sub-object overrun!\n"
+	       "\"%s\" was copied.\n", target.a);
+
+	kfree(src);
+}
--- a/drivers/misc/lkdtm/core.c~lkdtm-tests-for-fortify_source
+++ a/drivers/misc/lkdtm/core.c
@@ -117,6 +117,8 @@ static const struct crashtype crashtypes
 	CRASHTYPE(UNSET_SMEP),
 	CRASHTYPE(CORRUPT_PAC),
 	CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
+	CRASHTYPE(FORTIFY_OBJECT),
+	CRASHTYPE(FORTIFY_SUBOBJECT),
 	CRASHTYPE(OVERWRITE_ALLOCATION),
 	CRASHTYPE(WRITE_AFTER_FREE),
 	CRASHTYPE(READ_AFTER_FREE),
--- a/drivers/misc/lkdtm/lkdtm.h~lkdtm-tests-for-fortify_source
+++ a/drivers/misc/lkdtm/lkdtm.h
@@ -32,6 +32,8 @@ void lkdtm_STACK_GUARD_PAGE_TRAILING(voi
 void lkdtm_UNSET_SMEP(void);
 void lkdtm_DOUBLE_FAULT(void);
 void lkdtm_CORRUPT_PAC(void);
+void lkdtm_FORTIFY_OBJECT(void);
+void lkdtm_FORTIFY_SUBOBJECT(void);
 
 /* lkdtm_heap.c */
 void __init lkdtm_heap_init(void);
_

Patches currently in -mm which might be from dja@axtens.net are

stringh-detect-intra-object-overflow-in-fortified-string-functions.patch
lkdtm-tests-for-fortify_source.patch

