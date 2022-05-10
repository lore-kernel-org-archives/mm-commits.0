Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276DFC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbiEJEXp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236422AbiEJEWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:22:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF71C12ED
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF091B81AF1
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E81C385C8;
        Tue, 10 May 2022 04:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156262;
        bh=nUW9vUnXDYFt4oy8uFS+OX/e+imOYZk6F8WZvI4w+hQ=;
        h=Date:To:From:Subject:From;
        b=0wQ9aDy4FTq2h6jdhwBej+2QN/rXS3wbWVQaCiIlnUlsAi010WVYCMKcu8R5HkHwF
         cRZ8Wen4lUcvlTc7rHS3vUgoK1wsC2FvWpgy8vxe0IuWuFE/2lr/t1mN1pW0arCjJf
         S1VZEotR9n5t1oawyI0rrSS2Nvn8edu8t3X/Z7dI=
Date:   Mon, 09 May 2022 21:17:41 -0700
To:     mm-commits@vger.kernel.org, andy@kernel.org,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_stringc-add-strspn-and-strcspn-tests.patch removed from -mm tree
Message-Id: <20220510041742.75E81C385C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test_string.c: add strspn and strcspn tests
has been removed from the -mm tree.  Its filename was
     lib-test_stringc-add-strspn-and-strcspn-tests.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_string.c: add strspn and strcspn tests

Before refactoring strspn() and strcspn(), add some simple test cases.

Link: https://lkml.kernel.org/r/20220328224119.3003834-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_string.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/lib/test_string.c~lib-test_stringc-add-strspn-and-strcspn-tests
+++ a/lib/test_string.c
@@ -179,6 +179,34 @@ static __init int strnchr_selftest(void)
 	return 0;
 }
 
+static __init int strspn_selftest(void)
+{
+	static const struct strspn_test {
+		const char str[16];
+		const char accept[16];
+		const char reject[16];
+		unsigned a;
+		unsigned r;
+	} tests[] __initconst = {
+		{ "foobar", "", "", 0, 6 },
+		{ "abba", "abc", "ABBA", 4, 4 },
+		{ "abba", "a", "b", 1, 1 },
+		{ "", "abc", "abc", 0, 0},
+	};
+	const struct strspn_test *s = tests;
+	size_t i, res;
+
+	for (i = 0; i < ARRAY_SIZE(tests); ++i, ++s) {
+		res = strspn(s->str, s->accept);
+		if (res != s->a)
+			return 0x100 + 2*i;
+		res = strcspn(s->str, s->reject);
+		if (res != s->r)
+			return 0x100 + 2*i + 1;
+	}
+	return 0;
+}
+
 static __exit void string_selftest_remove(void)
 {
 }
@@ -212,6 +240,11 @@ static __init int string_selftest_init(v
 	if (subtest)
 		goto fail;
 
+	test = 6;
+	subtest = strspn_selftest();
+	if (subtest)
+		goto fail;
+
 	pr_info("String selftests succeeded\n");
 	return 0;
 fail:
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are


