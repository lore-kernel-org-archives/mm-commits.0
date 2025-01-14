Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728C723C710
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837040; cv=none; b=irtKbLabdiWNOirewwX36JAWvBAvOYNwxSls5jbUQBBRzbU7hk8SOi1iKGjdRzcxVUiSBaGTnxYCRrrRlCfExND/bBc5pf9rdp5fQXT26cgbK9c1MY5iH+AZnhJOQXtBDv+yBmXDZuV6bSVVOt6ThTRHetXhg3ZiNaq8u1LLX7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837040; c=relaxed/simple;
	bh=7Lz+LKku9kwpAwCTmEyu2mi88MSl1L74G3M219yItYI=;
	h=Date:To:From:Subject:Message-Id; b=hcG1ci3c+PEbMfDq1ZhMGjHlCUguDx1Nnr8+2UK/8SCVOVb6DKWcra7ptUPlQYSAzNDlBrJBcBExVzm4ZsBYBcZnInFfhN6SUAT5Pngm5DTKCUf4C6G/BW/UAxSKTxTgd6+5TRxs3EwF2Bhi7KgaxWaRBeOMTKYpNT4bPkpRg+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cbCmiBjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cbCmiBjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46426C4CEDD;
	Tue, 14 Jan 2025 06:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837040;
	bh=7Lz+LKku9kwpAwCTmEyu2mi88MSl1L74G3M219yItYI=;
	h=Date:To:From:Subject:From;
	b=cbCmiBjoxYZS5D2MR9jnLIbNinGBq/riL0OsyIcYqJAWaZvs3BHYYS2F0duveKz0J
	 0oVGPTlne1kvKUDRPce6M443VaqvziVmid4OkOpwLInyGahS1zNAoGZAP6VQmeuFQC
	 g+XJ0hcz5diIByzj/dFnaLv+rRQwIXs1ymZLyels=
Date: Mon, 13 Jan 2025 22:43:59 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-wmaybe-uninitialized-warnings.patch removed from -mm tree
Message-Id: <20250114064400.46426C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix -Wmaybe-uninitialized warnings
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-wmaybe-uninitialized-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: fix -Wmaybe-uninitialized warnings
Date: Mon, 9 Dec 2024 09:50:07 +0000

A few -Wmaybe-uninitialized warnings show up when building the mm tests
with -O2.  None of them looks worrying; silence them by initialising the
problematic variables.

Link: https://lkml.kernel.org/r/20241209095019.1732120-3-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c       |    2 +-
 tools/testing/selftests/mm/mremap_test.c     |    2 +-
 tools/testing/selftests/mm/soft-dirty.c      |    2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-fix-wmaybe-uninitialized-warnings
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -776,7 +776,7 @@ err_out:
 
 int main(int argc, char *argv[])
 {
-	int ret, opt;
+	int ret = 0, opt;
 	int prot = 0;
 	int ksm_scan_limit_sec = KSM_SCAN_LIMIT_SEC_DEFAULT;
 	int merge_type = KSM_MERGE_TYPE_DEFAULT;
--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-fix-wmaybe-uninitialized-warnings
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -384,7 +384,7 @@ out:
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
 {
-	void *addr, *src_addr, *dest_addr, *dest_preamble_addr;
+	void *addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
 	unsigned long long t, d;
 	struct timespec t_start = {0, 0}, t_end = {0, 0};
 	long long  start_ns, end_ns, align_mask, ret, offset;
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-fix-wmaybe-uninitialized-warnings
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -128,7 +128,7 @@ static void test_mprotect(int pagemap_fd
 {
 	const char *type[] = {"file", "anon"};
 	const char *fname = "./soft-dirty-test-file";
-	int test_fd;
+	int test_fd = 0;
 	char *map;
 
 	if (anon) {
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-wmaybe-uninitialized-warnings
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1122,7 +1122,7 @@ uffd_move_test_common(uffd_test_args_t *
 	char c;
 	unsigned long long count;
 	struct uffd_args args = { 0 };
-	char *orig_area_src, *orig_area_dst;
+	char *orig_area_src = NULL, *orig_area_dst = NULL;
 	unsigned long step_size, step_count;
 	unsigned long src_offs = 0;
 	unsigned long dst_offs = 0;
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


