Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262D33C9EFE
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 12:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777035110; cv=none; b=Kz8WLfGBceZuXxhErOmZgc6xUmud9Jkn2nvuHcEm1nXwQdIdeF7oR1/2GZrT4CzP6jEanxayPQ72UsqKP7NjdS3kQHQCEZer2VwOGkX7fbI7RXuwIBIkb69wZDNBiO8X74Xf4+McE/hule0xpXBEFr42vAkycYL4ZsbjG62bbXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777035110; c=relaxed/simple;
	bh=9N71qHPDCsVCeFKD+sbhjFjZSU1co5QYDVV9VSIOvlY=;
	h=Date:To:From:Subject:Message-Id; b=KI1vXUeint5pDEA/Isqp73RxKleJdj3m2jKpZW2CUE9RgXFUlRmZsoBqmox6JIYHYh+vghoxfPkQs41J922Ob+6/QkV6+1FqdDyKm0cY2uyod/nRPNXYcyS0wTY3LbqLH9agyU9M8v2wiadDVAw1zbX703ycKVe3Bw1yp9e5MVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bs1+3Xld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bs1+3Xld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3063C19425;
	Fri, 24 Apr 2026 12:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777035109;
	bh=9N71qHPDCsVCeFKD+sbhjFjZSU1co5QYDVV9VSIOvlY=;
	h=Date:To:From:Subject:From;
	b=Bs1+3XldjBalJKWlCsk3TcBKgQkIkv67fEPeNLxvzYlIQDj/nJFZlZkgTqc+8hJhf
	 7UIlDQa8UCvrygd16ycC7T4aDPWa7fJOV8teHBOH2VFkA6VUqpsnpX29X5Z+0G0TmE
	 Uu3l+TyYn77JsIrJ397enkksamGljG4R30MaEMFw=
Date: Fri, 24 Apr 2026 05:51:49 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch added to mm-new branch
Message-Id: <20260424125149.C3063C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: regression test for panic_on_unrecoverable_memory_failure
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch

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

kho-fix-error-handling-in-kho_add_subtree.patch
mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

