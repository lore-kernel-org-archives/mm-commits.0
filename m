Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A20A932
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 03:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771557475; cv=none; b=EPX2wYrImjhUSN9fV5TUL0kNk2bJzo1CTvqDaIHLepQjactBxufmKEJOyQEMmANWIQDUUUXXB5UQv5V0t647NA4OYiGbcTu2NS46A+20mah8RBOlicrDFCGhYjQB7CGr5QwrpZLbgdv2/fmDxhXzBImpoZi6CJ80YOMqJvWLj18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771557475; c=relaxed/simple;
	bh=pfNrEsy0k8Jx93hmLyVOftVDMZDIbK/zsrlnSUW4q+o=;
	h=Date:To:From:Subject:Message-Id; b=qnWjlmnoLi2Txlgc7lD3QyUwSRuodJP81abHDDwV9VJJuB94+tJsFE4+c7SrXpxDCHXZx9EdPi2FH+jpI44Gtp89QgRTywrfFS9rKzchVOHrmX9uXcOhd/j253Wi7GV3ffHoI9jkqwTSPo8aE7VT4ueZJvIXsYpXWj2mGLOSdqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CPdTUv+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CPdTUv+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B67C4CEF7;
	Fri, 20 Feb 2026 03:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771557474;
	bh=pfNrEsy0k8Jx93hmLyVOftVDMZDIbK/zsrlnSUW4q+o=;
	h=Date:To:From:Subject:From;
	b=CPdTUv+o6o0dErMjltpUnnIi2AJzPMpk+mUraHtWIhtFlLBbHKF9yWQsidxivzdQz
	 o/6zZIVkurazg3PcTvulwOJVcI24CF/WdFQfa/xAsg+LGhAwajUDh3GWsABKYDbiiz
	 QeS0Kg0ajFJ7hRb6vpJTfMvWYpX4HUyJy2KnwUnc=
Date: Thu, 19 Feb 2026 19:17:54 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,tj@kernel.org,sj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,corbet@lwn.net,chengming.zhou@linux.dev,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-add-test-for-zswap-incompressible-pages.patch added to mm-new branch
Message-Id: <20260220031754.B7B67C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: add test for zswap incompressible pages
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-add-test-for-zswap-incompressible-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-add-test-for-zswap-incompressible-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: selftests/cgroup: add test for zswap incompressible pages
Date: Fri, 13 Feb 2026 15:18:23 +0800

Add test_zswap_incompressible() to verify that the zswap_incomp memcg stat
correctly tracks incompressible pages.

The test allocates memory filled with random data from /dev/urandom, which
cannot be effectively compressed by zswap.  When this data is swapped out
to zswap, it should be stored as-is and tracked by the zswap_incomp
counter.

The test verifies that:
1. Pages are swapped out to zswap (zswpout increases)
2. Incompressible pages are tracked (zswap_incomp increases)

test:
dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo Y > /sys/module/zswap/parameters/enabled

./test_zswap
 TAP version 13
 1..8
 ok 1 test_zswap_usage
 ok 2 test_swapin_nozswap
 ok 3 test_zswapin
 ok 4 test_zswap_writeback_enabled
 ok 5 test_zswap_writeback_disabled
 ok 6 test_no_kmem_bypass
 ok 7 test_no_invasive_cgroup_shrink
 ok 8 test_zswap_incompressible
 Totals: pass:8 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20260213071827.5688-3-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |  136 ++++++++++++++++++
 1 file changed, 136 insertions(+)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-add-test-for-zswap-incompressible-pages
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -5,6 +5,8 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <signal.h>
+#include <errno.h>
+#include <fcntl.h>
 #include <sys/sysinfo.h>
 #include <string.h>
 #include <sys/wait.h>
@@ -574,6 +576,139 @@ out:
 	return ret;
 }
 
+struct incomp_child_args {
+	size_t size;
+	int pipefd[2];
+	int madvise_ret;
+	int madvise_errno;
+};
+
+static int allocate_random_and_wait(const char *cgroup, void *arg)
+{
+	struct incomp_child_args *values = arg;
+	size_t size = values->size;
+	char *mem;
+	int fd;
+	ssize_t n;
+
+	close(values->pipefd[0]);
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		return -1;
+
+	/* Fill with random data from /dev/urandom - incompressible */
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0) {
+		munmap(mem, size);
+		return -1;
+	}
+
+	for (size_t i = 0; i < size; ) {
+		n = read(fd, mem + i, size - i);
+		if (n <= 0)
+			break;
+		i += n;
+	}
+	close(fd);
+
+	/* Touch all pages to ensure they're faulted in */
+	for (size_t i = 0; i < size; i += PAGE_SIZE)
+		mem[i] = mem[i];
+
+	/* Use MADV_PAGEOUT to push pages into zswap */
+	values->madvise_ret = madvise(mem, size, MADV_PAGEOUT);
+	values->madvise_errno = errno;
+
+	/* Notify parent that allocation and pageout are done */
+	write(values->pipefd[1], "x", 1);
+	close(values->pipefd[1]);
+
+	/* Keep memory alive for parent to check stats */
+	pause();
+	munmap(mem, size);
+	return 0;
+}
+
+static long get_zswap_incomp(const char *cgroup)
+{
+	return cg_read_key_long(cgroup, "memory.stat", "zswap_incomp ");
+}
+
+/*
+ * Test that incompressible pages (random data) are tracked by zswap_incomp.
+ *
+ * The child process allocates random data within memory.max, then uses
+ * MADV_PAGEOUT to push pages into zswap. The parent waits on a pipe for
+ * the child to finish, then checks the zswap_incomp stat before the child
+ * exits (zswap_incomp is a gauge that decreases on free).
+ */
+static int test_zswap_incompressible(const char *root)
+{
+	int ret = KSFT_FAIL;
+	struct incomp_child_args *values;
+	char *test_group;
+	long zswap_incomp;
+	pid_t child_pid;
+	int child_status;
+	char buf;
+
+	values = mmap(0, sizeof(struct incomp_child_args), PROT_READ |
+			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (values == MAP_FAILED)
+		return KSFT_FAIL;
+
+	if (pipe(values->pipefd)) {
+		munmap(values, sizeof(struct incomp_child_args));
+		return KSFT_FAIL;
+	}
+
+	test_group = cg_name(root, "zswap_incompressible_test");
+	if (!test_group)
+		goto out;
+	if (cg_create(test_group))
+		goto out;
+	if (cg_write(test_group, "memory.max", "32M"))
+		goto out;
+
+	values->size = MB(4);
+	child_pid = cg_run_nowait(test_group, allocate_random_and_wait, values);
+	if (child_pid < 0)
+		goto out;
+
+	close(values->pipefd[1]);
+
+	/* Wait for child to finish allocating and pageout */
+	read(values->pipefd[0], &buf, 1);
+	close(values->pipefd[0]);
+
+	zswap_incomp = get_zswap_incomp(test_group);
+	if (zswap_incomp <= 0) {
+		long zswpout = get_zswpout(test_group);
+		long zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
+		long zswap_b = cg_read_key_long(test_group, "memory.stat", "zswap ");
+
+		ksft_print_msg("zswap_incomp not increased: %ld\n", zswap_incomp);
+		ksft_print_msg("debug: zswpout=%ld zswapped=%ld zswap_b=%ld\n",
+			       zswpout, zswapped, zswap_b);
+		ksft_print_msg("debug: madvise ret=%d errno=%d\n",
+			       values->madvise_ret, values->madvise_errno);
+		goto out_kill;
+	}
+
+	ret = KSFT_PASS;
+
+out_kill:
+	kill(child_pid, SIGTERM);
+	waitpid(child_pid, &child_status, 0);
+out:
+	cg_destroy(test_group);
+	free(test_group);
+	munmap(values, sizeof(struct incomp_child_args));
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct zswap_test {
 	int (*fn)(const char *root);
@@ -586,6 +721,7 @@ struct zswap_test {
 	T(test_zswap_writeback_disabled),
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
+	T(test_zswap_incompressible),
 };
 #undef T
 
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-zswap-add-per-memcg-stat-for-incompressible-pages.patch
selftests-cgroup-add-test-for-zswap-incompressible-pages.patch

