Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD46C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Oct 2021 03:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6731860E9C
	for <mm-commits@archiver.kernel.org>; Tue, 12 Oct 2021 03:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhJLDIg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Oct 2021 23:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231985AbhJLDIf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Oct 2021 23:08:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED0060EE5;
        Tue, 12 Oct 2021 03:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634007995;
        bh=agpDVpNXBJeJAAa99jXhjEoWOfAB9U6Ge2qoDNgzGBo=;
        h=Date:From:To:Subject:From;
        b=KfIrRJdEg4mOcD4v2brYnMbP9x3WOwcUajnc2ACEshKOAbY2uLqIaMHVE6y0VTv5i
         R6k/cHgXN07xf5yknBF0n1j+QFhT4VS2QjP5S+m4L/dJEkAT3neaynT4stYyEkdfpu
         BF7swvL25G/0uRFDdNFgSSGXNsNdioufhlJbn6i0=
Date:   Mon, 11 Oct 2021 20:06:34 -0700
From:   akpm@linux-foundation.org
To:     davidcomponentone@gmail.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, zealci@zte.com.cn, ziy@nvidia.com
Subject:  + fix-application-of-sizeof-to-pointer.patch added to -mm
 tree
Message-ID: <20211012030634.fr_B_5n2Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/split_huge_page_test.c: fix application of sizeof to pointer
has been added to the -mm tree.  Its filename is
     fix-application-of-sizeof-to-pointer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fix-application-of-sizeof-to-pointer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fix-application-of-sizeof-to-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fix-application-of-sizeof-to-pointer.patch

