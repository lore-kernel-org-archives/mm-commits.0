Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBEF185B4C
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 05:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744002154; cv=none; b=I9jEaj8w+jg0/quD5N6Uz0g5GhR0fOHaJSuBkMJ/vlQz5eFlhZL/iT6eauXJmyMdyzaIDhcHqNJ4lMJyCmU9ZU98A1A+nUKYEEMekKnxdBh8YGta1yICFJnDT1b0z/zJGz4ef5NpXlno8xswjaKK8JSPQ7sz9Bfh9bApODJhnNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744002154; c=relaxed/simple;
	bh=IPBzVCyyVA+ZmWBhZ9DS6gG4ZgskapTsxXc8ABVzqgA=;
	h=Date:To:From:Subject:Message-Id; b=A3NdzNNTsBjOJkqOMyxn6QlfC242C8iFDC3FQFmFnMWVsLV8W1Xn8WPKZw+mf0fFz+MDd7a+OgzjD8ztD0fb57V9XvtBFAbZahosh/ED4bFEaIEaoXxfx8q6z6ghFbsX4+q9ifF0w7qztrbmR6bf6wkMSr6eg5eB84F25rt+0FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yb8d9idi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yb8d9idi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06505C4CEDD;
	Mon,  7 Apr 2025 05:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744002154;
	bh=IPBzVCyyVA+ZmWBhZ9DS6gG4ZgskapTsxXc8ABVzqgA=;
	h=Date:To:From:Subject:From;
	b=Yb8d9idiFrFFpblVk71MEoAOxAAPb/VCB1BRBQQUZl1knDsgzRFxlPgFCqlcNlFUk
	 j0FnxQkBoBmHNj+qqXTds1bfxlSvwx+Gd+NBZ3YaqRj+2Zp9njsvhAWJR6NP9GuYJA
	 z7SmPqwqAkeSpkI059dY37VfqmLrIK1l4PDcBgG4=
Date: Sun, 06 Apr 2025 22:02:33 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,corbet@lwn.net,avagin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-pagemap_scan-guard-region-test.patch added to mm-new branch
Message-Id: <20250407050234.06505C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add PAGEMAP_SCAN guard region test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-pagemap_scan-guard-region-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-pagemap_scan-guard-region-test.patch

This patch will later appear in the mm-new branch at
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
From: Andrei Vagin <avagin@gmail.com>
Subject: selftests/mm: add PAGEMAP_SCAN guard region test
Date: Mon, 24 Mar 2025 06:53:28 +0000

Add a selftest to verify the PAGEMAP_SCAN ioctl correctly reports guard
regions using the newly introduced PAGE_IS_GUARD flag.

Link: https://lkml.kernel.org/r/20250324065328.107678-4-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-add-pagemap_scan-guard-region-test
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -8,6 +8,7 @@
 #include <fcntl.h>
 #include <linux/limits.h>
 #include <linux/userfaultfd.h>
+#include <linux/fs.h>
 #include <setjmp.h>
 #include <signal.h>
 #include <stdbool.h>
@@ -2068,6 +2069,62 @@ TEST_F(guard_regions, pagemap)
 	}
 
 	ASSERT_EQ(close(proc_fd), 0);
+	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
+}
+
+/*
+ * Assert that PAGEMAP_SCAN correctly reports guard region ranges.
+ */
+TEST_F(guard_regions, pagemap_scan)
+{
+	const unsigned long page_size = self->page_size;
+	struct page_region pm_regs[10];
+	struct pm_scan_arg pm_scan_args = {
+		.size = sizeof(struct pm_scan_arg),
+		.category_anyof_mask = PAGE_IS_GUARD,
+		.return_mask = PAGE_IS_GUARD,
+		.vec = (long)&pm_regs,
+		.vec_len = ARRAY_SIZE(pm_regs),
+	};
+	int proc_fd, i;
+	char *ptr;
+
+	proc_fd = open("/proc/self/pagemap", O_RDONLY);
+	ASSERT_NE(proc_fd, -1);
+
+	ptr = mmap_(self, variant, NULL, 10 * page_size,
+		    PROT_READ | PROT_WRITE, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	pm_scan_args.start = (long)ptr;
+	pm_scan_args.end = (long)ptr + 10 * page_size;
+	ASSERT_EQ(ioctl(proc_fd, PAGEMAP_SCAN, &pm_scan_args), 0);
+	ASSERT_EQ(pm_scan_args.walk_end, (long)ptr + 10 * page_size);
+
+	/* Install a guard region in every other page. */
+	for (i = 0; i < 10; i += 2) {
+		char *ptr_p = &ptr[i * page_size];
+
+		ASSERT_EQ(syscall(__NR_madvise, ptr_p, page_size, MADV_GUARD_INSTALL), 0);
+	}
+
+	/*
+	 * Assert ioctl() returns the count of located regions, where each
+	 * region spans every other page within the range of 10 pages.
+	 */
+	ASSERT_EQ(ioctl(proc_fd, PAGEMAP_SCAN, &pm_scan_args), 5);
+	ASSERT_EQ(pm_scan_args.walk_end, (long)ptr + 10 * page_size);
+
+	/* Re-read from pagemap, and assert guard regions are detected. */
+	for (i = 0; i < 5; i++) {
+		long ptr_p = (long)&ptr[2 * i * page_size];
+
+		ASSERT_EQ(pm_regs[i].start, ptr_p);
+		ASSERT_EQ(pm_regs[i].end, ptr_p + page_size);
+		ASSERT_EQ(pm_regs[i].categories, PAGE_IS_GUARD);
+	}
+
+	ASSERT_EQ(close(proc_fd), 0);
 	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
 }
 
_

Patches currently in -mm which might be from avagin@gmail.com are

fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions.patch
tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources.patch
selftests-mm-add-pagemap_scan-guard-region-test.patch

