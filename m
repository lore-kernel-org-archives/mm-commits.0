Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E88823BB
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1X0mDovQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48354C433C8;
	Mon, 11 Dec 2023 00:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256049;
	bh=0YVjxOlrWYiVRgHVrvFdhm5WGAlm/YwqbJWuPE6R1Ig=;
	h=Date:To:From:Subject:From;
	b=1X0mDovQCJArW/1UHHsXCS4miHb2MF5mwkRvEZ5zHwVdnC1rZ0pbVI9b+oBB2faG7
	 G5h4rKmlcaGZWSdr2emqUBRSSWRc2m3Ko+OClCdZE8PmaGnkYenUrb8IyCA68Hhd/7
	 7yUnCIa/IDA2+zIc1qJQuKDC6c30ewrw/xbGNqWA=
Date: Sun, 10 Dec 2023 16:54:08 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,mirq-linux@rere.qmqm.pl,colin.i.king@gmail.com,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch removed from -mm tree
Message-Id: <20231211005409.48354C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: check that PAGEMAP_SCAN returns correct categories
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrei Vagin <avagin@google.com>
Subject: selftests/mm: check that PAGEMAP_SCAN returns correct categories
Date: Mon, 6 Nov 2023 14:09:59 -0800

Right now, tests read page flags from /proc/pid/pagemap files.  With this
change, tests will check that PAGEMAP_SCAN return correct information too.

[colin.i.king@gmail.com: fix spelling mistake "succedded" -> "succeeded"]
  Link: https://lkml.kernel.org/r/20231121093104.1728332-1-colin.i.king@gmail.com
Link: https://lkml.kernel.org/r/20231106220959.296568-2-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
[avagin@google.com: allow running tests on old kernels]
  Link: https://lkml.kernel.org/r/20231117181127.2574897-1-avagin@google.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   80 ++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-check-that-pagemap_scan-returns-correct-categories
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -4,6 +4,7 @@
 #include <dirent.h>
 #include <sys/ioctl.h>
 #include <linux/userfaultfd.h>
+#include <linux/fs.h>
 #include <sys/syscall.h>
 #include <unistd.h>
 #include "../kselftest.h"
@@ -28,19 +29,92 @@ uint64_t pagemap_get_entry(int fd, char
 	return entry;
 }
 
+static uint64_t __pagemap_scan_get_categories(int fd, char *start, struct page_region *r)
+{
+	struct pm_scan_arg arg;
+
+	arg.start = (uintptr_t)start;
+	arg.end = (uintptr_t)(start + psize());
+	arg.vec = (uintptr_t)r;
+	arg.vec_len = 1;
+	arg.flags = 0;
+	arg.size = sizeof(struct pm_scan_arg);
+	arg.max_pages = 0;
+	arg.category_inverted = 0;
+	arg.category_mask = 0;
+	arg.category_anyof_mask = PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN | PAGE_IS_FILE |
+				  PAGE_IS_PRESENT | PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |
+				  PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY;
+	arg.return_mask = arg.category_anyof_mask;
+
+	return ioctl(fd, PAGEMAP_SCAN, &arg);
+}
+
+static uint64_t pagemap_scan_get_categories(int fd, char *start)
+{
+	struct page_region r;
+	long ret;
+
+	ret = __pagemap_scan_get_categories(fd, start, &r);
+	if (ret < 0)
+		ksft_exit_fail_msg("PAGEMAP_SCAN failed: %s\n", strerror(errno));
+	if (ret == 0)
+		return 0;
+	return r.categories;
+}
+
+/* `start` is any valid address. */
+static bool pagemap_scan_supported(int fd, char *start)
+{
+	static int supported = -1;
+	int ret;
+
+	if (supported != -1)
+		return supported;
+
+	/* Provide an invalid address in order to trigger EFAULT. */
+	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
+	if (ret == 0)
+		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
+
+	supported = errno == EFAULT;
+
+	return supported;
+}
+
+static bool page_entry_is(int fd, char *start, char *desc,
+			  uint64_t pagemap_flags, uint64_t pagescan_flags)
+{
+	bool m = pagemap_get_entry(fd, start) & pagemap_flags;
+
+	if (pagemap_scan_supported(fd, start)) {
+		bool s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
+
+		if (m == s)
+			return m;
+
+		ksft_exit_fail_msg(
+			"read and ioctl return unmatched results for %s: %d %d", desc, m, s);
+	}
+	return m;
+}
+
 bool pagemap_is_softdirty(int fd, char *start)
 {
-	return pagemap_get_entry(fd, start) & PM_SOFT_DIRTY;
+	return page_entry_is(fd, start, "soft-dirty",
+				PM_SOFT_DIRTY, PAGE_IS_SOFT_DIRTY);
 }
 
 bool pagemap_is_swapped(int fd, char *start)
 {
-	return pagemap_get_entry(fd, start) & PM_SWAP;
+	return page_entry_is(fd, start, "swap", PM_SWAP, PAGE_IS_SWAPPED);
 }
 
 bool pagemap_is_populated(int fd, char *start)
 {
-	return pagemap_get_entry(fd, start) & (PM_PRESENT | PM_SWAP);
+	return page_entry_is(fd, start, "populated",
+				PM_PRESENT | PM_SWAP,
+				PAGE_IS_PRESENT | PAGE_IS_SWAPPED);
 }
 
 unsigned long pagemap_get_pfn(int fd, char *start)
_

Patches currently in -mm which might be from avagin@google.com are


