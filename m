Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DABB18E030
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 21:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729288281; cv=none; b=XB6jWv314wpaxUAPmrh2XFhqpliBUK+WlhJe3HRTFZDLA7xCNuMuv/AlZyGpYEXNGB2caj7+8F51BwjPEyLgd+MZSOblsK0RLVBgdge10eCE+H7lFELaF3c3ZrW+QXWGvTEW1Gk8Rm6co0LT4+2bYs0oi0v46OL6Qnbk4r3KPVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729288281; c=relaxed/simple;
	bh=CxxMAP1zbEJyQXpRLF4TRLcyssqvvsrTsGnewJ2bOQI=;
	h=Date:To:From:Subject:Message-Id; b=QZWqVdVAjjaiAUcLy9xsJ0f7rKc6xurDFZSxEhTPXoTP9YmRlK1HXipdW9aNpKrNWxBJQVvosr5Oj0KzeBXy4/cnDpqlssxwT2uVF83gsae7mYfnTNQfFFiogvc8gWuclxcL+p9oW13G4El6OycRnGjosrJaKRmxeCTwUNfqb5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZUucqAme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZUucqAme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE939C4CEC3;
	Fri, 18 Oct 2024 21:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729288280;
	bh=CxxMAP1zbEJyQXpRLF4TRLcyssqvvsrTsGnewJ2bOQI=;
	h=Date:To:From:Subject:From;
	b=ZUucqAmejO5ExZkGvp+TGTjA1mWY6yIJMNj1P/YcY0OeXksQno9exW55vzlcjuSOv
	 SYYRVTTN4+9Q7A8LNdSFRGtUzNmuaHrPPcKgNMGrOJfTbQYI0TVJkSLeFrCYqoS5Nw
	 FKVykOq1A5i88l4AzfVgZt84aS7+FCelvqFF5blo=
Date: Fri, 18 Oct 2024 14:51:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch added to mm-unstable branch
Message-Id: <20241018215120.CE939C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: improve the tmpfs large folio read performance
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch

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
Subject: mm: shmem: improve the tmpfs large folio read performance
Date: Fri, 18 Oct 2024 11:00:28 +0800

tmpfs already supports PMD-sized large folios, but the tmpfs read
operation still performs copying at PAGE_SIZE granularity, which is
unreasonable.  This patch changes tmpfs to copy data at folio granularity,
which can improve the read performance, as well as changing to use folio
related functions.

Moreover, if a large folio has a subpage that is hwpoisoned, it will
still fall back to page granularity copying.

Use 'fio bs=64k' to read a 1G tmpfs file populated with 2M THPs, and I can
see about 20% performance improvement, and no regression with bs=4k.
Before the patch:
READ: bw=10.0GiB/s

After the patch:
READ: bw=12.0GiB/s

Link: https://lkml.kernel.org/r/2129a21a5b9f77d3bb7ddec152c009ce7c5653c4.1729218573.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/mm/shmem.c~mm-shmem-improve-the-tmpfs-large-folio-read-performance
+++ a/mm/shmem.c
@@ -3097,13 +3097,13 @@ static ssize_t shmem_file_read_iter(stru
 	int error = 0;
 	ssize_t retval = 0;
 
-	offset = iocb->ki_pos & ~PAGE_MASK;
-
 	for (;;) {
 		struct folio *folio = NULL;
 		struct page *page = NULL;
 		unsigned long nr, ret;
 		loff_t end_offset, i_size = i_size_read(inode);
+		bool fallback_page_copy = false;
+		size_t fsize;
 
 		if (unlikely(iocb->ki_pos >= i_size))
 			break;
@@ -3124,6 +3124,10 @@ static ssize_t shmem_file_read_iter(stru
 				error = -EIO;
 				break;
 			}
+
+			if (folio_test_large(folio) &&
+			    folio_test_has_hwpoisoned(folio))
+				fallback_page_copy = true;
 		}
 
 		/*
@@ -3137,7 +3141,12 @@ static ssize_t shmem_file_read_iter(stru
 			break;
 		}
 		end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
-		nr = min_t(loff_t, end_offset - iocb->ki_pos, PAGE_SIZE - offset);
+		if (folio && likely(!fallback_page_copy))
+			fsize = folio_size(folio);
+		else
+			fsize = PAGE_SIZE;
+		offset = iocb->ki_pos & (fsize - 1);
+		nr = min_t(loff_t, end_offset - iocb->ki_pos, fsize - offset);
 
 		if (folio) {
 			/*
@@ -3145,10 +3154,15 @@ static ssize_t shmem_file_read_iter(stru
 			 * virtual addresses, take care about potential aliasing
 			 * before reading the page on the kernel side.
 			 */
-			if (mapping_writably_mapped(mapping))
-				flush_dcache_page(page);
+			if (mapping_writably_mapped(mapping)) {
+				if (likely(!fallback_page_copy))
+					flush_dcache_folio(folio);
+				else
+					flush_dcache_page(page);
+			}
+
 			/*
-			 * Mark the page accessed if we read the beginning.
+			 * Mark the folio accessed if we read the beginning.
 			 */
 			if (!offset)
 				folio_mark_accessed(folio);
@@ -3156,9 +3170,11 @@ static ssize_t shmem_file_read_iter(stru
 			 * Ok, we have the page, and it's up-to-date, so
 			 * now we can copy it to user space...
 			 */
-			ret = copy_page_to_iter(page, offset, nr, to);
+			if (likely(!fallback_page_copy))
+				ret = copy_folio_to_iter(folio, offset, nr, to);
+			else
+				ret = copy_page_to_iter(page, offset, nr, to);
 			folio_put(folio);
-
 		} else if (user_backed_iter(to)) {
 			/*
 			 * Copy to user tends to be so well optimized, but
@@ -3176,8 +3192,6 @@ static ssize_t shmem_file_read_iter(stru
 		}
 
 		retval += ret;
-		offset += ret;
-		offset &= ~PAGE_MASK;
 		iocb->ki_pos += ret;
 
 		if (!iov_iter_count(to))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch
mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch
mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch

