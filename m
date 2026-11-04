Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814063;
	b=JjlwqJeSisDdQyg2TBW65U1sQGPWWMz99c0qF9R1WlPXntMRWNn7R/mXqjn2+YhL3Hm5
	 Ot0o+iUDlcWEsOO/5ix7LOKkTJm4xPinp5sUZQiYk633V9Z6i6nfywVkAqvkj55KY3xRz
	 fvVu0bb56WMm9NK0lr8QM6r97rG2/fknQ3UxxNrsDXaA0L1P2zc5c4jz8y8abkycfCZHk
	 sENACcCfsjZZVkgb0LTu3ed1kmKxQB+4Z33BuGeqVHGg909cemthg81u2Rma6HaUR0+Dj
	 QVtgQG6YZedxtIpjVxldClhrfHp1jIdxRDvBIjCQUoeHLjY0Me/9h0l2rTsPecuW1vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814063;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lvFB2zXv/Pc1I526FlR+uoxjswbGD/Ek4hoUgDKxfFM=;
	b=L15+MKfNLWqwlJWXlMlne4FcYoqVKz23UasfpeDGy/NHDfRNabsP228rDgiBvs9MK44U
	 8/vgk84ffueqiEUwZJ02xt1uCfeollw0oHR9uVyo8j9O/MmjkctA4mYV/viZRnh4Fk3Z+
	 lIibac6scRzjy/O3byVxx4FpNaZdm0AnjGHFvsS8iTLX9ympQu9IOjMGHYz8B8KPOis+j
	 UeprU8iKayX2N16e+DrJlo9A35TTpUrdLzP2u36gz96w921UWcAFw/zlpKjAAi7AWPyEq
	 FfGTNW8h9TYMNqy27ulfg5Tx10xMGrOxiTHXgGpy6TK/9LS3HJuiHae0Lui+dPs3ovg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zGfRpTqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B668A606A331
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zGfRpTqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D051F000C1;
	Wed,  4 Nov 2026 17:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793814062;
	bh=lvFB2zXv/Pc1I526FlR+uoxjswbGD/Ek4hoUgDKxfFM=;
	h=Date:To:From:Subject;
	b=zGfRpTqwrTlJUK/isTbTE0j+3soCVd1A20ZLH3WXpQVENYPU+1whf9Jr9Xd+EwNyp
	 JXV6IjJfV3CcZEwZUZ+QR7KaQ5fuMFK/efaYwNLChwYv+mrwMHFfLa+PjtyLfLY76c
	 DiEna2QDfNUhiu7XLPkrYyqTXSvbfzsK2MIDwuw0=
Date: Wed, 04 Nov 2026 09:41:01 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,sashal@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch added to mm-new branch
Message-Id: <20261104174102.35D051F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: uffd-wp-mremap: keep the THP sizes in unsigned long
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: selftests/mm: uffd-wp-mremap: keep the THP sizes in unsigned long
Date: Tue, 03 Nov 2026 10:02:32 -0500

Commit 0020a1f5ca36 ("selftests/mm: hugepage_settings: use unsigned long
in detect_hugetlb_page_size") changed the sizes of the test cases to
unsigned long, but left thpsizes and detect_thp_sizes() with size_t.  On
32-bit architectures size_t is unsigned int, and gcc 14 rejects the test
cases that point at thpsizes:

  uffd-wp-mremap.c:299:26: error: initialization of 'long unsigned int *' from incompatible pointer type 'size_t *' {aka 'unsigned int *'} [-Wincompatible-pointer-types]

Use unsigned long for the THP sizes as well.

Link: https://lore.kernel.org/20261103150232.291827-1-sashal@kernel.org
Fixes: 0020a1f5ca36 ("selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/uffd-wp-mremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -15,7 +15,7 @@ static int pagemap_fd;
 static int nr_pagesizes = 1;
 static unsigned long pagesize;
 static int nr_thpsizes;
-static size_t thpsizes[20];
+static unsigned long thpsizes[20];
 static int nr_hugetlbsizes;
 static unsigned long hugetlbsizes[10];
 
@@ -30,7 +30,7 @@ static void check_uffd_wp_feature_suppor
 		ksft_exit_skip("uffd-wp feature not supported\n");
 }
 
-static int detect_thp_sizes(size_t sizes[], int max)
+static int detect_thp_sizes(unsigned long sizes[], int max)
 {
 	int count = 0;
 	unsigned long orders;
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch
selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch

