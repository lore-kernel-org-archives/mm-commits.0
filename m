Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD0618A953
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011054; cv=none; b=qFBIiG5OAbhl4KJ8s+9x/qKkrWqkVJ0jNjzlrZU0B3bJHS3df7i/749+gyrIk0/+gY0jvTj/bsX+b550+mpRZRggNEl6YYEF+3V6W5bi+mAttgXoq94KBWWWY7GCr9JhwXSR6YKaKHMGq+TJioHlraEZpfae0Sl75Ixw0ELUNjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011054; c=relaxed/simple;
	bh=rKtg5TFeul09saBIwiW6NpsH1pPn3ZvDfa9IA0r13jY=;
	h=Date:To:From:Subject:Message-Id; b=abrLPCcgo5eufMRSq11ajc6+AeAHSRvq3Km/hgwfa4j0Ten0qdjK7A0iJl7A5vahwFE1lwz6+L/ncIlxOx/MKhD37Z1GCihS105R5YwFHW8nX2JVI0xa09u/repbIokqMjdtBWgmfxOpgx44Nn6fAHrG6lwQOkEdtIMbiKc6MFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E6APzFeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E6APzFeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EFDC4CEE4;
	Mon, 12 May 2025 00:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011054;
	bh=rKtg5TFeul09saBIwiW6NpsH1pPn3ZvDfa9IA0r13jY=;
	h=Date:To:From:Subject:From;
	b=E6APzFeOm+luocNqTraBX5VOnEwaHPTSjKJILRPJ5b8f28ctCSlr9ihScvKS6yeFI
	 PUye5h98zSp1iAfR4/xcmbu66+vuhqR1BDCHvkVKc6o4S6iUzeBoNv2nwnAT3S0WJN
	 t0FFw0vZY+CihJhtePtsk7rg9l3YGy0XL5vljVeE=
Date: Sun, 11 May 2025 17:50:53 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,corbet@lwn.net,avagin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-pagemap_scan-guard-region-test.patch removed from -mm tree
Message-Id: <20250512005054.21EFDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add PAGEMAP_SCAN guard region test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-pagemap_scan-guard-region-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2072,6 +2073,62 @@ TEST_F(guard_regions, pagemap)
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


