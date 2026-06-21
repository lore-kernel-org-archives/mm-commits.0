Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BD2369D58
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067151; cv=none; b=Q4oT7zmG3F5nSfwtHR7fQZNnv6hwMrtOA+hb/TnJ1TJNFcwGH4gY9pYdAtvFYerSunyA9DpYWpIlndlMv8M7i/sCjuw8gz29uhesfVJLQA+zD0gM/h+IhyP3DbjFymITawpHn7DjcF9yend1WhILhDeGbj786Wtd8bpgn+Qoq0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067151; c=relaxed/simple;
	bh=0kvS4bfpjbk/hl/fPbHJ9zuVJ1jMBV+BZ3Et5rg3WBE=;
	h=Date:To:From:Subject:Message-Id; b=cmUSDq404xExgL2gp6rBGiIAAQ217z2Nlx8ACTbPSRzjpuJF5FLLvA+1NUK+Dl7rwH9ShH06/kLTWS9UQYeQ/9wppfwBsN0chuNb/I6hpH9xZ6Iuehgpoq2/pRTxXaZ8e28jjzRDBos/i7pbcsrRt+hmJO8lH+TXaJ0TmCnu8gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DH145Eeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DH145Eeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36C91F00A3A;
	Sun, 21 Jun 2026 18:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067149;
	bh=BP9F9PjQKgw2/Pp/OuBnAR/uh2fAZkj8aVsleRzViw8=;
	h=Date:To:From:Subject;
	b=DH145EeusdayfoEW0PnabokRVqjOWDF6J0unqUh1e88tzVKd6IRK4rPPQYZfrXaAc
	 yEuhxC0VjQBOt0T+/U5cXiAfzuB1lDciBg7ygQqhA6JoqUvUAwPtK5+2gdlwtlnGaS
	 dy9g87bVtLLJOgnO08CTnJvsWQC+xEh+2+6UngHo=
Date: Sun, 21 Jun 2026 11:39:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch removed from -mm tree
Message-Id: <20260621183909.B36C91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
Date: Mon, 11 May 2026 19:28:09 +0300

... instead of size_t to avoid type mismatch in 32 and 64 bit builds.

Link: https://lore.kernel.org/20260511162840.375890-26-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c               |    2 +-
 tools/testing/selftests/mm/gup_longterm.c      |    2 +-
 tools/testing/selftests/mm/hugepage_settings.c |    2 +-
 tools/testing/selftests/mm/hugepage_settings.h |    2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c    |    6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size
+++ a/tools/testing/selftests/mm/cow.c
@@ -37,7 +37,7 @@ static size_t pmdsize;
 static int nr_thpsizes;
 static size_t thpsizes[20];
 static int nr_hugetlbsizes;
-static size_t hugetlbsizes[10];
+static unsigned long hugetlbsizes[10];
 static int gup_fd;
 static bool has_huge_zeropage;
 
--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -33,7 +33,7 @@
 
 static size_t pagesize;
 static int nr_hugetlbsizes;
-static size_t hugetlbsizes[10];
+static unsigned long hugetlbsizes[10];
 static int gup_fd;
 
 static __fsword_t get_fs_type(int fd)
--- a/tools/testing/selftests/mm/hugepage_settings.c~selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size
+++ a/tools/testing/selftests/mm/hugepage_settings.c
@@ -398,7 +398,7 @@ bool thp_is_enabled(void)
 	return mode == 1 || mode == 3;
 }
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max)
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 {
 	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
 	int count = 0;
--- a/tools/testing/selftests/mm/hugepage_settings.h~selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size
+++ a/tools/testing/selftests/mm/hugepage_settings.h
@@ -90,7 +90,7 @@ bool thp_is_enabled(void);
 
 /* HugeTLB */
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max);
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
 unsigned long default_huge_page_size(void);
 unsigned long get_free_hugepages(void);
 
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -12,12 +12,12 @@
 #include "uffd-common.h"
 
 static int pagemap_fd;
-static size_t pagesize;
 static int nr_pagesizes = 1;
+static unsigned long pagesize;
 static int nr_thpsizes;
 static size_t thpsizes[20];
 static int nr_hugetlbsizes;
-static size_t hugetlbsizes[10];
+static unsigned long hugetlbsizes[10];
 
 static int detect_thp_sizes(size_t sizes[], int max)
 {
@@ -245,7 +245,7 @@ out:
 }
 
 struct testcase {
-	size_t *sizes;
+	unsigned long *sizes;
 	int *nr_sizes;
 	bool private;
 	bool swapout;
_

Patches currently in -mm which might be from rppt@kernel.org are


