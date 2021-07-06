Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BB4C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3467861CA3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhGFTZ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhGFTZ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A36F61C9E;
        Tue,  6 Jul 2021 19:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599366;
        bh=f64YRjJg9bWko5NofhxguMFezU3BiX9yVgtE9Q9r2Pc=;
        h=Date:From:To:Subject:From;
        b=HVQYqbBJF/FRPAwRwriOTk3JLXKt97lUj8Ip1gfhv912KGVwYpyis2FIOnBi3YNdA
         PCmuvMps5dcbI81skewyE3dMi0HoyqzF7c3/RKGBn3KTtASH/NlEYdjkfrKaV5FEcd
         5i3go4thZ4gvYduLFkquc2FqjwN3sB4X8nXn6Crk=
Date:   Tue, 06 Jul 2021 12:22:46 -0700
From:   akpm@linux-foundation.org
To:     mcroce@microsoft.com, mm-commits@vger.kernel.org
Subject:  [merged] lib-test_stringc-allow-mode-removal.patch
 removed from -mm tree
Message-ID: <20210706192246.gm8uVsocU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_string.c: allow module removal
has been removed from the -mm tree.  Its filename was
     lib-test_stringc-allow-mode-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


