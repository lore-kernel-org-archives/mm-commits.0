Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F8AC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D8E611CA
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347395AbhIIVHB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347083AbhIIVGn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B70D611CC;
        Thu,  9 Sep 2021 21:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221533;
        bh=bv0mtks3pQeNuzAGq/QIIp9thoWjb4b6mhjmKowHmZE=;
        h=Date:From:To:Subject:From;
        b=NggxgoXMgU3KmYnb+ZVL+QDb8Zq9JdqsEgtNPP1EXaWYRmGNv1tPeCdITIBKCZsi/
         tvnlCrbChzwhHnkXe18SjwvrhWMCLjd5DhpvWj7MF5e0Yn//F+G14KX3whgwDyfrM/
         kqLBJNaVjg9rmZgZNisBA8ZJYnOtelORBPJC94l8=
Date:   Thu, 09 Sep 2021 14:05:33 -0700
From:   akpm@linux-foundation.org
To:     gthelen@google.com, joel@joelfernandes.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, shuah@kernel.org
Subject:  [merged] selftests-memfd-remove-unused-variable.patch
 removed from -mm tree
Message-ID: <20210909210533.3mDKtWWik%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/memfd: remove unused variable
has been removed from the -mm tree.  Its filename was
     selftests-memfd-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


