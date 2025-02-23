Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E752AE8C
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 03:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740280385; cv=none; b=n1qDqGly0CstUq2KhZW7UxnAu+RXk4a/UmeuczqXYzjUaBW3/lMSYdBXWpBh/Wlii/X14CWXJIRlCQrjAnM9FMYeTkFj4wTUX25r0dQUJ/SkE9kqsDnwS/1APbXv8kIQSJAlGvC9/sq7P6Xgte16D8CbOYc4E4WOoH5qVAhgIW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740280385; c=relaxed/simple;
	bh=KZSouKn6PUWui/m5V0AaTCSHezdnNeYtTAnVJuwfQE0=;
	h=Date:To:From:Subject:Message-Id; b=hammsWwOckAkyZVqDAR+0RD7CJsqnBMd6Xxi3qR3cbG385Xx7J82dN/YY9Ea3PlEYrLqZaiV5rMzXBUW9zG5hFHpzvH3bcN/wuaLStzngbR6EiH/gUNHr0kyIVr57zGEAUUF+QCPi/85kCHoRU2mJBxFj0j8+qoSelvz59C2aGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FrXJeUXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FrXJeUXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C82C4CEEC;
	Sun, 23 Feb 2025 03:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740280385;
	bh=KZSouKn6PUWui/m5V0AaTCSHezdnNeYtTAnVJuwfQE0=;
	h=Date:To:From:Subject:From;
	b=FrXJeUXC8O7OPQBZjXUoZ8sq1XJdAplTRWiAoysweYlR8gjowOsZ0LpE4RL3CnuPU
	 3JDddPk9+rK0Zw7VrLfaV0897lrDUnpyJEM87V7uALc8WUChQsGrE+6+921tJ4uc8i
	 GGDzDy8/A65gXvWc74QuU/JorpnPpnLPam8vH+Kk=
Date: Sat, 22 Feb 2025 19:13:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,paulmck@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,corbet@lwn.net,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch added to mm-unstable branch
Message-Id: <20250223031305.29C82C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/selftests: add guard region test for /proc/$pid/pagemap
has been added to the -mm mm-unstable branch.  Its filename is
     tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/selftests: add guard region test for /proc/$pid/pagemap
Date: Fri, 21 Feb 2025 12:05:23 +0000

Add a test to the guard region self tests to assert that the
/proc/$pid/pagemap information now made availabile to the user correctly
identifies and reports guard regions.

As a part of this change, update vm_util.h to add the new bit (note there
is no header file in the kernel where this is exposed, the user is
expected to provide their own mask) and utilise the helper functions there
for pagemap functionality.

Link: https://lkml.kernel.org/r/164feb0a43ae72650e6b20c3910213f469566311.1740139449.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   47 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h       |    1 
 2 files changed, 48 insertions(+)

--- a/tools/testing/selftests/mm/guard-regions.c~tools-selftests-add-guard-region-test-for-proc-pid-pagemap
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -19,6 +19,7 @@
 #include <sys/syscall.h>
 #include <sys/uio.h>
 #include <unistd.h>
+#include "vm_util.h"
 
 /*
  * Ignore the checkpatch warning, as per the C99 standard, section 7.14.1.1:
@@ -2032,4 +2033,50 @@ TEST_F(guard_regions, anon_zeropage)
 	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
 }
 
+/*
+ * Assert that /proc/$pid/pagemap correctly identifies guard region ranges.
+ */
+TEST_F(guard_regions, pagemap)
+{
+	const unsigned long page_size = self->page_size;
+	int proc_fd;
+	char *ptr;
+	int i;
+
+	proc_fd = open("/proc/self/pagemap", O_RDONLY);
+	ASSERT_NE(proc_fd, -1);
+
+	ptr = mmap_(self, variant, NULL, 10 * page_size,
+		    PROT_READ | PROT_WRITE, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/* Read from pagemap, and assert no guard regions are detected. */
+	for (i = 0; i < 10; i++) {
+		char *ptr_p = &ptr[i * page_size];
+		unsigned long entry = pagemap_get_entry(proc_fd, ptr_p);
+		unsigned long masked = entry & PM_GUARD_REGION_MASK;
+
+		ASSERT_EQ(masked, 0);
+	}
+
+	/* Install a guard region in every other page. */
+	for (i = 0; i < 10; i += 2) {
+		char *ptr_p = &ptr[i * page_size];
+
+		ASSERT_EQ(madvise(ptr_p, page_size, MADV_GUARD_INSTALL), 0);
+	}
+
+	/* Re-read from pagemap, and assert guard regions are detected. */
+	for (i = 0; i < 10; i++) {
+		char *ptr_p = &ptr[i * page_size];
+		unsigned long entry = pagemap_get_entry(proc_fd, ptr_p);
+		unsigned long masked = entry & PM_GUARD_REGION_MASK;
+
+		ASSERT_EQ(masked, i % 2 == 0 ? PM_GUARD_REGION_MASK : 0);
+	}
+
+	ASSERT_EQ(close(proc_fd), 0);
+	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
+}
+
 TEST_HARNESS_MAIN
--- a/tools/testing/selftests/mm/vm_util.h~tools-selftests-add-guard-region-test-for-proc-pid-pagemap
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -10,6 +10,7 @@
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
 #define PM_MMAP_EXCLUSIVE             BIT_ULL(56)
 #define PM_UFFD_WP                    BIT_ULL(57)
+#define PM_GUARD_REGION_MASK          BIT_ULL(58)
 #define PM_FILE                       BIT_ULL(61)
 #define PM_SWAP                       BIT_ULL(62)
 #define PM_PRESENT                    BIT_ULL(63)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-abort-vma_modify-on-merge-out-of-memory-failure.patch
mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch
fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch

