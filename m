Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846F5C3F6B0
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbiG3BJN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239627AbiG3BIp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA42E87201
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B449B82925
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CFDC433D6;
        Sat, 30 Jul 2022 01:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143314;
        bh=K49JRjBPLA4ZxGi0dD9YhoQ7sE9nSL3FTEH1sVY2oDs=;
        h=Date:To:From:Subject:From;
        b=qXuA8Iu2YIMjWNCSZSx+t5aTQpLbpwI8MdLhVEKV/eQwZ3eQF6RkaQNbbp6niVAp5
         3NFHBIYIMQ88z/UE+pfWeevYZjXF1XVKROgE4J1BgqVWBhaWuORQSMuGJUMGKl1EW2
         M0vrJlfqTjtPdKn4Qobt34XZxATSwAu/bOHjyL7w=
Date:   Fri, 29 Jul 2022 18:08:33 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shuah@kernel.org, mike.kravetz@oracle.com, almasrymina@google.com,
        dan.carpenter@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-vm-uninitialized-variable-in-main.patch removed from -mm tree
Message-Id: <20220730010834.23CFDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest/vm: uninitialized variable in main()
has been removed from the -mm tree.  Its filename was
     selftest-vm-uninitialized-variable-in-main.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: selftest/vm: uninitialized variable in main()
Date: Tue, 19 Jul 2022 12:04:14 +0300

Initialize "length" to zero by default.

Link: https://lkml.kernel.org/r/YtZzjvHXVXMXxpXO@kili
Fixes: ff712a627f72 ("selftests/vm: cleanup hugetlb file after mremap test")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~selftest-vm-uninitialized-variable-in-main
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -107,7 +107,7 @@ static void register_region_with_uffd(ch
 
 int main(int argc, char *argv[])
 {
-	size_t length;
+	size_t length = 0;
 
 	if (argc != 2 && argc != 3) {
 		printf("Usage: %s [length_in_MB] <hugetlb_file>\n", argv[0]);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are


