Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158434A04
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733794678; cv=none; b=TIJCnrAwdrO+Gkh3o2QAcZzXYNhjh/So3MbLATB5Nv0TXRC/sxQBCWiplh+IBJv/7vpON/SjjGmRo/3T2LP5j9J+U+D6H4kMJ8oWZSX0VsXJdju8b/GpoRCXRuG7tpqdiaqTv8sNPxPvRfKoaisWJAlzn1JxNH2Oj5zSdKi30mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733794678; c=relaxed/simple;
	bh=VAKwqspZGR+VHCgN3LJXlmCwom5v6xt48uw9dwuFrVU=;
	h=Date:To:From:Subject:Message-Id; b=EnvPFxuhLGJ06gH5K2PEV54ObIK3Mg5lIK3i5eZmJa6C6X8tfAtbcR2EULTAjrGsQJQ70+wJJyOcLyJSm6mH2CWsgOndwDiCqijyx90+ExjuDHU3mY/Fx5x23AR3LLfgPjcUVRkgSPek5JHJtfZg8udwlkt0QqaldPcCFaq3b1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xCu1x6tK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xCu1x6tK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30A1C4CED1;
	Tue, 10 Dec 2024 01:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733794677;
	bh=VAKwqspZGR+VHCgN3LJXlmCwom5v6xt48uw9dwuFrVU=;
	h=Date:To:From:Subject:From;
	b=xCu1x6tK9x63aS0w92GcXraiX+lpu54jMiYm+oEJo3zfaqMhZ52rmYHPjFssHprde
	 jw/fcUCbzIWEyW4P0XjDNjyF8KP4e/Yn6WF8sWts2spYKa+T/UBvoTbzlSEyYTUmGU
	 NqVSHQxANkfPFW2U+QDLHmV6Zky7VoqlUa8buVwQ=
Date: Mon, 09 Dec 2024 17:37:57 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch added to mm-unstable branch
Message-Id: <20241210013757.C30A1C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: pagemap_ioctl: Fix types mismatches shown by compiler options
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch

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
Subject: selftests/mm: pagemap_ioctl: Fix types mismatches shown by compiler options
Date: Mon, 9 Dec 2024 23:56:22 +0500

Fix following warnings caught by compiler:

- There are several type mismatches among different variables.
- Remove unused variable warnings.

Link: https://lkml.kernel.org/r/20241209185624.2245158-3-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |  108 ++++++++++---------
 tools/testing/selftests/mm/vm_util.c       |    2 
 2 files changed, 59 insertions(+), 51 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -34,8 +34,8 @@
 #define PAGEMAP "/proc/self/pagemap"
 int pagemap_fd;
 int uffd;
-int page_size;
-int hpage_size;
+unsigned int page_size;
+unsigned int hpage_size;
 const char *progname;
 
 #define LEN(region)	((region.end - region.start)/page_size)
@@ -235,7 +235,9 @@ int get_reads(struct page_region *vec, i
 
 int sanity_tests_sd(void)
 {
-	int mem_size, vec_size, ret, ret2, ret3, i, num_pages = 1000, total_pages = 0;
+	unsigned long long mem_size, vec_size, i, total_pages = 0;
+	long ret, ret2, ret3;
+	int num_pages = 1000;
 	int total_writes, total_reads, reads, count;
 	struct page_region *vec, *vec2;
 	char *mem, *m[2];
@@ -321,9 +323,9 @@ int sanity_tests_sd(void)
 	ret = pagemap_ioctl(mem, mem_size, vec, vec_size, 0, 0, PAGE_IS_WRITTEN, 0,
 			    0, PAGE_IS_WRITTEN);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
-	ksft_test_result(ret == mem_size/(page_size * 2),
+	ksft_test_result((unsigned long long)ret == mem_size/(page_size * 2),
 			 "%s Repeated pattern of written and non-written pages\n", __func__);
 
 	/* 4. Repeated pattern of written and non-written pages in parts */
@@ -331,21 +333,21 @@ int sanity_tests_sd(void)
 			    PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			    num_pages/2 - 2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	ret2 = pagemap_ioctl(mem, mem_size, vec, 2, 0, 0, PAGE_IS_WRITTEN, 0, 0,
 			     PAGE_IS_WRITTEN);
 	if (ret2 < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret2, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret2, errno, strerror(errno));
 
 	ret3 = pagemap_ioctl(mem, mem_size, vec, vec_size,
 			     PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			     0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret3 < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret3, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret3, errno, strerror(errno));
 
 	ksft_test_result((ret + ret3) == num_pages/2 && ret2 == 2,
-			 "%s Repeated pattern of written and non-written pages in parts %d %d %d\n",
+			 "%s Repeated pattern of written and non-written pages in parts %ld %ld %ld\n",
 			 __func__, ret, ret3, ret2);
 
 	/* 5. Repeated pattern of written and non-written pages max_pages */
@@ -357,13 +359,13 @@ int sanity_tests_sd(void)
 			    PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			    num_pages/2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	ret2 = pagemap_ioctl(mem, mem_size, vec, vec_size,
 			     PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			     0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret2 < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret2, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret2, errno, strerror(errno));
 
 	ksft_test_result(ret == num_pages/2 && ret2 == 1,
 			 "%s Repeated pattern of written and non-written pages max_pages\n",
@@ -378,12 +380,12 @@ int sanity_tests_sd(void)
 			    PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			    2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	ret2 = pagemap_ioctl(mem, mem_size, vec2, vec_size, 0, 0,
 			      PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret2 < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret2, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret2, errno, strerror(errno));
 
 	ksft_test_result(ret == 1 && LEN(vec[0]) == 2 &&
 			 vec[0].start == (uintptr_t)(mem + page_size) &&
@@ -416,7 +418,7 @@ int sanity_tests_sd(void)
 	ret = pagemap_ioctl(m[1], mem_size, vec, 1, 0, 0, PAGE_IS_WRITTEN, 0, 0,
 			    PAGE_IS_WRITTEN);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	ksft_test_result(ret == 1 && LEN(vec[0]) == mem_size/page_size,
 			 "%s Two regions\n", __func__);
@@ -448,7 +450,7 @@ int sanity_tests_sd(void)
 			    PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC, 0,
 			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	for (i = 0; i < mem_size/page_size; i += 2)
 		mem[i * page_size]++;
@@ -457,7 +459,7 @@ int sanity_tests_sd(void)
 			    PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			    mem_size/(page_size*5), PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	total_pages += ret;
 
@@ -465,7 +467,7 @@ int sanity_tests_sd(void)
 			    PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			    mem_size/(page_size*5), PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	total_pages += ret;
 
@@ -473,7 +475,7 @@ int sanity_tests_sd(void)
 			    PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			    mem_size/(page_size*5), PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	total_pages += ret;
 
@@ -515,9 +517,9 @@ int sanity_tests_sd(void)
 					  vec_size, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 					  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 			if (ret < 0)
-				ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+				ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
-			if (ret > vec_size)
+			if ((unsigned long)ret > vec_size)
 				break;
 
 			reads = get_reads(vec, ret);
@@ -554,63 +556,63 @@ int sanity_tests_sd(void)
 	ret = pagemap_ioc(mem, 0, vec, vec_size, 0,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 0 && walk_end == (long)mem,
 			 "Walk_end: Same start and end address\n");
 
 	ret = pagemap_ioc(mem, 0, vec, vec_size, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 0 && walk_end == (long)mem,
 			 "Walk_end: Same start and end with WP\n");
 
 	ret = pagemap_ioc(mem, 0, vec, 0, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 0 && walk_end == (long)mem,
 			 "Walk_end: Same start and end with 0 output buffer\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, vec_size, 0,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 1 && walk_end == (long)(mem + mem_size),
 			 "Walk_end: Big vec\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, 1, 0,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 1 && walk_end == (long)(mem + mem_size),
 			 "Walk_end: vec of minimum length\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, 1, 0,
 			  vec_size, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 1 && walk_end == (long)(mem + mem_size),
 			 "Walk_end: Max pages specified\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, vec_size, 0,
 			  vec_size/2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 1 && walk_end == (long)(mem + mem_size/2),
 			 "Walk_end: Half max pages\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, vec_size, 0,
 			  1, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 1 && walk_end == (long)(mem + page_size),
 			 "Walk_end: 1 max page\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, vec_size, 0,
 			  -1, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 1 && walk_end == (long)(mem + mem_size),
 			 "Walk_end: max pages\n");
 
@@ -621,49 +623,49 @@ int sanity_tests_sd(void)
 	ret = pagemap_ioc(mem, mem_size, vec, vec_size, 0,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
-	ksft_test_result(ret == vec_size/2 && walk_end == (long)(mem + mem_size),
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
+	ksft_test_result((unsigned long)ret == vec_size/2 && walk_end == (long)(mem + mem_size),
 			 "Walk_end sparse: Big vec\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, 1, 0,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 1 && walk_end == (long)(mem + page_size * 2),
 			 "Walk_end sparse: vec of minimum length\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, 1, 0,
 			  vec_size, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 1 && walk_end == (long)(mem + page_size * 2),
 			 "Walk_end sparse: Max pages specified\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, vec_size/2, 0,
 			  vec_size, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
-	ksft_test_result(ret == vec_size/2 && walk_end == (long)(mem + mem_size),
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
+	ksft_test_result((unsigned long)ret == vec_size/2 && walk_end == (long)(mem + mem_size),
 			 "Walk_end sparse: Max pages specified\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, vec_size, 0,
 			  vec_size, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
-	ksft_test_result(ret == vec_size/2 && walk_end == (long)(mem + mem_size),
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
+	ksft_test_result((unsigned long)ret == vec_size/2 && walk_end == (long)(mem + mem_size),
 			 "Walk_end sparse: Max pages specified\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, vec_size, 0,
 			  vec_size/2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
-	ksft_test_result(ret == vec_size/2 && walk_end == (long)(mem + mem_size),
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
+	ksft_test_result((unsigned long)ret == vec_size/2 && walk_end == (long)(mem + mem_size),
 			 "Walk_endsparse : Half max pages\n");
 
 	ret = pagemap_ioc(mem, mem_size, vec, vec_size, 0,
 			  1, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 	ksft_test_result(ret == 1 && walk_end == (long)(mem + page_size * 2),
 			 "Walk_end: 1 max page\n");
 
@@ -674,9 +676,10 @@ int sanity_tests_sd(void)
 	return 0;
 }
 
-int base_tests(char *prefix, char *mem, int mem_size, int skip)
+int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
 {
-	int vec_size, written;
+	unsigned long long vec_size;
+	int written;
 	struct page_region *vec, *vec2;
 
 	if (skip) {
@@ -799,8 +802,8 @@ int hpage_unit_tests(void)
 	char *map;
 	int ret, ret2;
 	size_t num_pages = 10;
-	int map_size = hpage_size * num_pages;
-	int vec_size = map_size/page_size;
+	unsigned long long map_size = hpage_size * num_pages;
+	unsigned long long vec_size = map_size/page_size;
 	struct page_region *vec, *vec2;
 
 	vec = malloc(sizeof(struct page_region) * vec_size);
@@ -1047,7 +1050,8 @@ static void test_simple(void)
 
 int sanity_tests(void)
 {
-	int mem_size, vec_size, ret, fd, i, buf_size;
+	unsigned long long mem_size, vec_size;
+	int ret, fd, i, buf_size;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
@@ -1312,7 +1316,9 @@ static ssize_t get_dirty_pages_reset(cha
 {
 	struct pm_scan_arg arg = {0};
 	struct page_region rgns[256];
-	int i, j, cnt, ret;
+	unsigned long long i, j;
+	long ret;
+	int cnt;
 
 	arg.size = sizeof(struct pm_scan_arg);
 	arg.start = (uintptr_t)mem;
@@ -1330,7 +1336,7 @@ static ssize_t get_dirty_pages_reset(cha
 		ksft_exit_fail_msg("ioctl failed\n");
 
 	cnt = 0;
-	for (i = 0; i < ret; ++i) {
+	for (i = 0; i < (unsigned long)ret; ++i) {
 		if (rgns[i].categories != PAGE_IS_WRITTEN)
 			ksft_exit_fail_msg("wrong flags\n");
 
@@ -1384,9 +1390,10 @@ void *thread_proc(void *mem)
 static void transact_test(int page_size)
 {
 	unsigned int i, count, extra_pages;
+	unsigned int c;
 	pthread_t th;
 	char *mem;
-	int ret, c;
+	int ret;
 
 	if (pthread_barrier_init(&start_barrier, NULL, nthreads + 1))
 		ksft_exit_fail_msg("pthread_barrier_init\n");
@@ -1473,9 +1480,10 @@ static void transact_test(int page_size)
 			      extra_thread_faults);
 }
 
-int main(int argc, char *argv[])
+int main(int __attribute__((unused)) argc, char *argv[])
 {
-	int mem_size, shmid, buf_size, fd, i, ret;
+	int shmid, buf_size, fd, i, ret;
+	unsigned long long mem_size;
 	char *mem, *map, *fmem;
 	struct stat sbuf;
 
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -138,7 +138,7 @@ void clear_softdirty(void)
 		ksft_exit_fail_msg("opening clear_refs failed\n");
 	ret = write(fd, ctrl, strlen(ctrl));
 	close(fd);
-	if (ret != strlen(ctrl))
+	if (ret != (signed int)strlen(ctrl))
 		ksft_exit_fail_msg("writing clear_refs failed\n");
 }
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-thp_settings-remove-const-from-return-type.patch
selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch
selftests-mm-mseal_test-remove-unused-variables.patch
selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch

