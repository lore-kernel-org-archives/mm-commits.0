Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B4BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2AD610CA
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhJ1VjP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231396AbhJ1VjE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 17:39:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FC14610E7;
        Thu, 28 Oct 2021 21:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456997;
        bh=uVXX96cpryr4jYBl0p51ywZQ2aOWyCxUngA8ubIxcxU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SpB1huqAqkpz9HwrImHJg9jZTsqnAi7c8pE4mG9AsPn3uwJazUqHLKufoqaDESAqI
         Zvd/Lt4Sx/P3FREid55dt+gd/gp7Z4zHq+MK5XEUyurHUbcJM0WYeaoCYaql/kPq/5
         xIuQuIK0o9/A1fEt6Ti9c4maV4oqdQxkk4vAavEQ=
Date:   Thu, 28 Oct 2021 14:36:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davidcomponentone@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        torvalds@linux-foundation.org, zealci@zte.com.cn, ziy@nvidia.com
Subject:  [patch 11/11]
 tools/testing/selftests/vm/split_huge_page_test.c: fix application of
 sizeof to pointer
Message-ID: <20211028213636.ffTjwzUhv%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Yang <davidcomponentone@gmail.com>
Subject: tools/testing/selftests/vm/split_huge_page_test.c: fix application of sizeof to pointer

The coccinelle check report:
"./tools/testing/selftests/vm/split_huge_page_test.c:344:36-42:
ERROR: application of sizeof to pointer"
Using the "strlen" to fix it.

Link: https://lkml.kernel.org/r/20211012030116.184027-1-davidcomponentone@gmail.com
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/split_huge_page_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/split_huge_page_test.c~fix-application-of-sizeof-to-pointer
+++ a/tools/testing/selftests/vm/split_huge_page_test.c
@@ -341,7 +341,7 @@ void split_file_backed_thp(void)
 	}
 
 	/* write something to the file, so a file-backed THP can be allocated */
-	num_written = write(fd, tmpfs_loc, sizeof(tmpfs_loc));
+	num_written = write(fd, tmpfs_loc, strlen(tmpfs_loc) + 1);
 	close(fd);
 
 	if (num_written < 1) {
_
