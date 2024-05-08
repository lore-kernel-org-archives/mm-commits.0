Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8124BA94
	for <mm-commits@vger.kernel.org>; Wed,  8 May 2024 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715188861; cv=none; b=fpYBAd7dZlzFL4Lo/yHr26/nb4p4nRayaEj9VQdBVBVsaPkQH7iQB5IdphDk3DeJSkrQ5NwAYyyf8O5sTl4PINijcKXME2Ezmpt9Zco2C2R/f8Rpi8JXJvSow/dH4bzGKd/nLrlU5UzPV+iGhhJA/B7O2wPN8Zy1WDNHQRwD7Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715188861; c=relaxed/simple;
	bh=0U8RHPUsUCCE3H+kkLkpzursFFuRNUwQmcxnmnnFgt8=;
	h=Date:To:From:Subject:Message-Id; b=ZYBhsCx+QKRo06ymyUGtkyX00C7wz0Kcws4UbS1hkqGDXL3fzhr7pSGKNCCOwsnLpheuq1WfvEayuLLIKInHUaqgs77iABkboQGBdgXEdiBBVlsnZfLLpkwt44tGcWZ4cpscnJK1HJricVGPkrIYAyg1YDjtbdNGRb6zlVU7ifA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=khh24sOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="khh24sOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA51C32781;
	Wed,  8 May 2024 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715188860;
	bh=0U8RHPUsUCCE3H+kkLkpzursFFuRNUwQmcxnmnnFgt8=;
	h=Date:To:From:Subject:From;
	b=khh24sOh45XnDIoMt1u9SjkanTrcOPfGZBxFKe1vgN7ywU3UULAfR0nL3ZL2+MLa+
	 RyaVxLnCFJYRWCT6h8v1Zmhhts/940H+C9drSyly/nj+ik1dKrH4SuZIHZo+3HkLzT
	 qZ03HH6kGNCnjTsiHaUqwiCzL8vrvafwYyJl71CU=
Date: Wed, 08 May 2024 10:20:59 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-add-tests-to-verify-the-zswap-writeback-path.patch added to mm-unstable branch
Message-Id: <20240508172100.5FA51C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: cgroup: add tests to verify the zswap writeback path
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-add-tests-to-verify-the-zswap-writeback-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-add-tests-to-verify-the-zswap-writeback-path.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: selftests: cgroup: add tests to verify the zswap writeback path
Date: Wed, 8 May 2024 18:13:59 +0100

Attempt writeback with the below steps and check using memory.stat.zswpwb
if zswap writeback occurred:

1. Allocate memory.
2. Reclaim memory equal to the amount that was allocated in step 1.
   This will move it into zswap.
3. Save current zswap usage.
4. Move the memory allocated in step 1 back in from zswap.
5. Set zswap.max to half the amount that was recorded in step 3.
6. Attempt to reclaim memory equal to the amount that was allocated,
   this will either trigger writeback if it's enabled, or reclamation
   will fail if writeback is disabled as there isn't enough zswap
   space.

Link: https://lkml.kernel.org/r/20240508171359.1545744-1-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |  130 +++++++++++++++++-
 1 file changed, 129 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-add-tests-to-verify-the-zswap-writeback-path
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -50,7 +50,7 @@ static int get_zswap_stored_pages(size_t
 	return read_int("/sys/kernel/debug/zswap/stored_pages", value);
 }
 
-static int get_cg_wb_count(const char *cg)
+static long get_cg_wb_count(const char *cg)
 {
 	return cg_read_key_long(cg, "memory.stat", "zswpwb");
 }
@@ -249,6 +249,132 @@ out:
 }
 
 /*
+ * Attempt writeback with the following steps:
+ * 1. Allocate memory.
+ * 2. Reclaim memory equal to the amount that was allocated in step 1.
+      This will move it into zswap.
+ * 3. Save current zswap usage.
+ * 4. Move the memory allocated in step 1 back in from zswap.
+ * 5. Set zswap.max to half the amount that was recorded in step 3.
+ * 6. Attempt to reclaim memory equal to the amount that was allocated,
+      this will either trigger writeback if it's enabled, or reclamation
+      will fail if writeback is disabled as there isn't enough zswap space.
+ */
+static int attempt_writeback(const char *cgroup, void *arg)
+{
+	long pagesize = sysconf(_SC_PAGESIZE);
+	char *test_group = arg;
+	size_t memsize = MB(4);
+	char buf[pagesize];
+	long zswap_usage;
+	bool wb_enabled;
+	int ret = -1;
+	char *mem;
+
+	wb_enabled = cg_read_long(test_group, "memory.zswap.writeback");
+	mem = (char *)malloc(memsize);
+	if (!mem)
+		return ret;
+
+	/*
+	 * Fill half of each page with increasing data, and keep other
+	 * half empty, this will result in data that is still compressible
+	 * and ends up in zswap, with material zswap usage.
+	 */
+	for (int i = 0; i < pagesize; i++)
+		buf[i] = i < pagesize/2 ? (char) i : 0;
+
+	for (int i = 0; i < memsize; i += pagesize)
+		memcpy(&mem[i], buf, pagesize);
+
+	/* Try and reclaim allocated memory */
+	if (cg_write_numeric(test_group, "memory.reclaim", memsize)) {
+		ksft_print_msg("Failed to reclaim all of the requested memory\n");
+		goto out;
+	}
+
+	zswap_usage = cg_read_long(test_group, "memory.zswap.current");
+
+	/* zswpin */
+	for (int i = 0; i < memsize; i += pagesize) {
+		if (memcmp(&mem[i], buf, pagesize)) {
+			ksft_print_msg("invalid memory\n");
+			goto out;
+		}
+	}
+
+	if (cg_write_numeric(test_group, "memory.zswap.max", zswap_usage/2))
+		goto out;
+
+	/*
+	 * If writeback is enabled, trying to reclaim memory now will trigger a
+	 * writeback as zswap.max is half of what was needed when reclaim ran the first time.
+	 * If writeback is disabled, memory reclaim will fail as zswap is limited and
+	 * it can't writeback to swap.
+	 */
+	ret = cg_write_numeric(test_group, "memory.reclaim", memsize);
+	if (!wb_enabled)
+		ret = (ret == -EAGAIN) ? 0 : -1;
+
+out:
+	free(mem);
+	return ret;
+}
+
+/* Test to verify the zswap writeback path */
+static int test_zswap_writeback(const char *root, bool wb)
+{
+	long zswpwb_before, zswpwb_after;
+	int ret = KSFT_FAIL;
+	char *test_group;
+
+	test_group = cg_name(root, "zswap_writeback_test");
+	if (!test_group)
+		goto out;
+	if (cg_create(test_group))
+		goto out;
+	if (cg_write(test_group, "memory.zswap.writeback", wb ? "1" : "0"))
+		goto out;
+
+	zswpwb_before = get_cg_wb_count(test_group);
+	if (zswpwb_before != 0) {
+		ksft_print_msg("zswpwb_before = %ld instead of 0\n", zswpwb_before);
+		goto out;
+	}
+
+	if (cg_run(test_group, attempt_writeback, (void *) test_group))
+		goto out;
+
+	/* Verify that zswap writeback occurred only if writeback was enabled */
+	zswpwb_after = get_cg_wb_count(test_group);
+	if (zswpwb_after < 0)
+		goto out;
+
+	if (wb != !!zswpwb_after) {
+		ksft_print_msg("zswpwb_after is %ld while wb is %s",
+				zswpwb_after, wb ? "enabled" : "disabled");
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
+static int test_zswap_writeback_enabled(const char *root)
+{
+	return test_zswap_writeback(root, true);
+}
+
+static int test_zswap_writeback_disabled(const char *root)
+{
+	return test_zswap_writeback(root, false);
+}
+
+/*
  * When trying to store a memcg page in zswap, if the memcg hits its memory
  * limit in zswap, writeback should affect only the zswapped pages of that
  * memcg.
@@ -423,6 +549,8 @@ struct zswap_test {
 	T(test_zswap_usage),
 	T(test_swapin_nozswap),
 	T(test_zswapin),
+	T(test_zswap_writeback_enabled),
+	T(test_zswap_writeback_disabled),
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
 };
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

selftests-cgroup-remove-redundant-addition-of-memory-controller.patch
selftests-cgroup-add-tests-to-verify-the-zswap-writeback-path.patch

