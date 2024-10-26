Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24CD170A1B
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729983785; cv=none; b=aPnljJJ7swX8CWqzwblMO7pYkfEo0R9If2VG4j4teIvLaupZDrMjENDN/rktNWVHYKpq455/HYpEq75oXaAg8JDqjvwgjCd7Y1GblHjXiLLxu2uQVJGkVE5i99nMDUQLn40QDLC0Q1s63ZHZUqAXkN7pkgfqI3PxR1uneXpZzHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729983785; c=relaxed/simple;
	bh=twCXAKNy3ME8X5CCT+3C53fadCPI+DVDKUhB1qqGd2k=;
	h=Date:To:From:Subject:Message-Id; b=QsqrTcrmzERSU+Cr+TjFgRl9HrKutnO7fa5T7v7++SOn6WkDsVJGWHXlPalu5RocTN6LibuFjAfK9fo46FmQWdEXVvrUTnSSkiNQqqo/BY08P5y2uJ0JWSXFf11lXjMKPBjidU8w8W+9tKSJQVDFs1M9xm9hHbAxp8dqNtLbXT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d94GhV+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d94GhV+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32360C4CEC6;
	Sat, 26 Oct 2024 23:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729983785;
	bh=twCXAKNy3ME8X5CCT+3C53fadCPI+DVDKUhB1qqGd2k=;
	h=Date:To:From:Subject:From;
	b=d94GhV+JmCMHLtiAQRljgGmjfMI4kcEChz8ajZYrWekPFM9cNpdgHDd6vu0WFJB1v
	 W9f7rrkpmeB8btH2/O7SgOGslKelzjUlPHd7lGw63Yco8yEPvzSh/Tlu5pi+XqALC+
	 wUXoyFNuZcXH7tH757W1hZlTuCrf1YOe6x9+tbT8=
Date: Sat, 26 Oct 2024 16:03:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch added to mm-unstable branch
Message-Id: <20241026230305.32360C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fallback to page size splice if large folio has poisoned pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fallback to page size splice if large folio has poisoned pages
Date: Sat, 26 Oct 2024 21:51:52 +0800

The tmpfs has already supported the PMD-sized large folios, and splice()
can not read any pages if the large folio has a poisoned page, which is
not good as Matthew pointed out in a previous email[1]:

"so if we have hwpoison set on one page in a folio, we now can't read
bytes from any page in the folio?  That seems like we've made a bad
situation worse."

Thus add a fallback to the PAGE_SIZE splice() still allows reading normal
pages if the large folio has hwpoisoned pages.

[1] https://lore.kernel.org/all/Zw_d0EVAJkpNJEbA@casper.infradead.org/
Link: https://lkml.kernel.org/r/e3737fbd5366c4de4337bf5f2044817e77a5235b.1729915173.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

--- a/mm/shmem.c~mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages
+++ a/mm/shmem.c
@@ -3291,11 +3291,16 @@ static ssize_t shmem_file_splice_read(st
 	len = min_t(size_t, len, npages * PAGE_SIZE);
 
 	do {
+		bool fallback_page_splice = false;
+		struct page *page = NULL;
+		pgoff_t index;
+		size_t size;
+
 		if (*ppos >= i_size_read(inode))
 			break;
 
-		error = shmem_get_folio(inode, *ppos / PAGE_SIZE, 0, &folio,
-					SGP_READ);
+		index = *ppos >> PAGE_SHIFT;
+		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
 		if (error) {
 			if (error == -EINVAL)
 				error = 0;
@@ -3304,12 +3309,15 @@ static ssize_t shmem_file_splice_read(st
 		if (folio) {
 			folio_unlock(folio);
 
-			if (folio_test_hwpoison(folio) ||
-			    (folio_test_large(folio) &&
-			     folio_test_has_hwpoisoned(folio))) {
+			page = folio_file_page(folio, index);
+			if (PageHWPoison(page)) {
 				error = -EIO;
 				break;
 			}
+
+			if (folio_test_large(folio) &&
+			    folio_test_has_hwpoisoned(folio))
+				fallback_page_splice = true;
 		}
 
 		/*
@@ -3323,7 +3331,18 @@ static ssize_t shmem_file_splice_read(st
 		isize = i_size_read(inode);
 		if (unlikely(*ppos >= isize))
 			break;
-		part = min_t(loff_t, isize - *ppos, len);
+		/*
+		 * Fallback to PAGE_SIZE splice if the large folio has hwpoisoned
+		 * pages.
+		 */
+		if (likely(!fallback_page_splice)) {
+			size = len;
+		} else {
+			size_t offset = *ppos & ~PAGE_MASK;
+
+			size = min_t(loff_t, PAGE_SIZE - offset, len);
+		}
+		part = min_t(loff_t, isize - *ppos, size);
 
 		if (folio) {
 			/*
@@ -3331,8 +3350,12 @@ static ssize_t shmem_file_splice_read(st
 			 * virtual addresses, take care about potential aliasing
 			 * before reading the page on the kernel side.
 			 */
-			if (mapping_writably_mapped(mapping))
-				flush_dcache_folio(folio);
+			if (mapping_writably_mapped(mapping)) {
+				if (likely(!fallback_page_splice))
+					flush_dcache_folio(folio);
+				else
+					flush_dcache_page(page);
+			}
 			folio_mark_accessed(folio);
 			/*
 			 * Ok, we have the page, and it's up-to-date, so we can
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch
mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch
mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch
mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch

