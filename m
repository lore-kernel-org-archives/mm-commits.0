Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1479C48BC2
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 00:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7919861263
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 00:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFXA0E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 20:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhFXA0D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 20:26:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97AB161263;
        Thu, 24 Jun 2021 00:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624494224;
        bh=1A6fswzwGCaYaDL2iGLQjBcRL9dlcYZl2Icii43k6j4=;
        h=Date:From:To:Subject:From;
        b=TwbjX9fyVdpd+/g9TjsZ7/wOLZ5vPbmUqVIX8P2W/cNANduVIsI4LNpa5Fq8SJZB7
         V6cPh7+zlrFnEuM04LDCE2sHmcijT5n7kDJwSHA+Ve3XCm59Ts/lqWa+cTvep8ga5c
         SP+zrXYxBdVPJrMjGScB9KT5o+V+/yJYg4ApXfhg=
Date:   Wed, 23 Jun 2021 17:23:44 -0700
From:   akpm@linux-foundation.org
To:     mcroce@microsoft.com, mm-commits@vger.kernel.org
Subject:  + lib-test_stringc-allow-mode-removal.patch added to -mm
 tree
Message-ID: <20210624002344.nExJJbbVU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_string.c: allow module removal
has been added to the -mm tree.  Its filename is
     lib-test_stringc-allow-mode-removal.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_stringc-allow-mode-removal.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_stringc-allow-mode-removal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matteo Croce <mcroce@microsoft.com>
Subject: lib/test_string.c: allow module removal

The test_string module can't be removed because it lacks an exit hook. 
Since there is no reason for it to be permanent, add an empty one to allow
module removal.

Link: https://lkml.kernel.org/r/20210616234503.28678-1-mcroce@linux.microsoft.com
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_string.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/lib/test_string.c~lib-test_stringc-allow-mode-removal
+++ a/lib/test_string.c
@@ -179,6 +179,10 @@ static __init int strnchr_selftest(void)
 	return 0;
 }
 
+static __exit void string_selftest_remove(void)
+{
+}
+
 static __init int string_selftest_init(void)
 {
 	int test, subtest;
@@ -216,4 +220,5 @@ fail:
 }
 
 module_init(string_selftest_init);
+module_exit(string_selftest_remove);
 MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from mcroce@microsoft.com are

lib-test_stringc-allow-mode-removal.patch

