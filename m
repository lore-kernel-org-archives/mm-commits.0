Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1422C25B48
	for <mm-commits@archiver.kernel.org>; Thu, 26 Oct 2023 20:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjJZUM3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Oct 2023 16:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjJZUM2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Oct 2023 16:12:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C0E129
        for <mm-commits@vger.kernel.org>; Thu, 26 Oct 2023 13:12:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B02C433C7;
        Thu, 26 Oct 2023 20:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698351146;
        bh=GYr+So4Gs9wynbi4FE3yNMEoUCzfMvC+LgEqP/SB7dQ=;
        h=Date:To:From:Subject:From;
        b=DyZu7fBL/ZHi4QK6tE53WchTp/9I9ICIy/kqTZm40iHx5VqTmTenRVvm0a8NuV67y
         4/z7W+nnE7EALN0/OGPvGXDnxAJSvOnJqOLaA31g7OSuB8nbpuCUUzBTcjkJ5aiETL
         RlH0a07X+JCaIuS6LxelxzrrxU3OGrZFNYsE/zmY=
Date:   Thu, 26 Oct 2023 13:12:25 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shuah@kernel.org,
        riel@surriel.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        cerasuolodomenico@gmail.com, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-add-a-sanity-check-for-zswap.patch added to mm-unstable branch
Message-Id: <20231026201226.39B02C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add a sanity check for zswap
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-add-a-sanity-check-for-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-add-a-sanity-check-for-zswap.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: selftests: add a sanity check for zswap
Date: Fri, 20 Oct 2023 15:20:09 -0700

We recently encountered a bug that makes all zswap store attempt fail. 
Specifically, after:

"141fdeececb3 mm/zswap: delay the initialization of zswap"

if we build a kernel with zswap disabled by default, then enabled after
the swapfile is set up, the zswap tree will not be initialized.  As a
result, all zswap store calls will be short-circuited.  We have to perform
another swapon to get zswap working properly again.

Fortunately, this issue has since been fixed by the patch that kills
frontswap:

"42c06a0e8ebe mm: kill frontswap"

which performs zswap_swapon() unconditionally, i.e always initializing
the zswap tree.

This test add a sanity check that ensure zswap storing works as
intended.

Link: https://lkml.kernel.org/r/20231020222009.2358953-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   48 ++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-add-a-sanity-check-for-zswap
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -55,6 +55,11 @@ static int get_zswap_written_back_pages(
 	return read_int("/sys/kernel/debug/zswap/written_back_pages", value);
 }
 
+static long get_zswpout(const char *cgroup)
+{
+	return cg_read_key_long(cgroup, "memory.stat", "zswpout ");
+}
+
 static int allocate_bytes(const char *cgroup, void *arg)
 {
 	size_t size = (size_t)arg;
@@ -69,6 +74,48 @@ static int allocate_bytes(const char *cg
 }
 
 /*
+ * Sanity test to check that pages are written into zswap.
+ */
+static int test_zswap_usage(const char *root)
+{
+	long zswpout_before, zswpout_after;
+	int ret = KSFT_FAIL;
+	char *test_group;
+
+	/* Set up */
+	test_group = cg_name(root, "no_shrink_test");
+	if (!test_group)
+		goto out;
+	if (cg_create(test_group))
+		goto out;
+	if (cg_write(test_group, "memory.max", "1M"))
+		goto out;
+
+	zswpout_before = get_zswpout(test_group);
+	if (zswpout_before < 0) {
+		ksft_print_msg("Failed to get zswpout\n");
+		goto out;
+	}
+
+	/* Allocate more than memory.max to push memory into zswap */
+	if (cg_run(test_group, allocate_bytes, (void *)MB(4)))
+		goto out;
+
+	/* Verify that pages come into zswap */
+	zswpout_after = get_zswpout(test_group);
+	if (zswpout_after <= zswpout_before) {
+		ksft_print_msg("zswpout does not increase after test program\n");
+		goto out;
+	}
+	ret = KSFT_PASS;
+
+out:
+	cg_destroy(test_group);
+	free(test_group);
+	return ret;
+}
+
+/*
  * When trying to store a memcg page in zswap, if the memcg hits its memory
  * limit in zswap, writeback should not be triggered.
  *
@@ -235,6 +282,7 @@ struct zswap_test {
 	int (*fn)(const char *root);
 	const char *name;
 } tests[] = {
+	T(test_zswap_usage),
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
 };
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-export-compression-failure-stats.patch
selftests-add-a-sanity-check-for-zswap.patch

