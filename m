Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1195C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 22:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242381AbiBAWza (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 17:55:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59458 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbiBAWz3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 17:55:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 84665CE1AEC
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 22:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2B8C340ED;
        Tue,  1 Feb 2022 22:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643756126;
        bh=/u7euRnHIwN4o7/UeQDafD8+aLdxPHpifumKIMyt2Rk=;
        h=Date:To:From:Subject:From;
        b=JYmkm/fGTIqGPEZEquiN0mJEa45SyUnaT//2m4wIJOEuSNM3TzPD4qsUQNlavpV9E
         mqGxaRD/VvjeHurYnYtD+ZpsjrFBX/LxQjA25J2mR2SOdMwqe+EJ2IiRrmznGC4Xkx
         EumqXhKCSsOsTz5EOjLp6hohumT4MnS5Rdpy2MDw=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 14:55:25 -0800
Date:   Tue, 01 Feb 2022 14:55:25 -0800
To:     mm-commits@vger.kernel.org, andreyknvl@gmail.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-improve-vmalloc-tests-fix.patch added to -mm tree
Message-Id: <20220201225525.AD2B8C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: similar to "kasan: test: fix compatibility with FORTIFY_SOURCE"
has been added to the -mm tree.  Its filename is
     kasan-improve-vmalloc-tests-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-improve-vmalloc-tests-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-improve-vmalloc-tests-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: similar to "kasan: test: fix compatibility with FORTIFY_SOURCE"

Link: https://lkml.kernel.org/r/20220128144801.73f5ced0@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_kasan.c~kasan-improve-vmalloc-tests-fix
+++ a/lib/test_kasan.c
@@ -1096,6 +1096,8 @@ static void vmalloc_oob(struct kunit *te
 	v_ptr = vmalloc(size);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
+	OPTIMIZER_HIDE_VAR(v_ptr);
+
 	/*
 	 * We have to be careful not to hit the guard page in vmalloc tests.
 	 * The MMU will catch that and crash us.
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kasan-improve-vmalloc-tests-fix.patch

