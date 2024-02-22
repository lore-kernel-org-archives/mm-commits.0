Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5916220DDB
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644473; cv=none; b=u0aQSK8kssCd+PAwLT049UiQFJzQwOPvhrWVJL7Z7sfd8SON0dM35Ts8MygK8KRtz+JeAtitcVCSzkebV/kUR3bmrn7H13on1Hkm2xA0dacU9gDVQbQLf+kxxFBV2i2Y9CqoWGqKL1eEQ6/dU04qXNedDjgCi+55emlnQujs9s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644473; c=relaxed/simple;
	bh=l1XPNE3McK7/8fdTDOHuTpQXN6iFWoYHYdHee5ws3NA=;
	h=Date:To:From:Subject:Message-Id; b=LV9kjnUbbGHkCKh4C2H/r9lJAmVAOPLL37i+g7Jfs3nNqz/iYxie0IbEfff8/O+sPicrqo7JLUNKjakuDvoNdAQ5c0CFMoQ4npgbMT9CZuYzpPo/BeAzzlitxSmcViKph+myeB7bKhkuh94JxObkhbWmUN7bKD1wvSpRz4wiNbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H27lMyEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H27lMyEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABF6C43399;
	Thu, 22 Feb 2024 23:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644472;
	bh=l1XPNE3McK7/8fdTDOHuTpQXN6iFWoYHYdHee5ws3NA=;
	h=Date:To:From:Subject:From;
	b=H27lMyErqN8XNsw0+oQ86cnwGpvggRA0jIAqzI7KU80eUOY+o1e2v6l6qdj+VA+oF
	 kYAT67XRmFA2RS4cODqtNYbxCdrH1SMlQSrs51pWXxTeVFtRKfPSCHgvq6eNlYduPf
	 2kPE9ACRpKTZyOrGEKnGlNa9L9m5xDCr8cxciZhY=
Date: Thu, 22 Feb 2024 15:27:52 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shuah@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-add-zswapin-and-no-zswap-tests.patch removed from -mm tree
Message-Id: <20240222232752.CABF6C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: add zswapin and no zswap tests
has been removed from the -mm tree.  Its filename was
     selftests-add-zswapin-and-no-zswap-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: selftests: add zswapin and no zswap tests
Date: Mon, 5 Feb 2024 14:56:08 -0800

Add a selftest to cover the zswapin code path, allocating more memory than
the cgroup limit to trigger swapout/zswapout, then reading the pages back
in memory several times.  This is inspired by a recently encountered
kernel crash on the zswapin path in our internal kernel, which went
undetected because of a lack of test coverage for this path.

Add a selftest to verify that when memory.zswap.max = 0, no pages can go
to the zswap pool for the cgroup.

[nphamcs@gmail.com: remove redundant comment, add success checks]
  Link: https://lkml.kernel.org/r/20240222043132.616320-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20240205225608.3083251-4-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Rik van Riel <riel@surriel.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |  120 +++++++++++++++++-
 1 file changed, 118 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-add-zswapin-and-no-zswap-tests
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -60,6 +60,27 @@ static long get_zswpout(const char *cgro
 	return cg_read_key_long(cgroup, "memory.stat", "zswpout ");
 }
 
+static int allocate_and_read_bytes(const char *cgroup, void *arg)
+{
+	size_t size = (size_t)arg;
+	char *mem = (char *)malloc(size);
+	int ret = 0;
+
+	if (!mem)
+		return -1;
+	for (int i = 0; i < size; i += 4095)
+		mem[i] = 'a';
+
+	/* Go through the allocated memory to (z)swap in and out pages */
+	for (int i = 0; i < size; i += 4095) {
+		if (mem[i] != 'a')
+			ret = -1;
+	}
+
+	free(mem);
+	return ret;
+}
+
 static int allocate_bytes(const char *cgroup, void *arg)
 {
 	size_t size = (size_t)arg;
@@ -100,7 +121,6 @@ static int test_zswap_usage(const char *
 	int ret = KSFT_FAIL;
 	char *test_group;
 
-	/* Set up */
 	test_group = cg_name(root, "no_shrink_test");
 	if (!test_group)
 		goto out;
@@ -134,6 +154,101 @@ out:
 }
 
 /*
+ * Check that when memory.zswap.max = 0, no pages can go to the zswap pool for
+ * the cgroup.
+ */
+static int test_swapin_nozswap(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *test_group;
+	long swap_peak, zswpout;
+
+	test_group = cg_name(root, "no_zswap_test");
+	if (!test_group)
+		goto out;
+	if (cg_create(test_group))
+		goto out;
+	if (cg_write(test_group, "memory.max", "8M"))
+		goto out;
+	if (cg_write(test_group, "memory.zswap.max", "0"))
+		goto out;
+
+	/* Allocate and read more than memory.max to trigger swapin */
+	if (cg_run(test_group, allocate_and_read_bytes, (void *)MB(32)))
+		goto out;
+
+	/* Verify that pages are swapped out, but no zswap happened */
+	swap_peak = cg_read_long(test_group, "memory.swap.peak");
+	if (swap_peak < 0) {
+		ksft_print_msg("failed to get cgroup's swap_peak\n");
+		goto out;
+	}
+
+	if (swap_peak < MB(24)) {
+		ksft_print_msg("at least 24MB of memory should be swapped out\n");
+		goto out;
+	}
+
+	zswpout = get_zswpout(test_group);
+	if (zswpout < 0) {
+		ksft_print_msg("failed to get zswpout\n");
+		goto out;
+	}
+
+	if (zswpout > 0) {
+		ksft_print_msg("zswapout > 0 when memory.zswap.max = 0\n");
+		goto out;
+	}
+
+	ret = KSFT_PASS;
+
+out:
+	cg_destroy(test_group);
+	free(test_group);
+	return ret;
+}
+
+/* Simple test to verify the (z)swapin code paths */
+static int test_zswapin(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *test_group;
+	long zswpin;
+
+	test_group = cg_name(root, "zswapin_test");
+	if (!test_group)
+		goto out;
+	if (cg_create(test_group))
+		goto out;
+	if (cg_write(test_group, "memory.max", "8M"))
+		goto out;
+	if (cg_write(test_group, "memory.zswap.max", "max"))
+		goto out;
+
+	/* Allocate and read more than memory.max to trigger (z)swap in */
+	if (cg_run(test_group, allocate_and_read_bytes, (void *)MB(32)))
+		goto out;
+
+	zswpin = cg_read_key_long(test_group, "memory.stat", "zswpin ");
+	if (zswpin < 0) {
+		ksft_print_msg("failed to get zswpin\n");
+		goto out;
+	}
+
+	if (zswpin < MB(24) / PAGE_SIZE) {
+		ksft_print_msg("at least 24MB should be brought back from zswap\n");
+		goto out;
+	}
+
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
  * limit in zswap, writeback should affect only the zswapped pages of that
  * memcg.
@@ -144,7 +259,6 @@ static int test_no_invasive_cgroup_shrin
 	size_t control_allocation_size = MB(10);
 	char *control_allocation, *wb_group = NULL, *control_group = NULL;
 
-	/* Set up */
 	wb_group = setup_test_group_1M(root, "per_memcg_wb_test1");
 	if (!wb_group)
 		return KSFT_FAIL;
@@ -309,6 +423,8 @@ struct zswap_test {
 	const char *name;
 } tests[] = {
 	T(test_zswap_usage),
+	T(test_swapin_nozswap),
+	T(test_zswapin),
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
 };
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch

