Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81E1D515
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468167; cv=none; b=PJLTW4KvZPQ7Sio9cDVu8qqCOops2FS2RjZzpD0Z2jsVTaA+CFqOzBL2qG3r/ZKk6+Waeo1YLAO7pg5dTKxASAmhVWD5njJZ1dcW+Q/F/fuBssqgap5Zr9tV47KlMO2fFr/kCpjT6WonYGeCwAz5eRJQYQpWEIvmM4YPWzQcIho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468167; c=relaxed/simple;
	bh=7Ov5nbYfH22fX/sy9J4zox7fG+OSKHMyCXcn8Qv5FQ4=;
	h=Date:To:From:Subject:Message-Id; b=TzAdrYN/VA7ryFyescsAgrv0Ij9dpXGIglHcFvv4JwXKKJT/LNqbpSG6Ht6dpdqpYEJ+J0gqf+rgAhw8LmZmBosHuoEXc5tZPcJsaSC00XEZ71dqh4qQ52UXMZHNfzlqMDQfSLHLT6hOU0hPRYYgHhJofr66jAAmrnHyLi7wf/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ALPFh51R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ALPFh51R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1E5C4CED2;
	Fri, 10 Jan 2025 00:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468167;
	bh=7Ov5nbYfH22fX/sy9J4zox7fG+OSKHMyCXcn8Qv5FQ4=;
	h=Date:To:From:Subject:From;
	b=ALPFh51RQVXyW6EI5qrW8MBwa39F4DucVE1382zHsdKulYFdBgLMCKg/13pP/X/01
	 4sIVNstC5Wi/XDflN4LXGk8GYYNSLUuY/oAYCq8yHZEpTweXkuJPAehxUcfw4/RMU5
	 R+t71x6Moin4rtcq8kG1Y5N8okM5hiCg5cp8M3/U=
Date: Thu, 09 Jan 2025 16:16:06 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-fix-all-type-mismatch-warnings.patch added to mm-unstable branch
Message-Id: <20250110001607.4E1E5C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: uffd-*: fix all type mismatch warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-uffd-fix-all-type-mismatch-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-fix-all-type-mismatch-warnings.patch

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
Subject: selftests/mm: uffd-*: fix all type mismatch warnings
Date: Thu, 9 Jan 2025 22:38:41 +0500

Fix all type mismatch warnings in all uffd-* files.

Link: https://lkml.kernel.org/r/20250109173842.1142376-16-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |    6 +++---
 tools/testing/selftests/mm/uffd-stress.c     |    2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-uffd-fix-all-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -450,7 +450,7 @@ void uffd_handle_page_fault(struct uffd_
 		args->wp_faults++;
 	} else if (msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_MINOR) {
 		uint8_t *area;
-		int b;
+		unsigned int b;
 
 		/*
 		 * Minor page faults
@@ -621,7 +621,7 @@ int __copy_page(int ufd, unsigned long o
 			err("UFFDIO_COPY error: %"PRId64,
 			    (int64_t)uffdio_copy.copy);
 		wake_range(ufd, uffdio_copy.dst, page_size);
-	} else if (uffdio_copy.copy != page_size) {
+	} else if (uffdio_copy.copy != (signed long)page_size) {
 		err("UFFDIO_COPY error: %"PRId64, (int64_t)uffdio_copy.copy);
 	} else {
 		if (test_uffdio_copy_eexist && retry) {
@@ -655,7 +655,7 @@ int move_page(int ufd, unsigned long off
 			err("UFFDIO_MOVE error: %"PRId64,
 			    (int64_t)uffdio_move.move);
 		wake_range(ufd, uffdio_move.dst, len);
-	} else if (uffdio_move.move != len) {
+	} else if (uffdio_move.move != (signed long)len) {
 		err("UFFDIO_MOVE error: %"PRId64, (int64_t)uffdio_move.move);
 	} else
 		return 1;
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-uffd-fix-all-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -77,7 +77,7 @@ static void usage(void)
 
 static void uffd_stats_reset(struct uffd_args *args, unsigned long n_cpus)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < n_cpus; i++) {
 		args[i].cpu = i;
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-fix-all-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -917,7 +917,7 @@ static bool do_uffdio_zeropage(int ufd,
 		else if (res != -EINVAL)
 			err("UFFDIO_ZEROPAGE not -EINVAL");
 	} else if (has_zeropage) {
-		if (res != page_size)
+		if (res != (signed long)page_size)
 			err("UFFDIO_ZEROPAGE unexpected size");
 		else
 			retry_uffdio_zeropage(ufd, &uffdio_zeropage);
@@ -949,7 +949,7 @@ uffd_register_detect_zeropage(int uffd,
 static void uffd_zeropage_test(uffd_test_args_t __attribute__((unused)) *args)
 {
 	bool has_zeropage;
-	int i;
+	unsigned int i;
 
 	has_zeropage = uffd_register_detect_zeropage(uffd, area_dst, page_size);
 	if (area_dst_alias)
@@ -997,7 +997,7 @@ static void do_uffdio_poison(int uffd, u
 
 	if (ret)
 		err("UFFDIO_POISON error: %"PRId64, (int64_t)res);
-	else if (res != page_size)
+	else if (res != (signed long)page_size)
 		err("UFFDIO_POISON unexpected size: %"PRId64, (int64_t)res);
 }
 
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

