Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E612E217F26
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188456; cv=none; b=TEFEXSB0g4SjizHuIAojyqgASfGwqxXfRmbscyGhjMaBx/uk2H04aj2ReWN2AlX/LYppt9gjwOejrlUwbBUJ5KHhGeW4jhkeiobblM6UIcK+d/AIv/ITqmzUub9uELp3IW9XZpCsX3ZIY3ao6hpSggMCu1PIC5cTzq0wpM6qUCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188456; c=relaxed/simple;
	bh=e2maYnndZSpv4xUG1sH/HEeNYuxMCoRLmwZ/8BrXxgU=;
	h=Date:To:From:Subject:Message-Id; b=Wyyf9ZlqrO3H3KggCzXnZ5k07Z4efwJ2ICvmF8CjC/w5pGEULxXcTIrPOGrHIVFASZTwTsH6irb4bQAbtImKjMoiOAX7y0Q1hNhlvsXumxAzsWUJV0GesGfN55DEF3E9ueHyDNysSq0seBfTk6Rm8t7UCV+g/SZP77Bsqc4yCHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SZfLs/rU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SZfLs/rU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8587C4CEEC;
	Mon, 17 Mar 2025 05:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188455;
	bh=e2maYnndZSpv4xUG1sH/HEeNYuxMCoRLmwZ/8BrXxgU=;
	h=Date:To:From:Subject:From;
	b=SZfLs/rU1EVSG0dQre0c15srHENiWybyg78NUC6l0KErWR4JWtLb1gZR3bF9Y1euO
	 2ex1P1kZOv8+RE/aUkfyxlxoRTa0oDe/zD8Me1T1BW1V0QUdL5FGASNss5RFwKTWy7
	 2HaVCoxtirBuerPZkhoJuyx1sC3rlIY/g3F7Y2uI=
Date: Sun, 16 Mar 2025 22:14:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,paulmck@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,corbet@lwn.net,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch removed from -mm tree
Message-Id: <20250317051415.B8587C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/selftests: add guard region test for /proc/$pid/pagemap
has been removed from the -mm tree.  Its filename was
     tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[lorenzo.stoakes@oracle.com: fixup define name]
  Link: https://lkml.kernel.org/r/32e83941-e6f5-42ee-9292-a44c16463cf1@lucifer.local
Link: https://lkml.kernel.org/r/164feb0a43ae72650e6b20c3910213f469566311.1740139449.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
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
+		unsigned long masked = entry & PM_GUARD_REGION;
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
+		unsigned long masked = entry & PM_GUARD_REGION;
+
+		ASSERT_EQ(masked, i % 2 == 0 ? PM_GUARD_REGION : 0);
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
+#define PM_GUARD_REGION               BIT_ULL(58)
 #define PM_FILE                       BIT_ULL(61)
 #define PM_SWAP                       BIT_ULL(62)
 #define PM_PRESENT                    BIT_ULL(63)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

