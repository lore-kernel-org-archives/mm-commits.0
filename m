Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2667CC07D5A
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 20:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbjK0Un6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 15:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbjK0Uny (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 15:43:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBE4BE
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 12:43:57 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D03EC433C7;
        Mon, 27 Nov 2023 20:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701117837;
        bh=53DUf3uDIV8vPgAJ2jrhpiyrJXocnMG2+7UNCQO8Mo0=;
        h=Date:To:From:Subject:From;
        b=lw5LGbdQu4mbO3ErIrMB7wdOv0ekHJbyKXxGVHqK/QtpX0X3U4mLC+BXLx8rIwpdR
         NbGgW0CtWa6l4SrcTNz+wge0GCnWX67fUoKMfRCEAGnIOBiEPhG7DiyQ5EpeLXFGvv
         aqnrV09gzUIxjJ4g9j3sOxiG4N3wFLD5gq2WNXIA=
Date:   Mon, 27 Nov 2023 12:43:56 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev, nphamcs@gmail.com,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, chrisl@kernel.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-update-per-memcg-zswap-writeback-selftest.patch added to mm-unstable branch
Message-Id: <20231127204357.3D03EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: update per-memcg zswap writeback selftest
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-update-per-memcg-zswap-writeback-selftest.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-update-per-memcg-zswap-writeback-selftest.patch

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
Subject: selftests: cgroup: update per-memcg zswap writeback selftest
Date: Mon, 27 Nov 2023 11:37:02 -0800

The memcg-zswap self test is updated to adjust to the behavior change
implemented by commit 87730b165089 ("zswap: make shrinking memcg-aware"),
where zswap performs writeback for specific memcg.

Link: https://lkml.kernel.org/r/20231127193703.1980089-6-nphamcs@gmail.com
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   74 ++++++++++++------
 1 file changed, 50 insertions(+), 24 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-update-per-memcg-zswap-writeback-selftest
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -50,9 +50,9 @@ static int get_zswap_stored_pages(size_t
 	return read_int("/sys/kernel/debug/zswap/stored_pages", value);
 }
 
-static int get_zswap_written_back_pages(size_t *value)
+static int get_cg_wb_count(const char *cg)
 {
-	return read_int("/sys/kernel/debug/zswap/written_back_pages", value);
+	return cg_read_key_long(cg, "memory.stat", "zswp_wb");
 }
 
 static long get_zswpout(const char *cgroup)
@@ -73,6 +73,24 @@ static int allocate_bytes(const char *cg
 	return 0;
 }
 
+static char *setup_test_group_1M(const char *root, const char *name)
+{
+	char *group_name = cg_name(root, name);
+
+	if (!group_name)
+		return NULL;
+	if (cg_create(group_name))
+		goto fail;
+	if (cg_write(group_name, "memory.max", "1M")) {
+		cg_destroy(group_name);
+		goto fail;
+	}
+	return group_name;
+fail:
+	free(group_name);
+	return NULL;
+}
+
 /*
  * Sanity test to check that pages are written into zswap.
  */
@@ -117,43 +135,51 @@ out:
 
 /*
  * When trying to store a memcg page in zswap, if the memcg hits its memory
- * limit in zswap, writeback should not be triggered.
- *
- * This was fixed with commit 0bdf0efa180a("zswap: do not shrink if cgroup may
- * not zswap"). Needs to be revised when a per memcg writeback mechanism is
- * implemented.
+ * limit in zswap, writeback should affect only the zswapped pages of that
+ * memcg.
  */
 static int test_no_invasive_cgroup_shrink(const char *root)
 {
-	size_t written_back_before, written_back_after;
 	int ret = KSFT_FAIL;
-	char *test_group;
+	size_t control_allocation_size = MB(10);
+	char *control_allocation, *wb_group = NULL, *control_group = NULL;
 
 	/* Set up */
-	test_group = cg_name(root, "no_shrink_test");
-	if (!test_group)
+	wb_group = setup_test_group_1M(root, "per_memcg_wb_test1");
+	if (!wb_group)
+		return KSFT_FAIL;
+	if (cg_write(wb_group, "memory.zswap.max", "10K"))
 		goto out;
-	if (cg_create(test_group))
-		goto out;
-	if (cg_write(test_group, "memory.max", "1M"))
+	control_group = setup_test_group_1M(root, "per_memcg_wb_test2");
+	if (!control_group)
 		goto out;
-	if (cg_write(test_group, "memory.zswap.max", "10K"))
+
+	/* Push some test_group2 memory into zswap */
+	if (cg_enter_current(control_group))
 		goto out;
-	if (get_zswap_written_back_pages(&written_back_before))
+	control_allocation = malloc(control_allocation_size);
+	for (int i = 0; i < control_allocation_size; i += 4095)
+		control_allocation[i] = 'a';
+	if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
 		goto out;
 
-	/* Allocate 10x memory.max to push memory into zswap */
-	if (cg_run(test_group, allocate_bytes, (void *)MB(10)))
+	/* Allocate 10x memory.max to push wb_group memory into zswap and trigger wb */
+	if (cg_run(wb_group, allocate_bytes, (void *)MB(10)))
 		goto out;
 
-	/* Verify that no writeback happened because of the memcg allocation */
-	if (get_zswap_written_back_pages(&written_back_after))
-		goto out;
-	if (written_back_after == written_back_before)
+	/* Verify that only zswapped memory from gwb_group has been written back */
+	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(control_group) == 0)
 		ret = KSFT_PASS;
 out:
-	cg_destroy(test_group);
-	free(test_group);
+	cg_enter_current(root);
+	if (control_group) {
+		cg_destroy(control_group);
+		free(control_group);
+	}
+	cg_destroy(wb_group);
+	free(wb_group);
+	if (control_allocation)
+		free(control_allocation);
 	return ret;
 }
 
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

zswap-make-shrinking-memcg-aware.patch
mm-memcg-add-per-memcg-zswap-writeback-stat.patch
selftests-cgroup-update-per-memcg-zswap-writeback-selftest.patch

