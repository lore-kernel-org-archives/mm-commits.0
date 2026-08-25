Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A393793BD
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622924; cv=none; b=kLWSoVBUtOiYWog/GyVAkUI8oV/cFQinVtjOXbH79HqtIaQy6osHWBkdMx2gXCKmyUfx+jtKt8Nf9cJPR3qTajfP3seHopTpdaJm3IZl+YrER/3TUuIA/JO0ikWPUMCerGUao/5DCuKP3JiToRYaPjzxVbeOfj2wlcNqAnCrmiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622924; c=relaxed/simple;
	bh=7SD0MbPdyAkmneqCq+KtVuuxs7KKpji5h8cadrwwlLc=;
	h=Date:To:From:Subject:Message-Id; b=jA1UqhDm18JHkJzP++AkQNGF+lzu6xOk6N8cEhJjIfShdI2uEWCZbhExKhJbhXkxfI7H7YjvVGTL2zdnf96a7EAHyQD0QxyM3rK8/t3VQXfwBix4XzIr9yLNLgNr8rVylhgYvs6yPQc4rHM5hE7CoTQU1049F5/DfxYG0zUG8EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hkJZZ1hP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hkJZZ1hP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4D41F00A3E;
	Tue, 25 Aug 2026 01:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622921;
	bh=xLwEkcLDz2dokqJePhmszM5E1sbb8mazQiD+eVr7dGU=;
	h=Date:To:From:Subject;
	b=hkJZZ1hPBCIgfwGjiQ+d0QywQQ5UmF/k5/Qv25ixcmzbqbNC40Bdk1pnKEkSiClY/
	 QZ1EIwILbfst/O4WAbDeTYtx46I1bf0fHFX61D6kNz9JxHk+X3jfZCdq1plfG2q73a
	 DuHJ4mQ+vKJ0MpmETUTKi5b6kLm0O7/NEd5FhDt4=
Date: Mon, 24 Aug 2026 18:55:20 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,sj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,anshuman.khandual@arm.com,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch removed from -mm tree
Message-Id: <20260825015521.2A4D41F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: test_zswap: skip test_no_kmem_bypass if debugfs is unavailable
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wilson Felipe Pereira <wfelipe@google.com>
Subject: selftests/cgroup: test_zswap: skip test_no_kmem_bypass if debugfs is unavailable
Date: Tue, 11 Aug 2026 05:14:11 +0000

test_no_kmem_bypass() needs to read /sys/kernel/debug/zswap/stored_pages
via get_zswap_stored_pages() to verify that compressed pages are charged
to the memcg.

When running in an environment where debugfs is not mounted or
CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
loop to terminate early and report a false negative (KSFT_FAIL).

Selftests should not fail if debugfs is unavailable, and it should print a
message when it is skipped.

While I'm here, also add a warning message if the test is being skipped
due to totalram size and make the check for totalram more readable.

[akpm@linux-foundation.org: clarify debugfs-unavailable error message]
Link: https://lore.kernel.org/20260812050848.848882-1-wfelipe@google.com
Link: https://lore.kernel.org/20260811051434.3805648-1-wfelipe@google.com
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/lib/include/cgroup_util.h |    1 
 tools/testing/selftests/cgroup/test_zswap.c              |   13 ++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable
+++ a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -7,6 +7,7 @@
 #endif
 
 #define MB(x) (x << 20)
+#define GB(x) ((unsigned long long)(x) << 30)
 
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000L
--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -20,6 +20,7 @@ static int page_size;
 
 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+#define PATH_ZSWAP_STORED_PAGES "/sys/kernel/debug/zswap/stored_pages"
 
 static int read_int(const char *path, size_t *value)
 {
@@ -55,7 +56,7 @@ static int read_min_free_kb(size_t *valu
 
 static int get_zswap_stored_pages(size_t *value)
 {
-	return read_int("/sys/kernel/debug/zswap/stored_pages", value);
+	return read_int(PATH_ZSWAP_STORED_PAGES, value);
 }
 
 static long get_cg_wb_count(const char *cg)
@@ -570,8 +571,16 @@ static int test_no_kmem_bypass(const cha
 	/* Read sys info and compute test values accordingly */
 	if (sysinfo(&sys_info) != 0)
 		return KSFT_FAIL;
-	if (sys_info.totalram > 5000000000)
+	if (sys_info.totalram > GB(4)) {
+		ksft_print_msg(
+			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
+			(double)sys_info.totalram / GB(1));
 		return KSFT_SKIP;
+	}
+	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
+		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");
+		return KSFT_SKIP;
+	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
 			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	if (values == MAP_FAILED)
_

Patches currently in -mm which might be from wfelipe@google.com are


