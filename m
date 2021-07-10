Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56B3C07E95
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E1F6135D
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhGJVgK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 17:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhGJVgK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 17:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAC086135B;
        Sat, 10 Jul 2021 21:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625952804;
        bh=KXS0s1B4vx2BQUJPSkLMLjMcjMEB5gbn7Awx9MU+0SU=;
        h=Date:From:To:Subject:From;
        b=2qOMZfB9Rb06wtPHHcO67V2P0m9F+elxV4cG36HMsIRQQrIczcibX7dzY20VWTHvl
         Ff4SDCP0bRhaOgTuEykUamuw2jozUIf2dzOAkrq7Mn5A87iahwq/nw0UHIOSZ73n5k
         0KjxdcHIk9kNc7TsNAF3dLriFAHUkqzEdW3z1q3o=
Date:   Sat, 10 Jul 2021 14:33:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shuah@kernel.org, mpe@ellerman.id.au,
        joel@joelfernandes.org, gthelen@google.com
Subject:  + selftests-memfd-remove-unused-variable.patch added to -mm
 tree
Message-ID: <20210710213324.5sqzV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/memfd: remove unused variable
has been added to the -mm tree.  Its filename is
     selftests-memfd-remove-unused-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-memfd-remove-unused-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-memfd-remove-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: selftests/memfd: remove unused variable

Commit 544029862cbb ("selftests/memfd: add tests for F_SEAL_FUTURE_WRITE
seal") added an unused variable to mfd_assert_reopen_fd().

Delete the unused variable.

Link: https://lkml.kernel.org/r/20210702045509.1517643-1-gthelen@google.com
Fixes: 544029862cbb ("selftests/memfd: add tests for F_SEAL_FUTURE_WRITE seal")
Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-remove-unused-variable
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -56,7 +56,7 @@ static int mfd_assert_new(const char *na
 
 static int mfd_assert_reopen_fd(int fd_in)
 {
-	int r, fd;
+	int fd;
 	char path[100];
 
 	sprintf(path, "/proc/self/fd/%d", fd_in);
_

Patches currently in -mm which might be from gthelen@google.com are

selftests-memfd-remove-unused-variable.patch

