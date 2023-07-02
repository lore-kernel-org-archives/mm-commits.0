Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53B7EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjGBXsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjGBXsp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689A11B6
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 041D760D27
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAA7C433C7;
        Sun,  2 Jul 2023 23:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688341723;
        bh=i8fOvG2lrJHpIy83x6wEgBsnMRiSy+ejEEZ8J6AyqKE=;
        h=Date:To:From:Subject:From;
        b=SG2K2BoilS13mJ5Zv107xOButJNfkHcw0m7RC7PX4v+IUJMsNUX00Uhs26wWkWOP2
         Pf3OEBugCvs/L71+xKiF2RLhFhsysWfYcgBt6PxHZB+4Bu73bb6ja4ca5yNgtm2JEu
         s9jaaLQESMy01PmYXXlz4669q6Oiz+89dRfj+O5M=
Date:   Sun, 02 Jul 2023 16:48:42 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        tj@kernel.org, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev, riel@surriel.com,
        nphamcs@gmail.com, muchun.song@linux.dev, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-add-zswap-memcg-unwanted-writeback-test.patch added to mm-unstable branch
Message-Id: <20230702234843.4DAA7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: add zswap-memcg unwanted writeback test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-add-zswap-memcg-unwanted-writeback-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-add-zswap-memcg-unwanted-writeback-test.patch

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
Subject: selftests: cgroup: add zswap-memcg unwanted writeback test
Date: Wed, 21 Jun 2023 17:35:48 +0200

Add a test to verify that when a memcg hits its limit in zswap, it doesn't
trigger an unwanted writeback that would result in pages not owned by that
memcg to be sent to disk, even if zswap isn't full.  This was fixed by
commit 0bdf0efa180a("zswap: do not shrink if cgroup may not zswap").

Link: https://lkml.kernel.org/r/20230621153548.428093-4-cerasuolodomenico@gmail.com
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

 tools/testing/selftests/cgroup/test_zswap.c |   61 ++++++++++++++++++
 1 file changed, 61 insertions(+)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-add-zswap-memcg-unwanted-writeback-test
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -50,6 +50,66 @@ static int get_zswap_stored_pages(size_t
 	return read_int("/sys/kernel/debug/zswap/stored_pages", value);
 }
 
+static int get_zswap_written_back_pages(size_t *value)
+{
+	return read_int("/sys/kernel/debug/zswap/written_back_pages", value);
+}
+
+static int allocate_bytes(const char *cgroup, void *arg)
+{
+	size_t size = (size_t)arg;
+	char *mem = (char *)malloc(size);
+
+	if (!mem)
+		return -1;
+	for (int i = 0; i < size; i += 4095)
+		mem[i] = 'a';
+	free(mem);
+	return 0;
+}
+
+/*
+ * When trying to store a memcg page in zswap, if the memcg hits its memory
+ * limit in zswap, writeback should not be triggered.
+ *
+ * This was fixed with commit 0bdf0efa180a("zswap: do not shrink if cgroup may
+ * not zswap"). Needs to be revised when a per memcg writeback mechanism is
+ * implemented.
+ */
+static int test_no_invasive_cgroup_shrink(const char *root)
+{
+	size_t written_back_before, written_back_after;
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
+	if (cg_write(test_group, "memory.zswap.max", "10K"))
+		goto out;
+	if (get_zswap_written_back_pages(&written_back_before))
+		goto out;
+
+	/* Allocate 10x memory.max to push memory into zswap */
+	if (cg_run(test_group, allocate_bytes, (void *)MB(10)))
+		goto out;
+
+	/* Verify that no writeback happened because of the memcg allocation */
+	if (get_zswap_written_back_pages(&written_back_after))
+		goto out;
+	if (written_back_after == written_back_before)
+		ret = KSFT_PASS;
+out:
+	cg_destroy(test_group);
+	free(test_group);
+	return ret;
+}
+
 struct no_kmem_bypass_child_args {
 	size_t target_alloc_bytes;
 	size_t child_allocated;
@@ -176,6 +236,7 @@ struct zswap_test {
 	const char *name;
 } tests[] = {
 	T(test_no_kmem_bypass),
+	T(test_no_invasive_cgroup_shrink),
 };
 #undef T
 
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

selftests-cgroup-add-test_zswap-program.patch
selftests-cgroup-add-test_zswap-with-no-kmem-bypass-test.patch
selftests-cgroup-add-zswap-memcg-unwanted-writeback-test.patch

