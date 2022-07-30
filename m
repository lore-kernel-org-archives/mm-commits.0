Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304DBC19F2D
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiG3BIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239595AbiG3BIT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214A0820F5
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2A6F61C41
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04471C433B5;
        Sat, 30 Jul 2022 01:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143298;
        bh=C4VxR7oN25Ntab3d+uIa+sHoRrkrlWlPDnQSrhQ74xY=;
        h=Date:To:From:Subject:From;
        b=ok8I6VY9t4A8CnAZhPtp9V7cWBaiC9njQLWpMJPX8WQ+C8IzXRV9aVYCD3guwCVub
         VyGXMUoRn4H5kq+P8hpabu0fbbDDT4p9R5TFnqO9PXtPvc7yVLajuX5DPhSYRSAS5w
         +f/ymJNRzvnT0YX/iKI0/Ly1Z74toIXevdP+kvfY=
Date:   Fri, 29 Jul 2022 18:08:17 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, shuah@kernel.org,
        adam@wowsignal.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-skip-128tbswitch-on-unsupported-arch.patch removed from -mm tree
Message-Id: <20220730010818.04471C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: skip 128TBswitch on unsupported arch
has been removed from the -mm tree.  Its filename was
     selftests-vm-skip-128tbswitch-on-unsupported-arch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Adam Sindelar <adam@wowsignal.io>
Subject: selftests/vm: skip 128TBswitch on unsupported arch
Date: Mon, 4 Jul 2022 14:38:13 +0200

The test va_128TBswitch.c exercises a feature only supported on PPC and
x86_64, but it's run on other 64-bit archs as well.  Before this patch,
the test did nothing and returned 0 for KSFT_PASS.  This patch makes it
return the KSFT codes from kselftest.h, including KSFT_SKIP when
appropriate.

Verified on arm64 and x86_64.

Link: https://lkml.kernel.org/r/20220704123813.427625-1-adam@wowsignal.io
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Cc: David Vernet <void@manifault.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/va_128TBswitch.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/vm/va_128TBswitch.c~selftests-vm-skip-128tbswitch-on-unsupported-arch
+++ a/tools/testing/selftests/vm/va_128TBswitch.c
@@ -231,7 +231,7 @@ static struct testcase hugetlb_testcases
 static int run_test(struct testcase *test, int count)
 {
 	void *p;
-	int i, ret = 0;
+	int i, ret = KSFT_PASS;
 
 	for (i = 0; i < count; i++) {
 		struct testcase *t = test + i;
@@ -242,13 +242,13 @@ static int run_test(struct testcase *tes
 
 		if (p == MAP_FAILED) {
 			printf("FAILED\n");
-			ret = 1;
+			ret = KSFT_FAIL;
 			continue;
 		}
 
 		if (t->low_addr_required && p >= (void *)(ADDR_SWITCH_HINT)) {
 			printf("FAILED\n");
-			ret = 1;
+			ret = KSFT_FAIL;
 		} else {
 			/*
 			 * Do a dereference of the address returned so that we catch
@@ -280,7 +280,7 @@ int main(int argc, char **argv)
 	int ret;
 
 	if (!supported_arch())
-		return 0;
+		return KSFT_SKIP;
 
 	ret = run_test(testcases, ARRAY_SIZE(testcases));
 	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
_

Patches currently in -mm which might be from adam@wowsignal.io are


