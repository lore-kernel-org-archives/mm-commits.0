Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD51EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjHNTVc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjHNTVL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:21:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F5A10FA
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 12:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A1A662305
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 19:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB7CC433C8;
        Mon, 14 Aug 2023 19:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692040867;
        bh=83AzpG2XwawfxjgsERGC1KquxHCsbQFI00C8dCWxZ88=;
        h=Date:To:From:Subject:From;
        b=ohxgyDOo1JW13M50yf23kXS3SrJr8ERvqwBW1TfANyhnpX6ZGjHgNtrUxsGoAbnwj
         EOCuBqvOPhqiaPCYuFeCXAPpiFAzY58TDxHwKxJSWpSELswVC06isBq1zsy88qnP9p
         3LQm7DVcGbYqC315x+7dkQYvkxgecjmOL15Eqtzs=
Date:   Mon, 14 Aug 2023 12:21:06 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-uffd-stress-help-information.patch added to mm-unstable branch
Message-Id: <20230814192107.CCB7CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix uffd-stress help information
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-uffd-stress-help-information.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-uffd-stress-help-information.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Rong Tao <rongtao@cestc.cn>
Subject: selftests/mm: fix uffd-stress help information
Date: Mon, 14 Aug 2023 18:45:50 +0800

commit 686a8bb72349("selftests/mm: split uffd tests into uffd-stress and
uffd-unit-tests") split uffd tests into uffd-stress and uffd-unit-tests,
obviously we need to modify the help information synchronously.

Also modify code indentation.

Link: https://lkml.kernel.org/r/tencent_64FC724AC5F05568F41BD1C68058E83CEB05@qq.com
Signed-off-by: Rong Tao <rongtao@cestc.cn>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |   24 ++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-fix-uffd-stress-help-information
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -53,21 +53,21 @@ pthread_attr_t attr;
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
 const char *examples =
-    "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
-    "./userfaultfd anon 100 99999\n\n"
-    "# Run share memory test on 1GiB region with 99 bounces:\n"
-    "./userfaultfd shmem 1000 99\n\n"
-    "# Run hugetlb memory test on 256MiB region with 50 bounces:\n"
-    "./userfaultfd hugetlb 256 50\n\n"
-    "# Run the same hugetlb test but using private file:\n"
-    "./userfaultfd hugetlb-private 256 50\n\n"
-    "# 10MiB-~6GiB 999 bounces anonymous test, "
-    "continue forever unless an error triggers\n"
-    "while ./userfaultfd anon $[RANDOM % 6000 + 10] 999; do true; done\n\n";
+	"# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
+	"./uffd-stress anon 100 99999\n\n"
+	"# Run share memory test on 1GiB region with 99 bounces:\n"
+	"./uffd-stress shmem 1000 99\n\n"
+	"# Run hugetlb memory test on 256MiB region with 50 bounces:\n"
+	"./uffd-stress hugetlb 256 50\n\n"
+	"# Run the same hugetlb test but using private file:\n"
+	"./uffd-stress hugetlb-private 256 50\n\n"
+	"# 10MiB-~6GiB 999 bounces anonymous test, "
+	"continue forever unless an error triggers\n"
+	"while ./uffd-stress anon $[RANDOM % 6000 + 10] 999; do true; done\n\n";
 
 static void usage(void)
 {
-	fprintf(stderr, "\nUsage: ./userfaultfd <test type> <MiB> <bounces>\n\n");
+	fprintf(stderr, "\nUsage: ./uffd-stress <test type> <MiB> <bounces>\n\n");
 	fprintf(stderr, "Supported <test type>: anon, hugetlb, "
 		"hugetlb-private, shmem, shmem-private\n\n");
 	fprintf(stderr, "Examples:\n\n");
_

Patches currently in -mm which might be from rongtao@cestc.cn are

selftests-mm-fix-uffd-stress-help-information.patch

