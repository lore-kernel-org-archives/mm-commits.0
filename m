Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1FAAD2C
	for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2025 22:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756162450; cv=none; b=Cd7ycwN2504T7IUv6lpU6lIbvBwV9R3CKgmg/EGtLe/TP42W3agvul7o4h492Ot6yMyKI69JaoqZv33twBfY/yxg38f6ePgtRLE9VclJr0trI+rwdyqAXna6cMtl11Gx/ZMtYuW6nYGaBdVI6awqyS5m6qmL37rPetzKhczQ1y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756162450; c=relaxed/simple;
	bh=MnMRLdCnD+Y3ZDC2Joaz1zBgUvnI6xbvsaCYfMEm/ZI=;
	h=Date:To:From:Subject:Message-Id; b=l4yf2gChYTwfXwXjBQeocHcdk4BTY3RK7OpnMUUAvneEkfV67YF3tBAAb+B0YcnF1zQnmhKvbLwH0+rox1Wak+4ovCdyR5k9C95MVe9RBffyzmjt5aFtugnqiPUIu6xmbaF3q3GFv8ucdBZyLtEj5gORkRl0EeGDZnnaXiip5Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O6KZAy53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O6KZAy53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EDDC4CEED;
	Mon, 25 Aug 2025 22:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756162449;
	bh=MnMRLdCnD+Y3ZDC2Joaz1zBgUvnI6xbvsaCYfMEm/ZI=;
	h=Date:To:From:Subject:From;
	b=O6KZAy53mY31mjNfdUU03+ZgCvJjXT9K1ihzi+Tu3OfCDd0nJNZlzxn/lttq+H0le
	 0SD9EKjbr2PiapkBaMNKtWl/wepqky1T2tO2J+MMyxifAhXO1A6zoE8QGUV2xdYeF4
	 IYZw3TnhMG0vulPURZ5g7ek3zermVcpcKFaj5IfM=
Date: Mon, 25 Aug 2025 15:54:08 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,viswanathiyyappan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-calloc-instead-of-malloc-in-pagemap_ioctlc.patch added to mm-new branch
Message-Id: <20250825225409.A4EDDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use calloc instead of malloc in pagemap_ioctl.c
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-use-calloc-instead-of-malloc-in-pagemap_ioctlc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-calloc-instead-of-malloc-in-pagemap_ioctlc.patch

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
From: I Viswanath <viswanathiyyappan@gmail.com>
Subject: selftests/mm: use calloc instead of malloc in pagemap_ioctl.c
Date: Mon, 25 Aug 2025 22:36:43 +0530

As per Documentation/process/deprecated.rst, dynamic size calculations
should not be performed in memory allocator arguments due to possible
overflows.

Replace malloc with calloc to avoid open-ended arithmetic and prevent
possible overflows.

Link: https://lkml.kernel.org/r/20250825170643.63174-1-viswanathiyyappan@gmail.com
Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-use-calloc-instead-of-malloc-in-pagemap_ioctlc
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -209,7 +209,7 @@ int userfaultfd_tests(void)
 	wp_addr_range(mem, mem_size);
 
 	vec_size = mem_size/page_size;
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 				vec_size - 2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
@@ -247,11 +247,11 @@ int sanity_tests_sd(void)
 	vec_size = num_pages/2;
 	mem_size = num_pages * page_size;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
-	vec2 = malloc(sizeof(struct page_region) * vec_size);
+	vec2 = calloc(vec_size, sizeof(struct page_region));
 	if (!vec2)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -436,7 +436,7 @@ int sanity_tests_sd(void)
 	mem_size = 1050 * page_size;
 	vec_size = mem_size/(page_size*2);
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -491,7 +491,7 @@ int sanity_tests_sd(void)
 	mem_size = 10000 * page_size;
 	vec_size = 50;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -541,7 +541,7 @@ int sanity_tests_sd(void)
 	vec_size = 1000;
 	mem_size = vec_size * page_size;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -695,8 +695,8 @@ int base_tests(char *prefix, char *mem,
 	}
 
 	vec_size = mem_size/page_size;
-	vec = malloc(sizeof(struct page_region) * vec_size);
-	vec2 = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
+	vec2 = calloc(vec_size, sizeof(struct page_region));
 
 	/* 1. all new pages must be not be written (dirty) */
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -807,8 +807,8 @@ int hpage_unit_tests(void)
 	unsigned long long vec_size = map_size/page_size;
 	struct page_region *vec, *vec2;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
-	vec2 = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
+	vec2 = calloc(vec_size, sizeof(struct page_region));
 	if (!vec || !vec2)
 		ksft_exit_fail_msg("malloc failed\n");
 
@@ -997,7 +997,7 @@ int unmapped_region_tests(void)
 	void *start = (void *)0x10000000;
 	int written, len = 0x00040000;
 	long vec_size = len / page_size;
-	struct page_region *vec = malloc(sizeof(struct page_region) * vec_size);
+	struct page_region *vec = calloc(vec_size, sizeof(struct page_region));
 
 	/* 1. Get written pages */
 	written = pagemap_ioctl(start, len, vec, vec_size, 0, 0,
@@ -1062,7 +1062,7 @@ int sanity_tests(void)
 	mem_size = 10 * page_size;
 	vec_size = mem_size / page_size;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (mem == MAP_FAILED || vec == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem\n");
_

Patches currently in -mm which might be from viswanathiyyappan@gmail.com are

selftests-mm-use-calloc-instead-of-malloc-in-pagemap_ioctlc.patch

