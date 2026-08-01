Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C8E221F2F
	for <mm-commits@vger.kernel.org>; Sat,  1 Aug 2026 19:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785611928; cv=none; b=OBXzIbF3rqhUHL+e4PtuaiFoFbaUCuoTWIzxEZlLe2+PhExKQ/pcC77T324LxEci8Ucdi0M44GCAeKlp3OorpDpJuUw79Tpep5u9tBM74Qix+g8PYWCbRXmGLBW6ctSg2Vyn3yeabTZDLuCnE4iODWpHkjeZq6inY8mLz8Z6TUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785611928; c=relaxed/simple;
	bh=osJ86ID7SNbVF8zD3YAzrrIok9gIbaFuGHz6mAnxj+Y=;
	h=Date:To:From:Subject:Message-Id; b=hm/QGlAuA0TJqYdjVo7y4p7xnY8LVVIkasxSe5AIliIGlVdl+pqOIJIZOmORref3JPOzfDEMxjwx63cywz+S8gNUfdjHLkrIqNqWGiZ7lDM8TWwuFh49k3Sq3LF0XPZvc7DnM/NcpRqfYmJ25vutgEwwCklnCb0tUIxv+FnBiX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XPBo9hGX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XPBo9hGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B2D1F00AC4;
	Sat,  1 Aug 2026 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785611926;
	bh=Nlf6slinawNUt570kq2eVkAzS8E7uUMy8y/mWKsxMxU=;
	h=Date:To:From:Subject;
	b=XPBo9hGXvw92+NkrL39y7NvH5Ws4ySH/bpCDPwYYnXRW6RM8C3u9m4sCg0RTEgJcI
	 1XwGfpP+9FTf0PL3gnGRfP0RC88tmW8BbRGykE7EQ+xToiRqwq2F3MwM3ZbTa+P0MA
	 e/fSYyMcrOqwrLr0fFlOnEEEhVhtSKKZsPF9ttqQ=
Date: Sat, 01 Aug 2026 12:18:46 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch added to mm-new branch
Message-Id: <20260801191846.C8B2D1F00AC4@smtp.kernel.org>
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
Date: Sat, 1 Aug 2026 04:12:46 +0000

test_no_kmem_bypass() needs to read /sys/kernel/debug/zswap/stored_pages
via get_zswap_stored_pages() to verify that compressed pages are charged
to the memcg.

When running in an environment where debugfs is not mounted or
CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
loop to terminate early and report a false negative (KSFT_FAIL).

Selftests should not fail when if debugfs is unavailable, and it should
print a message when it is skipped.

Link: https://lore.kernel.org/20260801041255.752039-1-wfelipe@google.com
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -566,12 +566,19 @@ static int test_no_kmem_bypass(const cha
 	int child_status;
 	char *test_group = NULL;
 	pid_t child_pid;
+	size_t stored_pages;
 
 	/* Read sys info and compute test values accordingly */
 	if (sysinfo(&sys_info) != 0)
 		return KSFT_FAIL;
-	if (sys_info.totalram > 5000000000)
+	if (sys_info.totalram > 5000000000) {
+		ksft_print_msg("requires less than 5000000000 total ram\n");
 		return KSFT_SKIP;
+	}
+	if (get_zswap_stored_pages(&stored_pages)) {
+		ksft_print_msg("debugfs at /sys/kernel/debug is required\n");
+		return KSFT_SKIP;
+	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
 			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	if (values == MAP_FAILED)
@@ -604,7 +611,6 @@ static int test_no_kmem_bypass(const cha
 	/* Try to wakeup kswapd and let it push child memory to zswap */
 	set_min_free_kb(min_free_kb_high);
 	for (int i = 0; i < 20; i++) {
-		size_t stored_pages;
 		char *trigger_allocation = malloc(trigger_allocation_size);
 
 		if (!trigger_allocation)
_

Patches currently in -mm which might be from wfelipe@google.com are

mm-zswap-drop-list_lru-param-from-zswap_lru_add-and-_del.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch

