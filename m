Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15443DDCD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468160; cv=none; b=ZzPN0hbHsRoq2Xz/ZGIyQuI5W9WrW/sU5YVkro2kJHfm6W+i1LWJCE9LAGG+mkHFMK/ZMf5SSt6lRcdE3/Kr3pna35NLdpJSNSvA0Kh6hcHpWqcWIQvJTBnMkZ4MrWEdBXkUtopMQaebFlRt1HtMX9hpGYBjBSpsT5l7cpOnLls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468160; c=relaxed/simple;
	bh=DGPc5HMVIBwZEaoaHGwyZ3YyYfBiEpszYt2ToK00Tpw=;
	h=Date:To:From:Subject:Message-Id; b=R2pDRuTV4SlQ7j4TeR14mZWIq7T0kF8gtc7Cz/LmOy0s/yxFnETd4+kC58ne33PO0ScEE9kn9JId1t3vXlju/WWGm2RBBTakPArWYTakwxl28zhjcjBfcbSv3fahqPnZPi9QyiCRBgrBudiFYHfMZ8Lc6WSyMTyX/uLwgxoB4Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LVLvwf4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LVLvwf4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978FBC4CED6;
	Fri, 10 Jan 2025 00:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468159;
	bh=DGPc5HMVIBwZEaoaHGwyZ3YyYfBiEpszYt2ToK00Tpw=;
	h=Date:To:From:Subject:From;
	b=LVLvwf4WWj8Q+monah5st1vgk5fMuDX6Y5EKe6RyNo+rtdCW5oIv9mQFFfkijXBgg
	 CAmoDjl601lN5+zIvYmUbaMmtuGi9xkYrf1YAbB1CbBfLWcT5S5z2n7b+NgzkuCGq/
	 yxrAAJZkL4Wo1t3SlixNgk4AZwTSu7PAdDBTyAs4=
Date: Thu, 09 Jan 2025 16:15:59 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb-read-hwpoison-fix-type-mismatch-warnings.patch added to mm-unstable branch
Message-Id: <20250110001559.978FBC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb-read-hwpoison: fix type mismatch warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-hugetlb-read-hwpoison-fix-type-mismatch-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb-read-hwpoison-fix-type-mismatch-warnings.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: hugetlb-read-hwpoison: fix type mismatch warnings
Date: Thu, 9 Jan 2025 22:38:37 +0500

Fix type mismatch warnings.

Link: https://lkml.kernel.org/r/20250109173842.1142376-12-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-read-hwpoison.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c~selftests-mm-hugetlb-read-hwpoison-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -72,7 +72,7 @@ static bool seek_read_hugepage_filemap(i
 {
 	char buf[MAX_WRITE_READ_CHUNK_SIZE];
 	ssize_t ret_count = 0;
-	ssize_t total_ret_count = 0;
+	size_t total_ret_count = 0;
 	char val = offset / wr_chunk_size + offset % wr_chunk_size;
 
 	printf(PREFIX PREFIX "init val=%u with offset=0x%lx\n", val, offset);
@@ -83,7 +83,7 @@ static bool seek_read_hugepage_filemap(i
 		return false;
 	}
 
-	while (offset + total_ret_count < len) {
+	while ((unsigned long)offset + total_ret_count < len) {
 		ret_count = read(fd, buf, wr_chunk_size);
 		if (ret_count == 0) {
 			printf(PREFIX PREFIX "read reach end of the file\n");
@@ -109,7 +109,7 @@ static bool read_hugepage_filemap(int fd
 {
 	char buf[MAX_WRITE_READ_CHUNK_SIZE];
 	ssize_t ret_count = 0;
-	ssize_t total_ret_count = 0;
+	size_t total_ret_count = 0;
 	char val = 0;
 
 	printf(PREFIX PREFIX "expect to read 0x%lx bytes of data in total\n",
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-thp_settings-remove-const-from-return-type.patch
selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch
selftests-mm-mseal_test-remove-unused-variables.patch
selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch
selftests-mm-remove-argc-and-argv-unused-parameters.patch
selftests-mm-fix-unused-parameter-warnings.patch
selftests-mm-fix-type-mismatch-warnings.patch
selftests-mm-kselftest_harness-fix-warnings.patch
selftests-mm-cow-remove-unused-variables-and-fix-type-mismatch-errors.patch
selftests-mm-hmm-tests-remove-always-false-expressions.patch
selftests-mm-guard-pages-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-madvise-fix-type-mismatch-issues.patch
selftests-mm-hugepage-vmemmap-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-read-hwpoison-fix-type-mismatch-warnings.patch
selftests-mm-khugepaged-fix-type-mismatch-warnings.patch
selftests-mm-protection_keys-fix-variables-types-mismatch-warnings.patch
selftests-mm-thuge-gen-fix-type-mismatch-warnings.patch
selftests-mm-uffd-fix-all-type-mismatch-warnings.patch
selftests-mm-makefile-add-the-compiler-flags.patch

