Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C29CC11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4618861469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbhGAB6j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238467AbhGAB6i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 752F161418;
        Thu,  1 Jul 2021 01:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104567;
        bh=DybbZ8rsYQiFbecc+hyKN7dV0yKfOMcJMQZluXePPoQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Osz/UgAPAOTUiAEE7s488pjtshnkmridjd7icR7wKLKF4V22o0FDyMQCWffxKcYM8
         f2ax+qn3iL3AAJtRff+tdQeaHEybIFAcrlQ/b+bxB8Z3HI9NplU8MnrseZsBt7H5mT
         7j3vZHuegk68Zvj++PtCFu9Jw4frHjOsDPXZ+yZU=
Date:   Wed, 30 Jun 2021 18:56:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mcroce@microsoft.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 169/192] lib/test_string.c: allow module removal
Message-ID: <20210701015607.Irez2ivp1%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
