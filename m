Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EF02E7393
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 01:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788397466; cv=none; b=kZaEAVQTpOt8FsANYqY/To00a6aDnrNawfXU+M0cngev7emNom+tWhuP+JiV5dBBlhRMwf0hThSv61qVggGF65M0qZfpeJG9IGz+ZNGnDydKdXIrJPRsHBiu0kmmVsqS01L+oujfmGsi+GAiPZRzXEcFendYbT25wSsxdgDO21I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788397466; c=relaxed/simple;
	bh=CiTIlPceUBTFlXNQiTyaWZ4SKdgjIOC24Zo4fYKHncQ=;
	h=Date:To:From:Subject:Message-Id; b=eXKWgxwTmleMGCk7OgVDB3LFFvBysREcbbtTBwdu6eDFzzwqtNI3dtcfF1AoD31Vs1gFmb5/M3bQ0LYhbaxQ8qfeR6sE5x8qBMCFkOV/waIrqY/epwSizHCTTdVMg27WPpkANEAv8isEyNEP5H09E4onIOh6tkdPeGc7PC+yoS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oerjQwL7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oerjQwL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1214F1F00A3D;
	Thu,  3 Sep 2026 01:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788397465;
	bh=5jrG4V8sKa/QO8YhjikyGOcK14WPXQqxBGupvCHqvyk=;
	h=Date:To:From:Subject;
	b=oerjQwL76CQ+T7KYcNa3BQQ4JTLk1YleNzvYKnbafmiCiD1XndGoEMkIANqoTf0Mv
	 lPrSabKvIehN84Ru0o5VJBV1ubVvlttlssU4TmAmwhjIT4fOzSs0C9MvMKg6t1bNPY
	 Ey+OuEI10A5TEQnXK83UxOs8P2f8EI8V1fVm3TiY=
Date: Wed, 02 Sep 2026 18:04:24 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,krushchavan@outlook.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-account-for-zswap-shrinker-writeback.patch added to mm-new branch
Message-Id: <20260903010425.1214F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: account for zswap shrinker writeback
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-account-for-zswap-shrinker-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-account-for-zswap-shrinker-writeback.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: selftests/cgroup: account for zswap shrinker writeback
Date: Wed, 2 Sep 2026 12:45:20 -0700

The test_no_invasive_cgroup_shrink selftest checks that when a cgroup has
zswapped out more memory than memory.zswap.max, it does not trigger
writeback for other cgroups.  To do this, it compares the writeback count
in a control cgroup and makes sure that it is 0, and then checks the
writeback count in an aggressor cgroup who does expect to see writeback.

However, when the zswap shrinker is enabled, the victim cgroup can see
legitimate writebacks not triggered by the aggressor.  In some Meta CI
tests, we have seen this failure mode happen.

Instead of checking that the victim cgroup has 0 writeback, compare the
writeback values before and after the aggressor runs and check that the
victim cgroup did not perform any additional writeback.  Note that this
can still lead to probabilistic failures if writebacks take longer than 5
seconds, but this should fix the systematic failure case.

Link: https://lore.kernel.org/20260902194521.3652178-1-joshua.hahnjy@gmail.com
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reported-by: Krush Chavan <krushchavan@outlook.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   28 ++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-account-for-zswap-shrinker-writeback
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -20,6 +20,7 @@ static int page_size;
 
 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+#define PATH_ZSWAP_SHRINKER_ENABLED "/sys/module/zswap/parameters/shrinker_enabled"
 #define PATH_ZSWAP_STORED_PAGES "/sys/kernel/debug/zswap/stored_pages"
 
 static int read_int(const char *path, size_t *value)
@@ -446,6 +447,16 @@ static int test_zswap_writeback_disabled
 	return test_zswap_writeback(root, false);
 }
 
+static bool zswap_shrinker_enabled(void)
+{
+	char value[2];
+
+	if (read_text(PATH_ZSWAP_SHRINKER_ENABLED, value, sizeof(value)) <= 0)
+		return 0;
+
+	return value[0] == 'Y';
+}
+
 /*
  * When trying to store a memcg page in zswap, if the memcg hits its memory
  * limit in zswap, writeback should affect only the zswapped pages of that
@@ -455,6 +466,7 @@ static int test_no_invasive_cgroup_shrin
 {
 	int ret = KSFT_FAIL;
 	unsigned int off;
+	long zswpwb_before, zswpwb_after, zswpwb_target;
 	size_t allocation_size = page_size * 1024;
 	unsigned int nr_pages = allocation_size / page_size;
 	char zswap_max_buf[32], mem_max_buf[32];
@@ -490,6 +502,14 @@ static int test_no_invasive_cgroup_shrin
 	if (cg_read_key_long(zw_group, "memory.stat", "zswapped") < 1)
 		goto out;
 
+	/* If the shrinker is enabled, try to let the writebacks finish first */
+	if (zswap_shrinker_enabled())
+		sleep(5);
+
+	zswpwb_before = get_cg_wb_count(zw_group);
+	if (zswpwb_before < 0)
+		goto out;
+
 	/* Push wb_group memory into zswap with hard-to-compress data to trigger wb */
 	if (cg_enter_current(wb_group))
 		goto out;
@@ -502,9 +522,13 @@ static int test_no_invasive_cgroup_shrin
 		getrandom(&wb_allocation[off], page_size/4, 0);
 	}
 
-	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (wait_for_writeback(wb_group, 5000) > 0 && get_cg_wb_count(zw_group) == 0)
+	/* Verify that only zswapped memory from wb_group has been written back */
+	zswpwb_target = wait_for_writeback(wb_group, 5000);
+	zswpwb_after = get_cg_wb_count(zw_group);
+
+	if (zswpwb_target > 0 && zswpwb_before == zswpwb_after)
 		ret = KSFT_PASS;
+
 out:
 	cg_enter_current(root);
 	if (zw_group) {
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

selftests-cgroup-account-for-zswap-shrinker-writeback.patch

