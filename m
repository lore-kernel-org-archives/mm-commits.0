Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A8C1D63E4
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343093; cv=none; b=AOcgtsdrykl4a7D7Dz/3EbP8cOLz1vo/eNt+F6jsxsUPnXZHCVLw3knD/NS8ntbIqrJXAEpFlLCFS52t5xZ2ZPzaayhgFeAevJJp3fWoCgJvkUIpzL9HpeHyl0urdHhGQlG70pKzl69iGWABgq9j7p0IN9/ni9wrGkCnfou2XF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343093; c=relaxed/simple;
	bh=OSo9ehLfXTsJ6gMbsr+cKzDx4EL4CP1Bn6sty2yHSI4=;
	h=Date:To:From:Subject:Message-Id; b=DomjUG31HrHJY34PtBPhkkXKTc82Oqkdixe63+ZQl7cUqMcnwnxL6R7iYR72oJgCDVb52+smd9YsXK2CB9YWH6H8/+dJHg1dd/Ek94TDLk2HJqAf5ddV//cOTyj+ZvievFokL+9Kjogaop/3t7hHOGhbLb9EH6c4g1DCoHid7WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPLzTdxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPLzTdxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40188C4CEF5;
	Mon, 17 Nov 2025 01:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343093;
	bh=OSo9ehLfXTsJ6gMbsr+cKzDx4EL4CP1Bn6sty2yHSI4=;
	h=Date:To:From:Subject:From;
	b=xPLzTdxsN285hw5QxLxi8vjmIFWbl7MmTtvO0EWcQI62bZroSh9SdmIFtgHtciOo7
	 x4r2kvOhuwWPBw4nfP02RhApFejm/D14FNiHdQndOKuMa4/OyUXCB8K//v7EfsFqSk
	 ykTBPrv8XcuP+UPgSXwUNLY5wKceJb/eak4FfIXY=
Date: Sun, 16 Nov 2025 17:31:32 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,tujinjiang@huawei.com,shr@devkernel.io,david@redhat.com,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-update-ksm-inheritation-tests-for-prctl-fork-exec.patch removed from -mm tree
Message-Id: <20251117013133.40188C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: update ksm inheritance tests for prctl fork/exec
has been removed from the -mm tree.  Its filename was
     selftests-update-ksm-inheritation-tests-for-prctl-fork-exec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: selftests: update ksm inheritance tests for prctl fork/exec
Date: Tue, 7 Oct 2025 18:29:35 +0800 (CST)

To reproduce the issue mentioned by [1], this add a setting of
pages_to_scan and sleep_millisecs at the start of test_prctl_fork_exec(). 
The main change is just raise the scanning frequency of ksmd.

[1] https://lore.kernel.org/all/202510012256278259zrhgATlLA2C510DMD3qI@zte.com.cn/

Link: https://lkml.kernel.org/r/20251007182935207jm31wCIgLpZg5XbXQY64S@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   57 ++++++++++++
 1 file changed, 57 insertions(+)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-update-ksm-inheritation-tests-for-prctl-fork-exec
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -38,6 +38,8 @@ enum ksm_merge_mode {
 };
 
 static int mem_fd;
+static int pages_to_scan_fd;
+static int sleep_millisecs_fd;
 static int pagemap_fd;
 static size_t pagesize;
 
@@ -493,6 +495,46 @@ static void test_prctl_fork(void)
 	ksft_test_result_pass("PR_SET_MEMORY_MERGE value is inherited\n");
 }
 
+static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
+{
+	int ksm_fd;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	if (write(ksm_fd, "1", 1) != 1)
+		return -errno;
+
+	if (write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan)) <= 0)
+		return -errno;
+
+	if (write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms)) <= 0)
+		return -errno;
+
+	return 0;
+}
+
+static int stop_ksmd_and_restore_frequency(void)
+{
+	int ksm_fd;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	if (write(ksm_fd, "2", 1) != 1)
+		return -errno;
+
+	if (write(pages_to_scan_fd, "100", 3) <= 0)
+		return -errno;
+
+	if (write(sleep_millisecs_fd, "20", 2) <= 0)
+		return -errno;
+
+	return 0;
+}
+
 static void test_prctl_fork_exec(void)
 {
 	int ret, status;
@@ -500,6 +542,9 @@ static void test_prctl_fork_exec(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
+	if (start_ksmd_and_set_frequency("2000", "0"))
+		ksft_test_result_fail("set ksmd's scanning frequency failed\n");
+
 	ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
 	if (ret < 0 && errno == EINVAL) {
 		ksft_test_result_skip("PR_SET_MEMORY_MERGE not supported\n");
@@ -542,6 +587,11 @@ static void test_prctl_fork_exec(void)
 		return;
 	}
 
+	if (stop_ksmd_and_restore_frequency()) {
+		ksft_test_result_fail("restore ksmd frequency failed\n");
+		return;
+	}
+
 	ksft_test_result_pass("PR_SET_MEMORY_MERGE value is inherited\n");
 }
 
@@ -656,6 +706,13 @@ static void init_global_file_handles(voi
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
 	if (ksm_get_self_merging_pages() < 0)
 		ksft_exit_skip("accessing \"/proc/self/ksm_merging_pages\") failed\n");
+
+	pages_to_scan_fd = open("/sys/kernel/mm/ksm/pages_to_scan", O_RDWR);
+	if (pages_to_scan_fd < 0)
+		ksft_exit_fail_msg("opening /sys/kernel/mm/ksm/pages_to_scan failed\n");
+	sleep_millisecs_fd = open("/sys/kernel/mm/ksm/sleep_millisecs", O_RDWR);
+	if (sleep_millisecs_fd < 0)
+		ksft_exit_fail_msg("opening /sys/kernel/mm/ksm/sleep_millisecs failed\n");
 }
 
 int main(int argc, char **argv)
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


