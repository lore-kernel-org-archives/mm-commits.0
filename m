Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC06E3C21
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2U4JMvxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85143C433C8;
	Mon, 11 Dec 2023 00:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256067;
	bh=VN1+OQJCeWAR6F5BQP4ciaHrdM7zKUelNPKvHcjPMLg=;
	h=Date:To:From:Subject:From;
	b=2U4JMvxvMN0Lc22UCDt9Pwgq4coBTjTi+yZAXOi/TIQJOSXrhNQb/Fg1QyBihig6M
	 0wHunHETVXr2arCqzL0ZShYHa27Q5kcjPKcR+yfLY0r0YvL1H0UJvRVF0/uO+1tTzP
	 tvcqBqiT5BqK95CxbU6JuKzVSI25N9dDsaUvdScA=
Date: Sun, 10 Dec 2023 16:54:27 -0800
To: mm-commits@vger.kernel.org,yjnworkstation@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-process_vm_rw-page-counts.patch removed from -mm tree
Message-Id: <20231211005427.85143C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix process_vm_rw page counts
has been removed from the -mm tree.  Its filename was
     mm-fix-process_vm_rw-page-counts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: York Jasper Niebuhr <yjnworkstation@gmail.com>
Subject: mm: fix process_vm_rw page counts
Date: Sat, 11 Nov 2023 19:48:59 +0100

1. There is a "-1" missing in the page number calculation in
   process_vm_rw_core.  While this can't break anything, it can cause
   unnecessary allocations in certain cases:

   Consider handling an iovec ranging over PVM_MAX_PP_ARRAY_COUNT pages
   that is also aligned to a page boundary.  While pp_stack could hold
   references to such an amount of pinned pages, nr_pages yields
   (PVM_MAX_PP_ARRAY + 1) in process_vm_rw_core.  Consequently, a larger
   buffer is allocated with kmalloc for no reason.

   For any page boundary aligned iovec that is a multiple of PAGE_SIZE
   and larger than PVM_MAX_PP_ARRAY_COUNT pages, nr_pages will be too big
   by 1 and thus kmalloc allocates excess space for one more pointer.

2. max_pages_per_loop is constant and there is no reason to have it as
   a variable.  A macro does the job just fine and saves memory.

3. Replaced "sizeof(struct pages *)" with "sizeof(struct page *)" to
   have matching types for allocation and prevent confusion.

Link: https://lkml.kernel.org/r/20231111184859.44264-1-yjnworkstation@gmail.com
Signed-off-by: York Jasper Niebuhr <yjnworkstation@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/process_vm_access.c~mm-fix-process_vm_rw-page-counts
+++ a/mm/process_vm_access.c
@@ -53,7 +53,10 @@ static int process_vm_rw_pages(struct pa
 }
 
 /* Maximum number of pages kmalloc'd to hold struct page's during copy */
-#define PVM_MAX_KMALLOC_PAGES (PAGE_SIZE * 2)
+#define PVM_MAX_KMALLOC_PAGES 2
+
+/* Maximum number of pages that can be stored at a time */
+#define PVM_MAX_USER_PAGES (PVM_MAX_KMALLOC_PAGES * PAGE_SIZE / sizeof(struct page *))
 
 /**
  * process_vm_rw_single_vec - read/write pages from task specified
@@ -79,8 +82,6 @@ static int process_vm_rw_single_vec(unsi
 	unsigned long start_offset = addr - pa;
 	unsigned long nr_pages;
 	ssize_t rc = 0;
-	unsigned long max_pages_per_loop = PVM_MAX_KMALLOC_PAGES
-		/ sizeof(struct pages *);
 	unsigned int flags = 0;
 
 	/* Work out address and page range required */
@@ -92,7 +93,7 @@ static int process_vm_rw_single_vec(unsi
 		flags |= FOLL_WRITE;
 
 	while (!rc && nr_pages && iov_iter_count(iter)) {
-		int pinned_pages = min(nr_pages, max_pages_per_loop);
+		int pinned_pages = min_t(unsigned long, nr_pages, PVM_MAX_USER_PAGES);
 		int locked = 1;
 		size_t bytes;
 
@@ -171,7 +172,7 @@ static ssize_t process_vm_rw_core(pid_t
 		iov_len = rvec[i].iov_len;
 		if (iov_len > 0) {
 			nr_pages_iov = ((unsigned long)rvec[i].iov_base
-					+ iov_len)
+					+ iov_len - 1)
 				/ PAGE_SIZE - (unsigned long)rvec[i].iov_base
 				/ PAGE_SIZE + 1;
 			nr_pages = max(nr_pages, nr_pages_iov);
@@ -184,8 +185,8 @@ static ssize_t process_vm_rw_core(pid_t
 	if (nr_pages > PVM_MAX_PP_ARRAY_COUNT) {
 		/* For reliability don't try to kmalloc more than
 		   2 pages worth */
-		process_pages = kmalloc(min_t(size_t, PVM_MAX_KMALLOC_PAGES,
-					      sizeof(struct pages *)*nr_pages),
+		process_pages = kmalloc(min_t(size_t, PVM_MAX_KMALLOC_PAGES * PAGE_SIZE,
+					      sizeof(struct page *)*nr_pages),
 					GFP_KERNEL);
 
 		if (!process_pages)
_

Patches currently in -mm which might be from yjnworkstation@gmail.com are


