Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8048210A22
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560158; cv=none; b=horxnwR1xXVgXWp8BcAU9XhlTRM67uoLfCAKiXA73upR0UcdDYmB0iNTySudlBSf3l91g4qHLgMkEuiqvCWh2H1FDONZle36Ue/hdW25ULno315neoXLBL3oSxs5eas433KBprMRkanRSLUbpjpvWhpMZXvYZSJ1zjp4vkdm9UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560158; c=relaxed/simple;
	bh=x+auxBlnX6LYawuGE8SN1NPBFq17AN/qXJcZUYyBPPM=;
	h=Date:To:From:Subject:Message-Id; b=TcQx/xT7rv/rXAjRtWnf0OFXaDUawKltOigvLivZqfD2FXV6IWXO5YSNepp69AROXzxqbKpFMe2KBHUAsyFsjyDajCIGU5vBQ+uFVLVm60UrYrtQtmIKqHZZBWxXsb4OMPABVTZEkrNexz4NVZvdvVjk2jZ4prg0B1EEH3gBbF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K5pVqgul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K5pVqgul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57414C433C7;
	Thu, 22 Feb 2024 00:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560158;
	bh=x+auxBlnX6LYawuGE8SN1NPBFq17AN/qXJcZUYyBPPM=;
	h=Date:To:From:Subject:From;
	b=K5pVqgulmtgDBIFIv003eZFJDO5Az7BcisF+VR53XTMvqJ0F7s9LYGD5/lmS3M8am
	 7ZV/DzEF1nsMRqPnnaWUoE56ekev9dA5eFN1B7+ZR7N+12F4rYreMnh5E/aObutjK3
	 5Pkai/GfP7DVR42EVbOvl1bkNisjM70HR72chwzQ=
Date: Wed, 21 Feb 2024 16:02:37 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240222000238.57414C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mremap_dontunmap: conform test to TAP format output
has been removed from the -mm tree.  Its filename was
     selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: mremap_dontunmap: conform test to TAP format output
Date: Fri, 2 Feb 2024 16:31:14 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240202113119.2047740-8-usama.anjum@collabora.com
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

selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

