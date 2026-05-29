Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D07A36AB49
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027589; cv=none; b=lPsFcf9RDyGPMUJ2I947W3QvO4yTGbtzlABobCYn+cwtDeQ0EzAkISsPPCSKpq/n0PwsIf+R60XSokPhnQoZou8w0VOoPGEvzOXjHnqv0Wuy77146dI0iFvRfnIOBjuJuTC2LcGd1mbS6wO0dEscmhbGt6XlWGT1uGlS7q8nQK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027589; c=relaxed/simple;
	bh=XGI9uVLhY6VaqfAQbmGzyY96cQt2Y4xjoqc3UXuhJBc=;
	h=Date:To:From:Subject:Message-Id; b=naZ7D5YVykPOoOrkexlgwPXW1bVGJexZAbJTRb0k1nrJbrDJ32Kb/tFy6eqYVo6EIlDSLatpnpu5RnMfD1kCyB9rkBh1r3uhU0AYlf88Dlid82fx6ghQXpgvXBDOcOG2dWF15b2WwYDZhJCjTKmtSsoZXVFCWVD4BS4JnqraWWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wND1hcY7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wND1hcY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100061F00893;
	Fri, 29 May 2026 04:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027588;
	bh=tNRv7eL31a4kr/sBwCZZVLEsLfN3Q3a8zT6BMjDKlrU=;
	h=Date:To:From:Subject;
	b=wND1hcY70LwjlqqEF5oSe9liApYK+qHHsNCnOyUXfgH+Px3ZEFOFMhDQGuOhpx7Ca
	 KYx9nfuPKZpLCM0kMCpRCGi1/LEo9xnfsX/jZI577hxYYTqn+J/RHNJRoAMYkPOv6f
	 UpxabUr5N+S4U0oy3AUoaytSgtXiT6ncKv8zMaJ0=
Date: Thu, 28 May 2026 21:06:27 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,chengming.zhou@linux.dev,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch removed from -mm tree
Message-Id: <20260529040628.100061F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: skip test_zswap if zswap is globally disabled
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: selftests/cgroup: skip test_zswap if zswap is globally disabled
Date: Fri, 24 Apr 2026 12:00:52 +0800

Patch series "selftests/cgroup: improve zswap tests robustness and support
large page sizes", v7.

This patchset aims to fix various spurious failures and improve the
overall robustness of the cgroup zswap selftests.

The primary motivation is to make the tests compatible with architectures
that use non-4K page sizes (such as 64K on ppc64le and arm64).  Currently,
the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
On 64K page size systems, these hardcoded values lead to sub-page
granularity accesses, incorrect page count calculations, and insufficient
memory pressure to trigger zswap writeback, ultimately causing the tests
to fail.

Additionally, this series addresses OOM kills occurring in
test_swapin_nozswap by dynamically scaling memory limits, and prevents
spurious test failures when zswap is built into the kernel but globally
disabled.


This patch (of 8):

test_zswap currently only checks whether zswap is present by testing
/sys/module/zswap.  This misses the runtime global state exposed in
/sys/module/zswap/parameters/enabled.

When zswap is built/loaded but globally disabled, the zswap cgroup
selftests run in an invalid environment and may fail spuriously.

Check the runtime enabled state before running the tests:
  - skip if zswap is not configured,
  - fail if the enabled knob cannot be read,
  - skip if zswap is globally disabled.

Also print a hint in the skip message on how to enable zswap.

Link: https://lore.kernel.org/20260424040059.12940-1-li.wang@linux.dev
Link: https://lore.kernel.org/20260424040059.12940-2-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   19 ++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -15,6 +15,9 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+#define PATH_ZSWAP "/sys/module/zswap"
+#define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+
 static int read_int(const char *path, size_t *value)
 {
 	FILE *file;
@@ -725,9 +728,18 @@ struct zswap_test {
 };
 #undef T
 
-static bool zswap_configured(void)
+static void check_zswap_enabled(void)
 {
-	return access("/sys/module/zswap", F_OK) == 0;
+	char value[2];
+
+	if (access(PATH_ZSWAP, F_OK))
+		ksft_exit_skip("zswap isn't configured\n");
+
+	if (read_text(PATH_ZSWAP_ENABLED, value, sizeof(value)) <= 0)
+		ksft_exit_fail_msg("Failed to read " PATH_ZSWAP_ENABLED "\n");
+
+	if (value[0] == 'N')
+		ksft_exit_skip("zswap is disabled (hint: echo 1 > " PATH_ZSWAP_ENABLED ")\n");
 }
 
 int main(int argc, char **argv)
@@ -740,8 +752,7 @@ int main(int argc, char **argv)
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
-	if (!zswap_configured())
-		ksft_exit_skip("zswap isn't configured\n");
+	check_zswap_enabled();
 
 	/*
 	 * Check that memory controller is available:
_

Patches currently in -mm which might be from li.wang@linux.dev are


