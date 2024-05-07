Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C01317BA1
	for <mm-commits@vger.kernel.org>; Tue,  7 May 2024 16:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715100875; cv=none; b=VyJS4K74wmiG5SVTKB8z1LDW0p9oN3C2AnmMGDUUv8yXUndx8uikeP0aCf9yeRsd7PqEn/9K/hFpZeQA0FsmQnSTctJ4U8ReSIdfbPRjsp7MGCmz+8d8q8SuKioRQ6VYicbqj64ZMEGxkqybMyJXYiJID/AOgyzXnZfaEuNUGco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715100875; c=relaxed/simple;
	bh=ZmseIOAZOved8WrcZeN3rI8TJMC1D8KAop4WubCwb5A=;
	h=Date:To:From:Subject:Message-Id; b=lVxHwP3uW8RXUF1L41fn/9ZuSU6/NcNeDkU5xWhOS/D7a1Ti0Z7iKg+l1Au2UBcy3MncrLN2thhQr1BcA0dQuak/mSFvrDs22rDt8v3ujdXzCS/p6sj+8+Zb1pKqG9RApZpcP612BcRSXcVKS4C+XuOerPjiu0nDX0hWk+b+QHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XarR6C3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XarR6C3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE92BC2BBFC;
	Tue,  7 May 2024 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715100874;
	bh=ZmseIOAZOved8WrcZeN3rI8TJMC1D8KAop4WubCwb5A=;
	h=Date:To:From:Subject:From;
	b=XarR6C3QbNi99p2PC3ECGMXaQKVBT5bqU/Eu+OUKIChnaWobZYUsCSv3T+F1/bhnC
	 npsfSv4jf1GWxz8kB+ddMrCy8sB+g4tawh2R2eOZaPqyHtyAwfzWSC2mfxYI+/maVh
	 CGi92032d2womvtOf5DvU6RK3rogFZn5UXVuQx10=
Date: Tue, 07 May 2024 09:54:34 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-add-tests-to-verify-the-zswap-writeback-path.patch added to mm-unstable branch
Message-Id: <20240507165434.CE92BC2BBFC@smtp.kernel.org>
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
Date: Tue, 7 May 2024 11:14:42 +0100

Initate writeback with the below steps and check using
memory.stat.zswpwb if zswap writeback occurred:
1. Allocate memory.
2. Reclaim memory equal to the amount that was allocated in step 1.
   This will move it into zswap.
3. Save current zswap usage.
4. Move the memory allocated in step 1 back in from zswap.
5. Set zswap.max to half the amount that was recorded in step 3.
6. Attempt to reclaim memory equal to the amount that was allocated,
   this will either trigger writeback if its enabled, or reclamation
   will fail if writeback is disabled as there isn't enough zswap
   space.

Link: https://lkml.kernel.org/r/20240507101443.720190-1-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |  138 +++++++++++++++++-
 1 file changed, 137 insertions(+), 1 deletion(-)

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
@@ -249,6 +249,140 @@ out:
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
+      this will either trigger writeback if its enabled, or reclamation
+      will fail if writeback is disabled as there isn't enough zswap space.
+ */
+static int attempt_writeback(const char *cgroup, void *arg)
+{
+	long pagesize = sysconf(_SC_PAGESIZE);
+	char *test_group = arg;
+	size_t memsize = MB(4);
+	long zswap_usage;
+	bool wb_enabled;
+	int ret = -1;
+	char memval;
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
+	for (int i = 0; i < memsize; i += pagesize) {
+		memval = 1;
+		for (int j = i; j < i + pagesize/2; j++) {
+			/* Overflow of memval is ok, will check with same values later */
+			mem[j] = memval++;
+		}
+	}
+
+	/* Try and reclaim allocated memory */
+	if (cg_write(test_group, "memory.reclaim", "4M")) {
+		ksft_print_msg("Failed to reclaim all of the requested memory\n");
+		goto out;
+	}
+
+	zswap_usage = cg_read_long(test_group, "memory.zswap.current");
+
+	/* zswpin */
+	for (int i = 0; i < memsize; i += pagesize) {
+		memval = 1;
+		for (int j = i; j < i + pagesize/2; j++) {
+			if (mem[j] != memval++) {
+				ksft_print_msg("invalid memory\n");
+				goto out;
+			}
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
+	ret = cg_write(test_group, "memory.reclaim", "4M");
+	if (!wb_enabled) {
+		if (ret == -EAGAIN)
+			ret = 0;
+		else
+			ret = -1;
+	}
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
+		ksft_print_msg("failed to get zswpwb_before\n");
+		goto out;
+	}
+
+	if (cg_run(test_group, attempt_writeback, (void *) test_group))
+		goto out;
+
+	/* Verify that zswap writeback occurred only if writeback was enabled */
+	zswpwb_after = get_cg_wb_count(test_group);
+	if (wb && zswpwb_after <= zswpwb_before) {
+		ksft_print_msg("zswpwb_after <= zswpwb_before\n");
+		goto out;
+	} else if (!wb && zswpwb_after) {
+		ksft_print_msg("zswpwb_after != zswpwb_before\n");
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
@@ -423,6 +557,8 @@ struct zswap_test {
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

