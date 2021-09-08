Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755BCC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54EA361101
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhIHDCD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347339AbhIHDB6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBCB761131;
        Wed,  8 Sep 2021 03:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070051;
        bh=hrCzH6CKyBwJKzGuJqMipjxj8PFGtmPpym/l3xxDqhA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SAMKDPXG6jXTmNos0SFaAxl0LRgIbmxjH16Gm2onas7qdZrgwFHNzEBNzmJT14z10
         tu0FgMV72/svmozovHVll3Eza29/wkB4zyHRgGIxfSjCJZqLLcbWt3UPLFPL1mp/Ga
         M+XN3+Gq4Y+384Y48yhUCWRZymOQb7rzZkRE5d0s=
Date:   Tue, 07 Sep 2021 20:00:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gthelen@google.com,
        joel@joelfernandes.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 144/147] selftests/memfd: remove unused variable
Message-ID: <20210908030050.VmfzgCUzA%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
