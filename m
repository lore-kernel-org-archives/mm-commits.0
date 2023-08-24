Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84388C7113B
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 22:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243793AbjHXWA7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 18:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243749AbjHXWA0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 18:00:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA161BD4
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 15:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C34786342E
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 22:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E8FC433C8;
        Thu, 24 Aug 2023 22:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692914423;
        bh=y/Un3+ZBkZwT6CfaR0qrArMrxFjZzFTAeiLhWe+n+EI=;
        h=Date:To:From:Subject:From;
        b=fipqr01TpFlNP/KSDrkJSYRyRjWIh4WpYLkNLLe3bNO4kAosCAWvyjxSf3dMaw9m7
         sbkX7S8DPnOhu+O6Xw5OmkFcDsij00xL4InnstyydTFQPOUEgLMIwpCRDx7AhKaBdh
         EgpUoupjTPLLqe3rOxAFqcsoFDtpevDSpgE45x5I=
Date:   Thu, 24 Aug 2023 15:00:20 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, nphamcs@gmail.com,
        hannes@cmpxchg.org, andre.przywara@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-cachestat-test-for-cachestat-availability.patch removed from -mm tree
Message-Id: <20230824220023.26E8FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cachestat: test for cachestat availability
has been removed from the -mm tree.  Its filename was
     selftests-cachestat-test-for-cachestat-availability.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andre Przywara <andre.przywara@arm.com>
Subject: selftests: cachestat: test for cachestat availability
Date: Mon, 21 Aug 2023 17:05:33 +0100

Patch series "selftests: cachestat: fix run on older kernels", v2.

I ran all kernel selftests on some test machine, and stumbled upon
cachestat failing (among others).  These patches fix the run on older
kernels and when the current directory is on a tmpfs instance.


This patch (of 2):

As cachestat is a new syscall, it won't be available on older kernels, for
instance those running on a development machine.  At the moment the test
reports all tests as "not ok" in this case.

Test for the cachestat syscall availability first, before doing further
tests, and bail out early with a TAP SKIP comment.

This also uses the opportunity to add the proper TAP headers, and add one
check for proper error handling (illegal file descriptor).

Link: https://lkml.kernel.org/r/20230821160534.3414911-1-andre.przywara@arm.com
Link: https://lkml.kernel.org/r/20230821160534.3414911-2-andre.przywara@arm.com
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cachestat/test_cachestat.c |   20 ++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/cachestat/test_cachestat.c~selftests-cachestat-test-for-cachestat-availability
+++ a/tools/testing/selftests/cachestat/test_cachestat.c
@@ -15,6 +15,8 @@
 
 #include "../kselftest.h"
 
+#define NR_TESTS	8
+
 static const char * const dev_files[] = {
 	"/dev/zero", "/dev/null", "/dev/urandom",
 	"/proc/version", "/proc"
@@ -236,7 +238,23 @@ out:
 
 int main(void)
 {
-	int ret = 0;
+	int ret;
+
+	ksft_print_header();
+
+	ret = syscall(__NR_cachestat, -1, NULL, NULL, 0);
+	if (ret == -1 && errno == ENOSYS)
+		ksft_exit_skip("cachestat syscall not available\n");
+
+	ksft_set_plan(NR_TESTS);
+
+	if (ret == -1 && errno == EBADF) {
+		ksft_test_result_pass("bad file descriptor recognized\n");
+		ret = 0;
+	} else {
+		ksft_test_result_fail("bad file descriptor ignored\n");
+		ret = 1;
+	}
 
 	for (int i = 0; i < 5; i++) {
 		const char *dev_filename = dev_files[i];
_

Patches currently in -mm which might be from andre.przywara@arm.com are


