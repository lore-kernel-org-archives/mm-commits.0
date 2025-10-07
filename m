Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B143246BB7
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759874007; cv=none; b=qFjpaGQ+1zEx2sR/Pg6NTSzXfcu87UFCOa3b/SnXYIbS8Aow5qvjJMbwSZ/JmYfcENNNXyX937H5KZ2ovWWaeLO4dzAoswybcKAmzIhbtUMb7e8PYPUk3SatOPjulFf9jHR2CYdIkVQoymTNdO8kF3u1gcN7U49UcsLCb+dj1eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759874007; c=relaxed/simple;
	bh=L9+R4dbsrClTMfnBs6NlvPkTElf55Np+VItfwqCnb8Q=;
	h=Date:To:From:Subject:Message-Id; b=Ag/PPtabiTpudykfR7OTInWTaHake23uEvqev2wzg7mZkSDmgU19dFadq/AiUjYKOkUKZBkA7yZskXNHESdwMPshcsW7+sOJWM35AjaCWYuzSrkh106QcETnAHX9LkeJl5+7ur/03evWbuPHp5U1Nk45JixlW/L3NL0BDRJG0eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0gqfiMLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0gqfiMLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02A9C4CEF1;
	Tue,  7 Oct 2025 21:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759874007;
	bh=L9+R4dbsrClTMfnBs6NlvPkTElf55Np+VItfwqCnb8Q=;
	h=Date:To:From:Subject:From;
	b=0gqfiMLksbH1oB0s1e6B46HxslxDVtDTSFQjszRT7QCSi9id0ee4sGXZN7wblmh6M
	 KS/4D7w2ANybwASaYPIQm8MwmsJoUOziNGwzBX1QV/ZT98IF4HDaJyowlMVQd1JGT6
	 oAUDE9T+iQjBGP9HT+5G2IX4zBFZ1kznGFAX1ahE=
Date: Tue, 07 Oct 2025 14:53:26 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,tujinjiang@huawei.com,shr@devkernel.io,david@redhat.com,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-update-ksm-inheritation-tests-for-prctl-fork-exec.patch added to mm-new branch
Message-Id: <20251007215326.F02A9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: update ksm inheritance tests for prctl fork/exec
has been added to the -mm mm-new branch.  Its filename is
     selftests-update-ksm-inheritation-tests-for-prctl-fork-exec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-update-ksm-inheritation-tests-for-prctl-fork-exec.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-ksm-fix-exec-fork-inheritance-support-for-prctl.patch
selftests-update-ksm-inheritation-tests-for-prctl-fork-exec.patch

