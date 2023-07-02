Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AC7EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjGBXsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjGBXsn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:48:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710741B5
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E544660CF9
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A29C433C7;
        Sun,  2 Jul 2023 23:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688341721;
        bh=dVl0j5dE+jBvlhTo0QWSaCaUhO1SLCxsEMROECEzsyI=;
        h=Date:To:From:Subject:From;
        b=SFHpaZDeHzPSjx5MNwczWzo0eAUBmqJ003bPFSKmMRn/bryhSdTWBLf7pNQpUPKZp
         YtFr/cAb6YI68BwPrR89x1tLIeJlQiAhNFB8cFN8G+ZmZp8ZL1BIRhzys9dZwNcu+k
         ClleXcLV+ujknXc5PflVVxuXwsNzUQnIlWaLvBzk=
Date:   Sun, 02 Jul 2023 16:48:40 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        tj@kernel.org, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev, riel@surriel.com,
        nphamcs@gmail.com, muchun.song@linux.dev, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-add-test_zswap-with-no-kmem-bypass-test.patch added to mm-unstable branch
Message-Id: <20230702234841.48A29C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: add test_zswap with no kmem bypass test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-add-test_zswap-with-no-kmem-bypass-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-add-test_zswap-with-no-kmem-bypass-test.patch

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
Subject: selftests: cgroup: add test_zswap with no kmem bypass test
Date: Wed, 21 Jun 2023 17:35:47 +0200

Add a cgroup selftest that verifies memcg charging in zswap.  The original
issue was that kmem bypass was applied to pages swapped out to zswap by
kswapd, resulting in zswapped memory not being charged.  It was fixed by
commit cd08d80ecdac("mm: correctly charge compressed memory to its
memcg").

Link: https://lkml.kernel.org/r/20230621153548.428093-3-cerasuolodomenico@gmail.com
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

 tools/testing/selftests/cgroup/test_zswap.c |  163 ++++++++++++++++++
 1 file changed, 163 insertions(+)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-add-test_zswap-with-no-kmem-bypass-test
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -4,15 +4,178 @@
 #include <linux/limits.h>
 #include <unistd.h>
 #include <stdio.h>
+#include <signal.h>
+#include <sys/sysinfo.h>
+#include <string.h>
+#include <sys/wait.h>
+#include <sys/mman.h>
 
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+static int read_int(const char *path, size_t *value)
+{
+	FILE *file;
+	int ret = 0;
+
+	file = fopen(path, "r");
+	if (!file)
+		return -1;
+	if (fscanf(file, "%ld", value) != 1)
+		ret = -1;
+	fclose(file);
+	return ret;
+}
+
+static int set_min_free_kb(size_t value)
+{
+	FILE *file;
+	int ret;
+
+	file = fopen("/proc/sys/vm/min_free_kbytes", "w");
+	if (!file)
+		return -1;
+	ret = fprintf(file, "%ld\n", value);
+	fclose(file);
+	return ret;
+}
+
+static int read_min_free_kb(size_t *value)
+{
+	return read_int("/proc/sys/vm/min_free_kbytes", value);
+}
+
+static int get_zswap_stored_pages(size_t *value)
+{
+	return read_int("/sys/kernel/debug/zswap/stored_pages", value);
+}
+
+struct no_kmem_bypass_child_args {
+	size_t target_alloc_bytes;
+	size_t child_allocated;
+};
+
+static int no_kmem_bypass_child(const char *cgroup, void *arg)
+{
+	struct no_kmem_bypass_child_args *values = arg;
+	void *allocation;
+
+	allocation = malloc(values->target_alloc_bytes);
+	if (!allocation) {
+		values->child_allocated = true;
+		return -1;
+	}
+	for (long i = 0; i < values->target_alloc_bytes; i += 4095)
+		((char *)allocation)[i] = 'a';
+	values->child_allocated = true;
+	pause();
+	free(allocation);
+	return 0;
+}
+
+/*
+ * When pages owned by a memcg are pushed to zswap by kswapd, they should be
+ * charged to that cgroup. This wasn't the case before commit
+ * cd08d80ecdac("mm: correctly charge compressed memory to its memcg").
+ *
+ * The test first allocates memory in a memcg, then raises min_free_kbytes to
+ * a very high value so that the allocation falls below low wm, then makes
+ * another allocation to trigger kswapd that should push the memcg-owned pages
+ * to zswap and verifies that the zswap pages are correctly charged.
+ *
+ * To be run on a VM with at most 4G of memory.
+ */
+static int test_no_kmem_bypass(const char *root)
+{
+	size_t min_free_kb_high, min_free_kb_low, min_free_kb_original;
+	struct no_kmem_bypass_child_args *values;
+	size_t trigger_allocation_size;
+	int wait_child_iteration = 0;
+	long stored_pages_threshold;
+	struct sysinfo sys_info;
+	int ret = KSFT_FAIL;
+	int child_status;
+	char *test_group;
+	pid_t child_pid;
+
+	/* Read sys info and compute test values accordingly */
+	if (sysinfo(&sys_info) != 0)
+		return KSFT_FAIL;
+	if (sys_info.totalram > 5000000000)
+		return KSFT_SKIP;
+	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
+			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (values == MAP_FAILED)
+		return KSFT_FAIL;
+	if (read_min_free_kb(&min_free_kb_original))
+		return KSFT_FAIL;
+	min_free_kb_high = sys_info.totalram / 2000;
+	min_free_kb_low = sys_info.totalram / 500000;
+	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
+		sys_info.totalram * 5 / 100;
+	stored_pages_threshold = sys_info.totalram / 5 / 4096;
+	trigger_allocation_size = sys_info.totalram / 20;
+
+	/* Set up test memcg */
+	if (cg_write(root, "cgroup.subtree_control", "+memory"))
+		goto out;
+	test_group = cg_name(root, "kmem_bypass_test");
+	if (!test_group)
+		goto out;
+
+	/* Spawn memcg child and wait for it to allocate */
+	set_min_free_kb(min_free_kb_low);
+	if (cg_create(test_group))
+		goto out;
+	values->child_allocated = false;
+	child_pid = cg_run_nowait(test_group, no_kmem_bypass_child, values);
+	if (child_pid < 0)
+		goto out;
+	while (!values->child_allocated && wait_child_iteration++ < 10000)
+		usleep(1000);
+
+	/* Try to wakeup kswapd and let it push child memory to zswap */
+	set_min_free_kb(min_free_kb_high);
+	for (int i = 0; i < 20; i++) {
+		size_t stored_pages;
+		char *trigger_allocation = malloc(trigger_allocation_size);
+
+		if (!trigger_allocation)
+			break;
+		for (int i = 0; i < trigger_allocation_size; i += 4095)
+			trigger_allocation[i] = 'b';
+		usleep(100000);
+		free(trigger_allocation);
+		if (get_zswap_stored_pages(&stored_pages))
+			break;
+		if (stored_pages < 0)
+			break;
+		/* If memory was pushed to zswap, verify it belongs to memcg */
+		if (stored_pages > stored_pages_threshold) {
+			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
+			int delta = stored_pages * 4096 - zswapped;
+			int result_ok = delta < stored_pages * 4096 / 4;
+
+			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
+			break;
+		}
+	}
+
+	kill(child_pid, SIGTERM);
+	waitpid(child_pid, &child_status, 0);
+out:
+	set_min_free_kb(min_free_kb_original);
+	cg_destroy(test_group);
+	free(test_group);
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct zswap_test {
 	int (*fn)(const char *root);
 	const char *name;
 } tests[] = {
+	T(test_no_kmem_bypass),
 };
 #undef T
 
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

selftests-cgroup-add-test_zswap-program.patch
selftests-cgroup-add-test_zswap-with-no-kmem-bypass-test.patch
selftests-cgroup-add-zswap-memcg-unwanted-writeback-test.patch

