Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF5518E05C
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925245; cv=none; b=eQCotjNmNJrhawovLnhqQStANZ9EU/jRShdNtS8wiODNnv2J/w6IYHxKePGG0DzTOutaimG6kpqq+lV/9mrS2a0zCBa8inXufAzf3XjuQ1ZebUX9aPelaLtaEdYPK8FxV+0o+ppNtDSt6Cj7fJXwlTv8b8gf1plxbgj6mclj6UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925245; c=relaxed/simple;
	bh=Wk5JqegepdK6N8LV35oLG5tNvWmtSXIGYIzteNdXsxg=;
	h=Date:To:From:Subject:Message-Id; b=QB9SWMsD1fAvNr2kI5YXjqZZ+X4QXJpQfVmc/u3TybS3GU+cvgWJalMA/7fmEMbGcE60B+Ig+1DIiSg02OgSXAvpebhm7erOOKsQGwTp6BmSGFB61uXj5F/hTp+jMh4/vjKQPg8UakbWQ/ZzyAdOTxvYxMzzsor6MsAzrTxxTXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WUZsK0a4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WUZsK0a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23103C4CEC5;
	Mon,  9 Sep 2024 23:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925245;
	bh=Wk5JqegepdK6N8LV35oLG5tNvWmtSXIGYIzteNdXsxg=;
	h=Date:To:From:Subject:From;
	b=WUZsK0a4Q/s4iRbQYU2jW573ikAtu3Vf2i+AJKKT9xUKIUVUMZqgcIZddPCEvG+Yb
	 5aHwynseq4ugT50A2Mci8sAPgeC6gwoxDJl4QjXM56LdZdbqDB72dKhCGvk9tupjJj
	 NDycQFpAYaHCaOE8jRM1VWzVqxT6NhannFEeYUyA=
Date: Mon, 09 Sep 2024 16:40:44 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,yuzhao@google.com,willy@infradead.org,usamaarif642@gmail.com,szhai2@cs.rochester.edu,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-selftest-to-verify-zero-filled-pages-are-mapped-to-zeropage.patch removed from -mm tree
Message-Id: <20240909234045.23103C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: selftest to verify zero-filled pages are mapped to zeropage
has been removed from the -mm tree.  Its filename was
     mm-selftest-to-verify-zero-filled-pages-are-mapped-to-zeropage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Zhu <alexlzhu@fb.com>
Subject: mm: selftest to verify zero-filled pages are mapped to zeropage
Date: Fri, 30 Aug 2024 11:03:37 +0100

When a THP is split, any subpage that is zero-filled will be mapped to the
shared zeropage, hence saving memory.  Add selftest to verify this by
allocating zero-filled THP and comparing RssAnon before and after split.

Link: https://lkml.kernel.org/r/20240830100438.3623486-4-usamaarif642@gmail.com
Signed-off-by: Alexander Zhu <alexlzhu@fb.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuang Zhai <zhais@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Shuang Zhai <szhai2@cs.rochester.edu>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   71 ++++++++++++
 tools/testing/selftests/mm/vm_util.c              |   22 +++
 tools/testing/selftests/mm/vm_util.h              |    1 
 3 files changed, 94 insertions(+)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~mm-selftest-to-verify-zero-filled-pages-are-mapped-to-zeropage
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -84,6 +84,76 @@ static void write_debugfs(const char *fm
 	write_file(SPLIT_DEBUGFS, input, ret + 1);
 }
 
+static char *allocate_zero_filled_hugepage(size_t len)
+{
+	char *result;
+	size_t i;
+
+	result = memalign(pmd_pagesize, len);
+	if (!result) {
+		printf("Fail to allocate memory\n");
+		exit(EXIT_FAILURE);
+	}
+
+	madvise(result, len, MADV_HUGEPAGE);
+
+	for (i = 0; i < len; i++)
+		result[i] = (char)0;
+
+	return result;
+}
+
+static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
+{
+	unsigned long rss_anon_before, rss_anon_after;
+	size_t i;
+
+	if (!check_huge_anon(one_page, 4, pmd_pagesize)) {
+		printf("No THP is allocated\n");
+		exit(EXIT_FAILURE);
+	}
+
+	rss_anon_before = rss_anon();
+	if (!rss_anon_before) {
+		printf("No RssAnon is allocated before split\n");
+		exit(EXIT_FAILURE);
+	}
+
+	/* split all THPs */
+	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
+		      (uint64_t)one_page + len, 0);
+
+	for (i = 0; i < len; i++)
+		if (one_page[i] != (char)0) {
+			printf("%ld byte corrupted\n", i);
+			exit(EXIT_FAILURE);
+		}
+
+	if (!check_huge_anon(one_page, 0, pmd_pagesize)) {
+		printf("Still AnonHugePages not split\n");
+		exit(EXIT_FAILURE);
+	}
+
+	rss_anon_after = rss_anon();
+	if (rss_anon_after >= rss_anon_before) {
+		printf("Incorrect RssAnon value. Before: %ld After: %ld\n",
+		       rss_anon_before, rss_anon_after);
+		exit(EXIT_FAILURE);
+	}
+}
+
+void split_pmd_zero_pages(void)
+{
+	char *one_page;
+	int nr_hpages = 4;
+	size_t len = nr_hpages * pmd_pagesize;
+
+	one_page = allocate_zero_filled_hugepage(len);
+	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
+	printf("Split zero filled huge pages successful\n");
+	free(one_page);
+}
+
 void split_pmd_thp(void)
 {
 	char *one_page;
@@ -431,6 +501,7 @@ int main(int argc, char **argv)
 
 	fd_size = 2 * pmd_pagesize;
 
+	split_pmd_zero_pages();
 	split_pmd_thp();
 	split_pte_mapped_thp();
 	split_file_backed_thp();
--- a/tools/testing/selftests/mm/vm_util.c~mm-selftest-to-verify-zero-filled-pages-are-mapped-to-zeropage
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -12,6 +12,7 @@
 
 #define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
 #define SMAP_FILE_PATH "/proc/self/smaps"
+#define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
 
 unsigned int __page_size;
@@ -171,6 +172,27 @@ uint64_t read_pmd_pagesize(void)
 	return strtoul(buf, NULL, 10);
 }
 
+unsigned long rss_anon(void)
+{
+	unsigned long rss_anon = 0;
+	FILE *fp;
+	char buffer[MAX_LINE_LENGTH];
+
+	fp = fopen(STATUS_FILE_PATH, "r");
+	if (!fp)
+		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__, STATUS_FILE_PATH);
+
+	if (!check_for_pattern(fp, "RssAnon:", buffer, sizeof(buffer)))
+		goto err_out;
+
+	if (sscanf(buffer, "RssAnon:%10lu kB", &rss_anon) != 1)
+		ksft_exit_fail_msg("Reading status error\n");
+
+err_out:
+	fclose(fp);
+	return rss_anon;
+}
+
 bool __check_huge(void *addr, char *pattern, int nr_hpages,
 		  uint64_t hpage_size)
 {
--- a/tools/testing/selftests/mm/vm_util.h~mm-selftest-to-verify-zero-filled-pages-are-mapped-to-zeropage
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -39,6 +39,7 @@ unsigned long pagemap_get_pfn(int fd, ch
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
+unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
_

Patches currently in -mm which might be from alexlzhu@fb.com are


