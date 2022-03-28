Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB78C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiC1Wsj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiC1Wsi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:48:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED53317ADA3
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D29960BAD
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAC8C340EC;
        Mon, 28 Mar 2022 22:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648507616;
        bh=1g1VhbeYlga+6GgDpaib8aSBuO85+u+d57oeRhTcTHI=;
        h=Date:To:From:Subject:From;
        b=oMxMlrwzNogrJE27AQWx1t/H8gwVUWuuaDApFxaMRETJeFVfX0qDUEdvqmZfBPY/s
         uelAt7gJsf2uT/V5NYqzYxHZzLJsI7PSSpNvNt8XfCQjzaOl+UTQBdqrkKa7tJk9o+
         r8KdFEdxtdG6kE2ruIBz/wJdJsAzxTm04JNcoCfM=
Date:   Mon, 28 Mar 2022 15:46:55 -0700
To:     mm-commits@vger.kernel.org, andy@kernel.org,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_stringc-add-strspn-and-strcspn-tests.patch added to -mm tree
Message-Id: <20220328224655.DCAC8C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_string.c: add strspn and strcspn tests
has been added to the -mm tree.  Its filename is
     lib-test_stringc-add-strspn-and-strcspn-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_stringc-add-strspn-and-strcspn-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_stringc-add-strspn-and-strcspn-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-kconfigdebug-remove-more-config__value-indirections.patch
lib-test_stringc-add-strspn-and-strcspn-tests.patch
lib-stringc-simplify-strspn.patch

