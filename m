Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2AB18A6A3
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854833; cv=none; b=THX9EKZTe1bWv31xsebEh34R+fdstmeP08BZlFbBsJdOFpI4qYWvf0ArYjPAOuBGRavox3Ic7vx3+laAvnClJHZzxDTKJ7AFU+BS1zB4lwCIFVfCYUIjzVpaI3eowKhGJxQPHpQQLyYd8M4mAV4lK1nciD8bhFwV9KFBF0Krt2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854833; c=relaxed/simple;
	bh=U8lRzfxtmeX/hQYHtJ+DMXWShhKNJp8k4FlSkoJtiWg=;
	h=Date:To:From:Subject:Message-Id; b=r9l6R9trnpGM4nsGEErr1cxkKHKzr28Ud6VKyhYvJ60Tmhf+69XrzfX55zTgR0gxnGMrJDX3w3+t/Ctktz8JnIiKmPadttYBsu1UpkpWyjXR7pyOAfp6h53HU9/zsxZZDDG2VgWIoalYHXlDykQ1KCuaiZR4IGg65MWkRR0UWLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Luwl+tmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Luwl+tmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34FBC4CED2;
	Wed,  6 Nov 2024 01:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854833;
	bh=U8lRzfxtmeX/hQYHtJ+DMXWShhKNJp8k4FlSkoJtiWg=;
	h=Date:To:From:Subject:From;
	b=Luwl+tmMftEQ0Xb2ap22sIUGPdTBKAHD1t2FXv6kIorkMTCd4Voiuo3LEKkWY+88w
	 RzVA45+fLLibqPMxJS6UX2K+LMFQzDQdXujJgkfLukuOkU7AkV2nHE7c6wG3DFhnfn
	 3FqUCe3zd6oTjDHXOqgHDBnf/oNRGtn73KEiV1MU=
Date: Tue, 05 Nov 2024 17:00:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch removed from -mm tree
Message-Id: <20241106010033.A34FBC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: improve the tmpfs large folio read performance
has been removed from the -mm tree.  Its filename was
     mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3094,13 +3094,13 @@ static ssize_t shmem_file_read_iter(stru
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
@@ -3121,6 +3121,10 @@ static ssize_t shmem_file_read_iter(stru
 				error = -EIO;
 				break;
 			}
+
+			if (folio_test_large(folio) &&
+			    folio_test_has_hwpoisoned(folio))
+				fallback_page_copy = true;
 		}
 
 		/*
@@ -3134,7 +3138,12 @@ static ssize_t shmem_file_read_iter(stru
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
@@ -3142,10 +3151,15 @@ static ssize_t shmem_file_read_iter(stru
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
@@ -3153,9 +3167,11 @@ static ssize_t shmem_file_read_iter(stru
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
@@ -3173,8 +3189,6 @@ static ssize_t shmem_file_read_iter(stru
 		}
 
 		retval += ret;
-		offset += ret;
-		offset &= ~PAGE_MASK;
 		iocb->ki_pos += ret;
 
 		if (!iov_iter_count(to))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


