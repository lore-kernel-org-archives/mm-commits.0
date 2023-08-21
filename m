Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E4BEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjHUUn5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjHUUnP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE893CD7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E16964B41
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22ECC433CC;
        Mon, 21 Aug 2023 20:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650512;
        bh=espbyFLiQxXz6inkAKKCjRHOekKq3PxTQ99gadRX1yo=;
        h=Date:To:From:Subject:From;
        b=2AL8cVn/CbbO2l/j4QPWx56EPO5fG32lQwMDoasBLW/YK5GwqgeNStvGv/i6yIi+4
         WTLwlLv0W4MuvRtAf2m37FMo1X4938vCOOLciS5ofDl3Eb/2czyxiXRKkCJGrPUyat
         o9x83ZMFcuLu7ot8G6DjcDnhRzRfS2D/sj1Zxe8g=
Date:   Mon, 21 Aug 2023 13:41:51 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-uffd-stress-help-information.patch removed from -mm tree
Message-Id: <20230821204151.E22ECC433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix uffd-stress help information
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-uffd-stress-help-information.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


