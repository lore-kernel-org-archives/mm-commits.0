Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D002346782
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 16:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305611; cv=none; b=O6aYh6CdwLCHMNBfch+aHt2I9qtCVOjx2rui8tl7e1cJ0uIA5K4l0voaheFvDCeWNDvZe6GXsqa8dWUvbbZrvatvdbrzThrwLJRUgJEmdJp7Xv3TfmYqqaYZOp7DQSH8n5DdV72I+cgNiNxDXfgPnJ5LZKCvHs5wLRGLkcAG7tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305611; c=relaxed/simple;
	bh=n9DUMpgwbD1S3YtsJrZBwOeYPRCLTXIaY13Jz3XIHkU=;
	h=Date:To:From:Subject:Message-Id; b=gorDDb8z9LQoLty3O9V31nxZqhtU40eHMbVoLzUKOsuKVc3JaqSR4WHGw7BrK7LUEqGrv9JJ8kujgr/7w3R87Y5UnHw48vH7Suqye4uPEklkl7F4eDACpXY5QPkYy5E5YhY9b1NyvBHsuBbXzl83/8/wl+pkrdBpMZk/j1ZMx/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNyhg1Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNyhg1Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BDFC19425;
	Mon, 27 Apr 2026 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777305611;
	bh=n9DUMpgwbD1S3YtsJrZBwOeYPRCLTXIaY13Jz3XIHkU=;
	h=Date:To:From:Subject:From;
	b=eNyhg1Zhgo77+fsBB3r1crtQYAwIGyUNFInqjGP6Jx9yHWKsM7kpL+Rg5EgeTG9gE
	 T6ES+99GVY2YiZHwcA6moBTX03XdGi76gZeVMbJy0S9u18Bl7p2QbvI1tfE7u9PELj
	 yORFS5BDAWpmrhRl1vAdz5ydkng8JdSH4HBmLl2E=
Date: Mon, 27 Apr 2026 09:00:10 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch removed from -mm tree
Message-Id: <20260427160011.12BDFC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: regression test for panic_on_unrecoverable_memory_failure
has been removed from the -mm tree.  Its filename was
     selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: regression test for panic_on_unrecoverable_memory_failure
Date: Fri, 24 Apr 2026 05:24:02 -0700

Add a test that enables vm.panic_on_unrecoverable_memory_failure and
injects MADV_HWPOISON on a userspace anonymous page.  The page must still
be recovered via SIGBUS — it must not trigger a kernel panic.

This is the regression test for the panic_on_unrecoverable_mf() recheck: a
buddy page being concurrently allocated to userspace can briefly land on
the MF_MSG_KERNEL_HIGH_ORDER branch (refcount 0, not in buddy), and
without the recheck the kernel would panic on what is actually a
recoverable userspace page.

Run in a forked child so the SIGBUS path is fully exercised; if the kernel
ever regresses and panics, the host VM dies and the harness reports the
binary as never returning, which is itself a clear failure signal.

Skips when the sysctl is not present (feature not built in) or when the
test cannot write to it (insufficient privilege).  Saves and restores the
original sysctl value.

Link: https://lore.kernel.org/20260424-ecc_panic-v5-4-a35f4b50425c@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memory-failure.c |   84 ++++++++++++++++++
 1 file changed, 84 insertions(+)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -17,9 +17,13 @@
 #include <sys/vfs.h>
 #include <linux/magic.h>
 #include <errno.h>
+#include <sys/wait.h>
+#include <stdlib.h>
 
 #include "vm_util.h"
 
+#define PANIC_SYSCTL "/proc/sys/vm/panic_on_unrecoverable_memory_failure"
+
 enum inject_type {
 	MADV_HARD,
 	MADV_SOFT,
@@ -355,4 +359,84 @@ TEST_F(memory_failure, dirty_pagecache)
 	ASSERT_EQ(close(fd), 0);
 }
 
+static int read_sysctl_int(const char *path, int *out)
+{
+	char buf[16];
+	int fd, n;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n <= 0)
+		return -1;
+	buf[n] = '\0';
+	*out = atoi(buf);
+	return 0;
+}
+
+static int write_sysctl_int(const char *path, int val)
+{
+	char buf[16];
+	int fd, len, ret = 0;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+	len = snprintf(buf, sizeof(buf), "%d\n", val);
+	if (write(fd, buf, len) != len)
+		ret = -1;
+	close(fd);
+	return ret;
+}
+
+/*
+ * Regression test for vm.panic_on_unrecoverable_memory_failure.
+ *
+ * With the sysctl on, hwpoison injection on a userspace anonymous page
+ * must still be recovered via SIGBUS — it must not trigger a kernel
+ * panic. This guards the panic_on_unrecoverable_mf() recheck that rules
+ * out concurrent buddy allocations being misclassified as unrecoverable
+ * kernel pages (MF_MSG_KERNEL_HIGH_ORDER).
+ *
+ * If the kernel regresses and panics, the host VM dies and the test
+ * harness will report the binary as never having returned — which is
+ * itself a clear failure signal.
+ */
+TEST(panic_on_unrecoverable_user_page)
+{
+	unsigned long page_size;
+	int saved, status;
+	void *addr;
+	pid_t pid;
+
+	if (read_sysctl_int(PANIC_SYSCTL, &saved))
+		SKIP(return, "%s not available\n", PANIC_SYSCTL);
+	if (write_sysctl_int(PANIC_SYSCTL, 1))
+		SKIP(return, "cannot enable %s (need root?)\n", PANIC_SYSCTL);
+
+	page_size = sysconf(_SC_PAGESIZE);
+
+	pid = fork();
+	ASSERT_NE(pid, -1);
+	if (pid == 0) {
+		addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+		if (addr == MAP_FAILED)
+			_exit(1);
+		*(volatile char *)addr = 1;
+		if (madvise(addr, page_size, MADV_HWPOISON))
+			_exit(2);
+		FORCE_READ(*(volatile char *)addr);
+		_exit(0); /* unreachable: SIGBUS expected */
+	}
+
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	write_sysctl_int(PANIC_SYSCTL, saved);
+
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_EQ(WTERMSIG(status), SIGBUS);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from leitao@debian.org are

mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch
mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

