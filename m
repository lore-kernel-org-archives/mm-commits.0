Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440932;
	b=MoPdB3a4rg9AfyVxV22/ydvpD1xrCZYusE5AP7tZrZ+whSdNHaJNsmp9w2ZTV5t9RWig
	 xXFtOfmzBfP0zzNSzQVebA3I+X7nCIauPDJVZv/fiTax3Q8A0T/WOKUIJk1OSNHDGZ2YJ
	 S14Z7f17plwXblIb8+93+qqDb0b1snD6ZaLpn0nYiIc0SG24RgrkHKuKWysqQWfrjGh3a
	 nefMe+H0nsPDGZ09SXPH4ZuwllJBm9Q+AEkVZI5fTxTO74D3kQP1m16+mmQsYX2fieI+y
	 +t7NHIVqKZf2j8Gql0tcGKjWW9onJR/unStXLpxdxF659iD52ZJy44P+YhnkyIbRQdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440932;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=btm4CwNvb19RJb9O74G6ETZyavQ1Xqh0TgNZkBtsqxM=;
	b=onwFX/DZNXj5hlM6zkC3JATOtIAmZuycM2L3sgzqB0BOzCDM9eEDXAYeySnM2IkHVKJS
	 iHp0+msxSIcwnz9oBGogURFq63gmg71yvpponZKcmH2o2t296mWXbug5MNYI+ykCm3B8E
	 aSdTK1cS0d7IWgD/NKjFdHpmLbU81ZReTQ1LG0fzNZMNdb1qNepSFrokOGh0aVwg6srTv
	 oczd+oWVNCabCrffMvZkOzKSAW8tRpInxxpJOrGoP2Gag4pBfox07j7Ei2Jce1Be/p4AZ
	 aWpkCvskBpaKRwIHcLN/4rtiwn16uHKjhbqEIX5k938K/jV+lzHoPJvsp3E/NDQnU9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MV+O7Ecl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFE760A6F43
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 23:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MV+O7Ecl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35441F00A05;
	Wed, 11 Nov 2026 23:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794440931;
	bh=btm4CwNvb19RJb9O74G6ETZyavQ1Xqh0TgNZkBtsqxM=;
	h=Date:To:From:Subject;
	b=MV+O7EclGlvoD/cJX8u1u8QB+KSc57caoYQH2rEQYLaTnoO2WaJZU3Zg1hI7qTn9h
	 ERp5fPvhwwXHOHxsnwdDjkbehbN/X72Tye03CUbSU/rSf6zmKVgUH7ya1qe5hxGnWI
	 b5y3i4f+jHBCw3CTGZaeYxbT4s9IfkeoPTPrib9g=
Date: Wed, 11 Nov 2026 15:48:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,
	surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,
	chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch added to mm-new branch
Message-Id: <20261111234851.A35441F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch

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
From: Chris Down <chris@chrisdown.name>
Subject: selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test
Date: Tue, 10 Nov 2026 18:10:28 -0800

The move-pmd test exercises UFFDIO_MOVE on anonymous THPs but does not
cover the huge zeropage PMD path.

Add a test that faults in a huge zeropage PMD, moves it in response to one
missing fault, and checks that the destination still maps the huge
zeropage.

Link: https://lore.kernel.org/avPOlMOmUdjPe5NJ@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   98 +++++++++++++++++
 tools/testing/selftests/mm/vm_util.c         |   29 +++++
 tools/testing/selftests/mm/vm_util.h         |    2 
 3 files changed, 129 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2132,6 +2132,97 @@ static void uffd_move_pmd_test(uffd_glob
 			      uffd_move_pmd_handle_fault);
 }
 
+static void uffd_move_pmd_huge_zeropage_test(uffd_global_test_opts_t *gopts,
+					     uffd_test_args_t *targs)
+{
+	unsigned long pmd_size = read_pmd_pagesize();
+	unsigned long nr_pages_per_pmd;
+	unsigned long bytes = gopts->nr_pages * gopts->page_size;
+	char *orig_area_src = gopts->area_src, *orig_area_dst = gopts->area_dst;
+	char *aligned_src, *aligned_dst;
+	unsigned long src_offs, dst_offs, max_offs;
+	pthread_t uffd_mon;
+	struct uffd_args args = { 0 };
+	char c = '\0';
+	int pagemap_fd;
+
+	if (pmd_size <= gopts->page_size) {
+		uffd_test_skip("Could not detect PMD size");
+		return;
+	}
+	if (!detect_huge_zeropage()) {
+		uffd_test_skip("transparent huge zeropage disabled");
+		return;
+	}
+
+	nr_pages_per_pmd = pmd_size / gopts->page_size;
+	if (bytes < pmd_size) {
+		uffd_test_skip("not enough pages for one PMD-sized move");
+		return;
+	}
+
+	aligned_src = ALIGN_UP(orig_area_src, pmd_size);
+	aligned_dst = ALIGN_UP(orig_area_dst, pmd_size);
+	src_offs = (aligned_src - orig_area_src) / gopts->page_size;
+	dst_offs = (aligned_dst - orig_area_dst) / gopts->page_size;
+	max_offs = src_offs > dst_offs ? src_offs : dst_offs;
+	if (max_offs + nr_pages_per_pmd > gopts->nr_pages) {
+		uffd_test_skip("could not find aligned PMD-sized src/dst window");
+		return;
+	}
+
+	if (madvise(orig_area_dst, bytes, MADV_HUGEPAGE))
+		err("madvise(MADV_HUGEPAGE) failure");
+	if (madvise(orig_area_src, bytes, MADV_DONTFORK))
+		err("madvise(MADV_DONTFORK) failure");
+	if (madvise(aligned_src, pmd_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failure");
+
+	/* Fault in a PMD-sized huge zeropage mapping in the source. */
+	force_read_pages(aligned_src, nr_pages_per_pmd, gopts->page_size);
+
+	pagemap_fd = pagemap_open();
+	if (!pagemap_is_huge_zero(pagemap_fd, aligned_src)) {
+		close(pagemap_fd);
+		uffd_test_skip("could not fault in the huge zeropage");
+		return;
+	}
+	gopts->area_src = aligned_src;
+	gopts->area_dst = aligned_dst;
+
+	if (uffd_register(gopts->uffd, gopts->area_dst, pmd_size, true, false, false))
+		err("register failure");
+
+	args.gopts = gopts;
+	args.handle_fault = uffd_move_pmd_handle_fault;
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
+		err("uffd_poll_thread create");
+
+	/*
+	 * One fault on dst should trigger a single PMD-sized UFFDIO_MOVE from
+	 * the huge zeropage PMD we populated in the source.
+	 */
+	force_read_pages(gopts->area_dst, nr_pages_per_pmd, gopts->page_size);
+
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (args.missing_faults != 1 || args.minor_faults != 0)
+		uffd_test_fail("stats check error");
+	else if (!pagemap_is_huge_zero(pagemap_fd, gopts->area_dst))
+		uffd_test_fail("moved destination is not a huge zeropage PMD");
+	else if (smaps_has_anon_huge_pages(gopts->area_dst))
+		uffd_test_fail("moved huge zeropage PMD counted as AnonHugePages");
+	else
+		uffd_test_pass();
+
+	gopts->area_src = orig_area_src;
+	gopts->area_dst = orig_area_dst;
+	close(pagemap_fd);
+}
+
 static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *targs)
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
@@ -2523,6 +2614,13 @@ uffd_test_case_t uffd_tests[] = {
 		.mem_targets = MEM_ANON,
 		.uffd_feature_required = UFFD_FEATURE_MOVE,
 		.test_case_ops = &uffd_move_test_pmd_case_ops,
+	},
+	{
+		.name = "move-pmd-huge-zeropage",
+		.uffd_fn = uffd_move_pmd_huge_zeropage_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE,
+		.test_case_ops = &uffd_move_test_pmd_case_ops,
 	},
 	{
 		.name = "move-pmd-split",
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -124,6 +124,18 @@ bool pagemap_is_populated(int fd, char *
 				PAGE_IS_PRESENT | PAGE_IS_SWAPPED);
 }
 
+bool pagemap_is_huge_zero(int fd, char *start)
+{
+	const uint64_t expected = PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE;
+	uint64_t categories;
+
+	if (!pagemap_scan_supported(fd, start))
+		return false;
+
+	categories = pagemap_scan_get_categories(fd, start);
+	return (categories & expected) == expected;
+}
+
 unsigned long pagemap_get_pfn(int fd, char *start)
 {
 	uint64_t entry = pagemap_get_entry(fd, start);
@@ -374,6 +386,23 @@ err_out:
 	return entry;
 }
 
+bool smaps_has_anon_huge_pages(void *addr)
+{
+	char buf[MAX_LINE_LENGTH];
+	unsigned long anon_huge_kb;
+	char *entry, *end;
+
+	entry = __get_smap_entry(addr, "AnonHugePages:", buf, sizeof(buf));
+	if (!entry)
+		ksft_exit_fail_msg("could not find AnonHugePages\n");
+
+	anon_huge_kb = strtoul(entry, &end, 10);
+	if (end == entry)
+		ksft_exit_fail_msg("could not parse AnonHugePages\n");
+
+	return anon_huge_kb != 0;
+}
+
 static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size)
 {
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -102,12 +102,14 @@ uint64_t pagemap_get_entry(int fd, char
 bool pagemap_is_softdirty(int fd, char *start);
 bool pagemap_is_swapped(int fd, char *start);
 bool pagemap_is_populated(int fd, char *start);
+bool pagemap_is_huge_zero(int fd, char *start);
 unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t pmd_psize(void);
 uint64_t pmd_pshift(void);
 unsigned long rss_anon(void);
+bool smaps_has_anon_huge_pages(void *addr);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcontrol-dont-lose-track-of-exiting-oom-victims.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch

