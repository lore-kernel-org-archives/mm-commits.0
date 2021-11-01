Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CEEC43217
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7181060F70
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhKAS1W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Nov 2021 14:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231990AbhKAS1K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Nov 2021 14:27:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9815160FC4;
        Mon,  1 Nov 2021 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635791066;
        bh=CU1RrhmQXnnRfAPVGk1AZePxScDf0IlaRYqntIUI0jQ=;
        h=Date:From:To:Subject:From;
        b=1MYNwZwSk+HE7jjLBZTVm/AZs7SPreSPFPKaWtd73+M8yn7zxQozCjfNocgw9PwPC
         xiVvWc852w4DM3yJs8NRZpa0zCbH+68JahGXrrxmxdle4URMgycl394Gwug0RchzHi
         BcDteqzZ/NFjDtabN/Nk+eWg1sFtGTcbHUDSTOJ4=
Date:   Mon, 01 Nov 2021 11:24:26 -0700
From:   akpm@linux-foundation.org
To:     davidcomponentone@gmail.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, zealci@zte.com.cn, ziy@nvidia.com
Subject:  [merged] fix-application-of-sizeof-to-pointer.patch
 removed from -mm tree
Message-ID: <20211101182426.3UUv7tlUC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/split_huge_page_test.c: fix application of sizeof to pointer
has been removed from the -mm tree.  Its filename was
     fix-application-of-sizeof-to-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from davidcomponentone@gmail.com are


