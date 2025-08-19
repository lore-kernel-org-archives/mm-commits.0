Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BD913FEE
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 02:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755572127; cv=none; b=UdnuiwFj00yVadX0HSVNqgbeMQe+5Iabl40c2KBszC3I5j/jziEIrHf+1g66PORRkDXwIExhuyMsrrXQxWCFsRJDmmVpuodZry/X7O+ohSGQj8VrVQt4gDd/d+fh4s3YbuWEu0K/LXJGfJMQIaNhJDT6OkKumgZqw8xogAs0vTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755572127; c=relaxed/simple;
	bh=Jy068pAPdbTuY8pPW1Eg/cfAFwY5QC+Sek5vA/hvLEg=;
	h=Date:To:From:Subject:Message-Id; b=MLGjyx6KxsJfZ9P1hhUYrwK6oq7HxHwIYTMn1I9voV7qmnM9ZkOISZ/zLYcF4s7/uISZXjH2xxLcxJKx9x6oloTsYNSLuox1OzkCAVzOTfavnnkkOhq9cOBNbZjoz62CTc7urwDEVIlz6Tz6gPCjm+fSfN1vPadR721M6Y2K/4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C9MRJZyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C9MRJZyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F81C4CEED;
	Tue, 19 Aug 2025 02:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755572126;
	bh=Jy068pAPdbTuY8pPW1Eg/cfAFwY5QC+Sek5vA/hvLEg=;
	h=Date:To:From:Subject:From;
	b=C9MRJZypA2ljp6wcRjfoaYWq/h5jz0cSloEEnMJsjtg45uojIF6EnnXuBxxupW3jG
	 Y7q1XFL5BgXe1JbJx9WNrQoryP8I9YwDRGDpFhLnf/lIZs5FcapQ7vl1RKet53bQmd
	 mBS0CiBZ5BAbrMPVinWgq6uqc81IHGSIxVRjEVjI=
Date: Mon, 18 Aug 2025 19:55:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mark-all-functions-static-in-split_huge_page_testc.patch added to mm-new branch
Message-Id: <20250819025526.C3F81C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mark all functions static in split_huge_page_test.c
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-mark-all-functions-static-in-split_huge_page_testc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mark-all-functions-static-in-split_huge_page_testc.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: mark all functions static in split_huge_page_test.c
Date: Mon, 18 Aug 2025 14:46:19 -0400

All functions are only used within the file.

Link: https://lkml.kernel.org/r/20250818184622.1521620-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   22 ++++++------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-mark-all-functions-static-in-split_huge_page_testc
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -37,7 +37,7 @@ uint64_t pmd_pagesize;
 #define PFN_MASK     ((1UL<<55)-1)
 #define KPF_THP      (1UL<<22)
 
-int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
+static int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
 {
 	uint64_t paddr;
 	uint64_t page_flags;
@@ -135,7 +135,7 @@ static void verify_rss_anon_split_huge_p
 		       rss_anon_before, rss_anon_after);
 }
 
-void split_pmd_zero_pages(void)
+static void split_pmd_zero_pages(void)
 {
 	char *one_page;
 	int nr_hpages = 4;
@@ -147,7 +147,7 @@ void split_pmd_zero_pages(void)
 	free(one_page);
 }
 
-void split_pmd_thp_to_order(int order)
+static void split_pmd_thp_to_order(int order)
 {
 	char *one_page;
 	size_t len = 4 * pmd_pagesize;
@@ -181,7 +181,7 @@ void split_pmd_thp_to_order(int order)
 	free(one_page);
 }
 
-void split_pte_mapped_thp(void)
+static void split_pte_mapped_thp(void)
 {
 	char *one_page, *pte_mapped, *pte_mapped2;
 	size_t len = 4 * pmd_pagesize;
@@ -264,7 +264,7 @@ void split_pte_mapped_thp(void)
 	close(kpageflags_fd);
 }
 
-void split_file_backed_thp(int order)
+static void split_file_backed_thp(int order)
 {
 	int status;
 	int fd;
@@ -364,7 +364,7 @@ out:
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
-bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
+static bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
 		const char **thp_fs_loc)
 {
 	if (xfs_path) {
@@ -380,7 +380,7 @@ bool prepare_thp_fs(const char *xfs_path
 	return true;
 }
 
-void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
+static void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
 {
 	int status;
 
@@ -393,8 +393,8 @@ void cleanup_thp_fs(const char *thp_fs_l
 				   strerror(errno));
 }
 
-int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size, int *fd,
-		char **addr)
+static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
+		int *fd, char **addr)
 {
 	size_t i;
 	unsigned char buf[1024];
@@ -460,8 +460,8 @@ err_out_unlink:
 	return -1;
 }
 
-void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
-		int order, int offset)
+static void split_thp_in_pagecache_to_order_at(size_t fd_size,
+		const char *fs_loc, int order, int offset)
 {
 	int fd;
 	char *addr;
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-force_read-to-read-input-value-correctly.patch
mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch
selftests-mm-mark-all-functions-static-in-split_huge_page_testc.patch
selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch
selftests-mm-add-check_after_split_folio_orders-helper.patch
selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

