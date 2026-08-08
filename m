Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B0737D124
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 06:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786170584; cv=none; b=lHIzB5pX4yxLu3M3BRbTTGPCHaZu0J21QYdC2CPsf/6/yxODJ/EpaQdzeGYVfd++yBe6DT4S+FddQSCJh0EoOcl0DDJ0Xd4TNvFogIQhMnbZM2jD6yfk2o88xzYr91FnzX1xSBizVztd59DHOmUC3bqm3XiP3lYXHnU/O0EmCQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786170584; c=relaxed/simple;
	bh=0lOg/+2wk1R8tJD/azIzUSHMLuQTTRFstDpmrZ/48HY=;
	h=Date:To:From:Subject:Message-Id; b=UA612Widivlx6iM6VXR/EbIXOrWmfhkdq8u0eNKtu5kVBjY5zGfmZQPvoiFc4QlpsFiFMpdUfQyuccD5Zl4Q3lxlLNSPpwNK3onbJLiKC1ng/Np9DcLrfzePdFLxA3uU/jWqF0noqjCOHe1IX+7LB2UuGS7nt/5qd0TlTxVBX3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dZrjdBEa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dZrjdBEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56291F000E9;
	Sat,  8 Aug 2026 06:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786170581;
	bh=VtchjeKIMKlkv4bEIMJ+SJ0F40c8aYertimb9ykqMs0=;
	h=Date:To:From:Subject;
	b=dZrjdBEaAltjn89LOw2Oi7QzXoZcG2fjQDcRyp4sIVm4zbTdDReqw277OIrmscQzq
	 XdUZYC9ilXzw1IILhiZIZ43dJ5iXVAMfejeHz3hEKO4Z2veHd+EYgcr9Ys54XqYXXN
	 /5S2vI7t5+xDLaeaFLk9e9qt6IMBke4UOOzMlG7U=
Date: Fri, 07 Aug 2026 23:29:41 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,anshuman.khandual@arm.com,akpm@linux-foundation.org,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch removed from -mm tree
Message-Id: <20260808062941.C56291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: test_zswap: skip test_no_kmem_bypass if debugfs is unavailable
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch

This patch was dropped because an updated version will be issued

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
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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

