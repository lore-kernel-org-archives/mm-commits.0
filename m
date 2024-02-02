Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF281C123
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876008; cv=none; b=V1SjjBLUOwP7r11SwPPZpvz2IPYUKW67wWYx8zAWr5Jo/kgW7C+I/tzqQLpHFRZhWzVzwTymsX3IRD17fBtAXOXJT25fYEecM6lxXlZqYxmeFN3DzijqrfaJVZEfbQTQ7liC8s9GFlOkysKEMzWpyEUqZWTYDnBHFQ81FH2Nt1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876008; c=relaxed/simple;
	bh=ZtTH8qfHXI+pv1/+ZaAB9Evw0Py6/GmfJGJC9OmHl68=;
	h=Date:To:From:Subject:Message-Id; b=g2V+PcKN8cvCbmcCbV8nUa+0WCHEBhPxYtwQlRq3P/9nPzgLscpuPQQGLUD0iXDz1fLUWfKGoDhHgChAHo0EvqpH08tGhOLziW795E+3UCgkllSprliRhKx1ccDtcyJrhqvkYU4IOyKVNnBmJJfAIcQOua6BiTYe5FuLbYjUuYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KRHK3ue0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KRHK3ue0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355E0C433C7;
	Fri,  2 Feb 2024 12:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876008;
	bh=ZtTH8qfHXI+pv1/+ZaAB9Evw0Py6/GmfJGJC9OmHl68=;
	h=Date:To:From:Subject:From;
	b=KRHK3ue0VvvnKXW4+3gsVllwqWCTa1xKM/aNXmgI+NWScywmMTQk/SuUAAcSUD24a
	 VyOb7XL02FM27bm7fmjPI+cWILD1t0Gwk/cVf4Gi47TZ5M+JQA1vDhcilMRwrwDgaS
	 9L2UqR81e9rfq7eJtwnV3LmgXT1qFWg4/blM35k8=
Date: Fri, 02 Feb 2024 04:13:26 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240202121328.355E0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mremap_dontunmap: conform test to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch

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
Subject: selftests/mm: mremap_dontunmap: conform test to TAP format output
Date: Wed, 31 Jan 2024 19:05:17 +0500

Conform the layout, informational and status messages to TAP. No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240131140528.320252-7-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_dontunmap.c |   32 ++++++++++------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/mremap_dontunmap.c~selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -27,14 +27,14 @@ static void dump_maps(void)
 	system(cmd);
 }
 
-#define BUG_ON(condition, description)					      \
-	do {								      \
-		if (condition) {					      \
-			fprintf(stderr, "[FAIL]\t%s():%d\t%s:%s\n", __func__, \
-				__LINE__, (description), strerror(errno));    \
-			dump_maps();					  \
-			exit(1);					      \
-		} 							      \
+#define BUG_ON(condition, description)						\
+	do {									\
+		if (condition) {						\
+			dump_maps();						\
+			ksft_exit_fail_msg("[FAIL]\t%s:%d\t%s:%s\n",		\
+					   __func__, __LINE__, (description),	\
+					   strerror(errno));			\
+		}								\
 	} while (0)
 
 // Try a simple operation for to "test" for kernel support this prevents
@@ -122,6 +122,7 @@ static void mremap_dontunmap_simple()
 	       "unable to unmap destination mapping");
 	BUG_ON(munmap(source_mapping, num_pages * page_size) == -1,
 	       "unable to unmap source mapping");
+	ksft_test_result_pass("%s\n", __func__);
 }
 
 // This test validates that MREMAP_DONTUNMAP on a shared mapping works as expected.
@@ -173,6 +174,7 @@ static void mremap_dontunmap_simple_shme
 	       "unable to unmap destination mapping");
 	BUG_ON(munmap(source_mapping, num_pages * page_size) == -1,
 	       "unable to unmap source mapping");
+	ksft_test_result_pass("%s\n", __func__);
 }
 
 // This test validates MREMAP_DONTUNMAP will move page tables to a specific
@@ -219,6 +221,7 @@ static void mremap_dontunmap_simple_fixe
 	       "unable to unmap destination mapping");
 	BUG_ON(munmap(source_mapping, num_pages * page_size) == -1,
 	       "unable to unmap source mapping");
+	ksft_test_result_pass("%s\n", __func__);
 }
 
 // This test validates that we can MREMAP_DONTUNMAP for a portion of an
@@ -269,6 +272,7 @@ static void mremap_dontunmap_partial_map
 	       "unable to unmap destination mapping");
 	BUG_ON(munmap(source_mapping, num_pages * page_size) == -1,
 	       "unable to unmap source mapping");
+	ksft_test_result_pass("%s\n", __func__);
 }
 
 // This test validates that we can remap over only a portion of a mapping.
@@ -328,19 +332,24 @@ static void mremap_dontunmap_partial_map
 	       "unable to unmap destination mapping");
 	BUG_ON(munmap(source_mapping, 5 * page_size) == -1,
 	       "unable to unmap source mapping");
+	ksft_test_result_pass("%s\n", __func__);
 }
 
 int main(void)
 {
+	ksft_print_header();
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	// test for kernel support for MREMAP_DONTUNMAP skipping the test if
 	// not.
 	if (kernel_support_for_mremap_dontunmap() != 0) {
-		printf("No kernel support for MREMAP_DONTUNMAP\n");
-		return KSFT_SKIP;
+		ksft_print_msg("No kernel support for MREMAP_DONTUNMAP\n");
+		ksft_finished();
 	}
 
+	ksft_set_plan(5);
+
 	// Keep a page sized buffer around for when we need it.
 	page_buffer =
 	    mmap(NULL, page_size, PROT_READ | PROT_WRITE,
@@ -356,6 +365,5 @@ int main(void)
 	BUG_ON(munmap(page_buffer, page_size) == -1,
 	       "unable to unmap page buffer");
 
-	printf("OK\n");
-	return 0;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch
selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch
selftests-mm-map_populate-conform-test-to-tap-format-output.patch
selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch
selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch
selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch
selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch
selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch
selftests-mm-thp_settings-conform-to-tap-format-output.patch
selftests-mm-thuge-gen-conform-to-tap-format-output.patch
selftests-mm-transhuge-stress-conform-to-tap-format-output.patch
selftests-mm-virtual_address_range-conform-to-tap-format-output.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch

