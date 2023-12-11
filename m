Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D144CECC
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gSqXpYSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D58C433C8;
	Mon, 11 Dec 2023 00:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702255334;
	bh=hfUkBg3t0nWzKyZktOKfWZa/4x2J0o4h2X5xXBGSqOo=;
	h=Date:To:From:Subject:From;
	b=gSqXpYSYGJhNfb0HTddwZeHmK2aQg1D3V3qu/aPvsZ2COAEX7tkfr1ToacDLYaVLt
	 4H/2CyMT3RjPFL3FGpcRNgA3mZ/ZGIozFgEf8g8fnRSa2zpmjXvI7nr7MmeIi/eT8I
	 +nuOjD0zkg4LuE5ZAKzsMOACOgQPl1t9hBW474m0=
Date: Sun, 10 Dec 2023 16:42:14 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix.patch removed from -mm tree
Message-Id: <20231211004214.D4D58C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: don't fail if pagemap_scan isn't supported
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix.patch

This patch was dropped because it was folded into selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch

------------------------------------------------------
From: Andrei Vagin <avagin@google.com>
Subject: selftests/mm: don't fail if pagemap_scan isn't supported
Date: Fri, 17 Nov 2023 10:11:27 -0800

This change allows to run tests on old kernels.

Link: https://lkml.kernel.org/r/20231117181127.2574897-1-avagin@google.com
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/lkml/696a0a99-eb42-4e13-be14-58a88c9c33f7@arm.com/
Signed-off-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   51 +++++++++++++++++++------
 1 file changed, 39 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -29,15 +29,13 @@ uint64_t pagemap_get_entry(int fd, char
 	return entry;
 }
 
-static uint64_t pagemap_scan_get_categories(int fd, char *start)
+static uint64_t __pagemap_scan_get_categories(int fd, char *start, struct page_region *r)
 {
 	struct pm_scan_arg arg;
-	struct page_region r;
-	long ret;
 
 	arg.start = (uintptr_t)start;
 	arg.end = (uintptr_t)(start + psize());
-	arg.vec = (uintptr_t)&r;
+	arg.vec = (uintptr_t)r;
 	arg.vec_len = 1;
 	arg.flags = 0;
 	arg.size = sizeof(struct pm_scan_arg);
@@ -49,7 +47,15 @@ static uint64_t pagemap_scan_get_categor
 				  PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY;
 	arg.return_mask = arg.category_anyof_mask;
 
-	ret = ioctl(fd, PAGEMAP_SCAN, &arg);
+	return ioctl(fd, PAGEMAP_SCAN, &arg);
+}
+
+static uint64_t pagemap_scan_get_categories(int fd, char *start)
+{
+	struct page_region r;
+	long ret;
+
+	ret = __pagemap_scan_get_categories(fd, start, &r);
 	if (ret < 0)
 		ksft_exit_fail_msg("PAGEMAP_SCAN failed: %s\n", strerror(errno));
 	if (ret == 0)
@@ -57,18 +63,39 @@ static uint64_t pagemap_scan_get_categor
 	return r.categories;
 }
 
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
+		ksft_exit_fail_msg("PAGEMAP_SCAN succedded unexpectedly\n");
+
+	supported = errno == EFAULT;
+
+	return supported;
+}
+
 static bool page_entry_is(int fd, char *start, char *desc,
 			  uint64_t pagemap_flags, uint64_t pagescan_flags)
 {
-	bool m, s;
+	bool m = pagemap_get_entry(fd, start) & pagemap_flags;
+
+	if (pagemap_scan_supported(fd, start)) {
+		bool s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
 
-	m = pagemap_get_entry(fd, start) & pagemap_flags;
-	s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
-	if (m == s)
-		return m;
+		if (m == s)
+			return m;
 
-	ksft_exit_fail_msg(
-		"read and ioctl return unmatched results for %s: %d %d", desc, m, s);
+		ksft_exit_fail_msg(
+			"read and ioctl return unmatched results for %s: %d %d", desc, m, s);
+	}
 	return m;
 }
 
_

Patches currently in -mm which might be from avagin@google.com are

fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch
selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch

