Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1362EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjFSXUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjFSXUb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23892E55
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 014AF60F2A
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A710C433C8;
        Mon, 19 Jun 2023 23:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216829;
        bh=shEkCngCjpUX+ro40wqAvxw2lCLR9mBLjrU0UjSybkE=;
        h=Date:To:From:Subject:From;
        b=BaNNFAf/c2S9ckeoZS9Lp/WYeSUwuEh/nDW+nZpU2uF0IMLXcG0FXC9SmlsjIRzk+
         iRoEh5REfmPCe5JdJZZ5uGnHzX2pD2QG6OsTj3XtSKBmqwL1lp+dVmuSROqB5PKild
         DFFt5TiSV74ae1GX5XbnSeNsIECMRabltGq35jxU=
Date:   Mon, 19 Jun 2023 16:20:28 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch removed from -mm tree
Message-Id: <20230619232029.5A710C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix two -Wformat-security warnings in uffd builds
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix two -Wformat-security warnings in uffd builds
Date: Tue, 6 Jun 2023 00:16:32 -0700

The uffd tests generate two compile time warnings from clang's
-Wformat-security setting. These trigger at the call sites for
uffd_test_start() and uffd_test_skip().

1) Fix the uffd_test_start() issue by removing the intermediate
test_name variable (thanks to David Hildenbrand for showing how to do
this).

2) Fix the uffd_test_skip() issue by observing that there is no need for
a macro and a variable args approach, because all callers of
uffd_test_skip() pass in a simple char* string, without any format
specifiers. So just change uffd_test_skip() into a regular C function.

Link: https://lkml.kernel.org/r/20230606071637.267103-7-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -109,12 +109,11 @@ static void uffd_test_pass(void)
 		ksft_inc_fail_cnt();		\
 	} while (0)
 
-#define  uffd_test_skip(...)  do {		\
-		printf("skipped [reason: ");	\
-		printf(__VA_ARGS__);		\
-		printf("]\n");			\
-		ksft_inc_xskip_cnt();		\
-	} while (0)
+static void uffd_test_skip(const char *message)
+{
+	printf("skipped [reason: %s]\n", message);
+	ksft_inc_xskip_cnt();
+}
 
 /*
  * Returns 1 if specific userfaultfd supported, 0 otherwise.  Note, we'll
@@ -1149,7 +1148,6 @@ int main(int argc, char *argv[])
 	uffd_test_case_t *test;
 	mem_type_t *mem_type;
 	uffd_test_args_t args;
-	char test_name[128];
 	const char *errmsg;
 	int has_uffd, opt;
 	int i, j;
@@ -1192,10 +1190,8 @@ int main(int argc, char *argv[])
 			mem_type = &mem_types[j];
 			if (!(test->mem_targets & mem_type->mem_flag))
 				continue;
-			snprintf(test_name, sizeof(test_name),
-				 "%s on %s", test->name, mem_type->name);
 
-			uffd_test_start(test_name);
+			uffd_test_start("%s on %s", test->name, mem_type->name);
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


