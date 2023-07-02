Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613EDEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjGBXsl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjGBXsl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:48:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7961B5
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CA4360CF7
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E13AC433C8;
        Sun,  2 Jul 2023 23:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688341718;
        bh=b6TEM/gybAJtiqFPCEiJmNCpI+K9mlKByT0XezH0ccI=;
        h=Date:To:From:Subject:From;
        b=NVJ7XTu0mJOZT9WPzTDs8/1Ka/982CE8PxB+LzLf8iLgVhY7jNzMjJogReJTVcnYU
         5vsevwVX05EnPrQCu0jsKZl2ZlZUNIIUxjvacuwenpjijW2mbV2Nb43gv3KVc6wcT2
         CM3kIqC8oE/EtooDtFOTKiHUavoP49GsCA7E36PY=
Date:   Sun, 02 Jul 2023 16:48:37 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        tj@kernel.org, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev, riel@surriel.com,
        nphamcs@gmail.com, muchun.song@linux.dev, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-add-test_zswap-program.patch added to mm-unstable branch
Message-Id: <20230702234838.9E13AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: add test_zswap program
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-add-test_zswap-program.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-add-test_zswap-program.patch

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
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: selftests: cgroup: add test_zswap program
Date: Wed, 21 Jun 2023 17:35:46 +0200

Patch series "selftests: cgroup: add zswap test program".

This series adds 2 zswap related selftests that verify known and fixed
issues.  A new dedicated test program (test_zswap) is proposed since the
test cases are specific to zswap and hosts specific helpers.

The first patch adds the (empty) test program, while the other 2 add an
actual test function each.


This patch (of 3):

Add empty cgroup-zswap self test scaffold program, test functions to be
added in the next commits.

Link: https://lkml.kernel.org/r/20230621153548.428093-1-cerasuolodomenico@gmail.com
Link: https://lkml.kernel.org/r/20230621153548.428093-2-cerasuolodomenico@gmail.com
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/.gitignore   |    1 
 tools/testing/selftests/cgroup/Makefile     |    2 
 tools/testing/selftests/cgroup/test_zswap.c |   62 ++++++++++++++++++
 3 files changed, 65 insertions(+)

--- a/tools/testing/selftests/cgroup/.gitignore~selftests-cgroup-add-test_zswap-program
+++ a/tools/testing/selftests/cgroup/.gitignore
@@ -5,4 +5,5 @@ test_freezer
 test_kmem
 test_kill
 test_cpu
+test_zswap
 wait_inotify
--- a/tools/testing/selftests/cgroup/Makefile~selftests-cgroup-add-test_zswap-program
+++ a/tools/testing/selftests/cgroup/Makefile
@@ -12,6 +12,7 @@ TEST_GEN_PROGS += test_core
 TEST_GEN_PROGS += test_freezer
 TEST_GEN_PROGS += test_kill
 TEST_GEN_PROGS += test_cpu
+TEST_GEN_PROGS += test_zswap
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
 
@@ -23,3 +24,4 @@ $(OUTPUT)/test_core: cgroup_util.c
 $(OUTPUT)/test_freezer: cgroup_util.c
 $(OUTPUT)/test_kill: cgroup_util.c
 $(OUTPUT)/test_cpu: cgroup_util.c
+$(OUTPUT)/test_zswap: cgroup_util.c
--- /dev/null
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <linux/limits.h>
+#include <unistd.h>
+#include <stdio.h>
+
+#include "../kselftest.h"
+#include "cgroup_util.h"
+
+#define T(x) { x, #x }
+struct zswap_test {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+};
+#undef T
+
+static bool zswap_configured(void)
+{
+	return access("/sys/module/zswap", F_OK) == 0;
+}
+
+int main(int argc, char **argv)
+{
+	char root[PATH_MAX];
+	int i, ret = EXIT_SUCCESS;
+
+	if (cg_find_unified_root(root, sizeof(root)))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	if (!zswap_configured())
+		ksft_exit_skip("zswap isn't configured\n");
+
+	/*
+	 * Check that memory controller is available:
+	 * memory is listed in cgroup.controllers
+	 */
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller isn't available\n");
+
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("Failed to set memory controller\n");
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		switch (tests[i].fn(root)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", tests[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", tests[i].name);
+			break;
+		default:
+			ret = EXIT_FAILURE;
+			ksft_test_result_fail("%s\n", tests[i].name);
+			break;
+		}
+	}
+
+	return ret;
+}
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

selftests-cgroup-add-test_zswap-program.patch
selftests-cgroup-add-test_zswap-with-no-kmem-bypass-test.patch
selftests-cgroup-add-zswap-memcg-unwanted-writeback-test.patch

