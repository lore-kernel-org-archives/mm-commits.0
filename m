Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A7C25B091
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 02:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786500411; cv=none; b=YNshaVhy0PFXU9ay7LMbqj47UbifwCC8IMX8/YRZoD9JkUI6WKOr4LpHz83EKPhHg/DQy4w/wW7NF/S11hJOyKLx5DZdsUvK3A8VTuI5yPNtWAh4thuKCd8+hOlGSACfXEsf1AC0uJulxvYkr6RGafnUwTLBgAzqIK22y6DApBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786500411; c=relaxed/simple;
	bh=Pg1HD/PKpblbK2NKQjyH5XDVAkK3vZMVHWcFi1dODFs=;
	h=Date:To:From:Subject:Message-Id; b=uEgTf8ydHV1i4kw/cVeHy+oCIjpeEsgzgz7Cq7uOiqNjY2sdf6AhDYXAmJ8f8tNdSKOxI1IMNOeWGN78PqZpynrHuSAkTbryrVX+mO/EiGacBOdvOtlEBDM+yeWq50N+uK7CWlcGIqPwD6/6IoZMdxegakazenE9igse/gpy9So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jhWys1Eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jhWys1Eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE051F000E9;
	Wed, 12 Aug 2026 02:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786500409;
	bh=ZxZSVyYYG6t5QYdJfxgKKiESzhl/F3tOoOxYzzR+KQk=;
	h=Date:To:From:Subject;
	b=jhWys1EoBsbTaWjEAJESOx8PZ6h7p+MmnLe28opgIG+rxOwQHJALGXGHpXx/e2czW
	 kpe2hA9OvLgMrwfzg2D73O10fVK6HL2XEuJ8RQkMsRQpiy+serHCYp+6aPP8/eSKnT
	 4VfxMc5v5SxhrJHWdSVrWaP5wzsk7l7Br2LVEcnY=
Date: Tue, 11 Aug 2026 19:06:48 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,anshuman.khandual@arm.com,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch added to mm-new branch
Message-Id: <20260812020649.4DE051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: test_zswap: skip test_no_kmem_bypass if debugfs is unavailable
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch

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

Link: https://lore.kernel.org/20260811051434.3805648-1-wfelipe@google.com
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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
+		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
+		return KSFT_SKIP;
+	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
 			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	if (values == MAP_FAILED)
_

Patches currently in -mm which might be from wfelipe@google.com are

mm-zswap-drop-list_lru-param-from-zswap_lru_add-and-_del.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch

