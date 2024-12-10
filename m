Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA80233129
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796468; cv=none; b=kUGMDDw3XUlgm8ec1ICQvXocA4E0Bj0rzF/QRvvPpuMKf7JGEO2N+48y9RfPybaV1ryh6QKrMhsq2Z66GKQG3WRs236e6zsRjZhd2tUfGiLxbdEXUdFGQGa6vx49rJkcnDFLArLQg4Am7O27cJRjd6x7tVjZcRhpxoPteqiNzhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796468; c=relaxed/simple;
	bh=9+HgbKYAwFPjgaBEJNONVuRdchuwm+5fHC+9fkvC+TE=;
	h=Date:To:From:Subject:Message-Id; b=qycMGoUUMjY8eIrQVTSHCtvy26G3fwBnd65/sK5zGSic+98XHFIJ20L2aSG5jhUXRhu7TA/SGw4cQDbNYVQWvayW+IBQQ/Sgy4E0O47Npjv4Xnvk5ytC9GmhkSUqs8Q1DObm/xY2tNYpiwlzTTNu7JC+z08c6p7GD4WgipxXrZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fiQjlVL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fiQjlVL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BBEC4CED1;
	Tue, 10 Dec 2024 02:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796468;
	bh=9+HgbKYAwFPjgaBEJNONVuRdchuwm+5fHC+9fkvC+TE=;
	h=Date:To:From:Subject:From;
	b=fiQjlVL65Hz+OoIw1afyZ6aem0690/e5bDjBYcEmy6ozhkdkh6MTAsG4swq947Lt1
	 riJVTfH5WDVx2w9w4j1jpgxk3SOLVvrtSRKv+VuiVI7kH9K3xWUjBq+O4lgkJZ+uni
	 QeJ43RzAjhbzEXA8URcCKub00xlwm7VoRII+nUak=
Date: Mon, 09 Dec 2024 18:07:47 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-wmaybe-uninitialized-warnings.patch added to mm-unstable branch
Message-Id: <20241210020747.E9BBEC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix -Wmaybe-uninitialized warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-wmaybe-uninitialized-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-wmaybe-uninitialized-warnings.patch

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

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-build-with-o2.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch

