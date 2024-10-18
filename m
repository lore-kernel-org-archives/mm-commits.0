Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F5416D4E6
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 21:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729288280; cv=none; b=mqlK8MgjfUdXnw7QY7xbcIqFpsa77rmlNLtjDxec59GL02LE1ZVPD4bsKqyHzVh2wztSj1x0+A1FWJqCafEPsqtw4cMei6G1arVe3zglyH/1vReK+IF7dG4Pg4W65uE7ptV42Y9T0tymPD0ZnaD9cvblKWZKBX+Jr6PeWhpaFsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729288280; c=relaxed/simple;
	bh=HsYckiNOt7JMZ0RsftXYKEEprkHL633mIqGmWyncjUY=;
	h=Date:To:From:Subject:Message-Id; b=QbPcsKoVvXGfaIrfHREdYj6dcQ7gZbykran7lqANS+k/os2UFjO1xHycSgwR8K/z79ngrc0QdDeY2Kasy/xgdWVs8RsSM//Q4npNn+0/DZ6xZKgGY+EkqgABrIj5jWelmWZmkiJocZP9kVfpPFckKyWFL1q8iR3idPy7tWUjvac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PY+QO8DI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PY+QO8DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776F1C4CEC3;
	Fri, 18 Oct 2024 21:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729288279;
	bh=HsYckiNOt7JMZ0RsftXYKEEprkHL633mIqGmWyncjUY=;
	h=Date:To:From:Subject:From;
	b=PY+QO8DIb/+NJ4PXwXn7lJvqGdBpIIA9T+mFD54YO2avJ8cj2s+3bGIl+AlODCOUS
	 fNf0M50KIdXixcClFwfzx8QIfG1i52JV/lSxJob6U4+VNdkdPyOo9IfU0EGJx577U7
	 Z8titgPy+YlnXH4O4+t5mePWrzLHXPZUVWPpwS74=
Date: Fri, 18 Oct 2024 14:51:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch added to mm-unstable branch
Message-Id: <20241018215119.776F1C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: update iocb->ki_pos directly to simplify tmpfs read logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch

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
Subject: mm: shmem: update iocb->ki_pos directly to simplify tmpfs read logic
Date: Fri, 18 Oct 2024 11:00:27 +0800

Patch series "Improve the tmpfs large folio read performance", v2.

tmpfs already supports PMD-sized large folios, but the tmpfs read
operation still performs copying at PAGE_SIZE granularity, which is not
perfect.  This patchset changes tmpfs to copy data at the folio
granularity, which can improve the read performance.

Use 'fio bs=64k' to read a 1G tmpfs file populated with 2M THPs, and I can
see about 20% performance improvement, and no regression with bs=4k.  I
also did some functional testing with the xfstests suite, and I did not
find any regressions with the following xfstests config:

  FSTYP=tmpfs
  export TEST_DIR=/mnt/tempfs_mnt
  export TEST_DEV=/mnt/tempfs_mnt
  export SCRATCH_MNT=/mnt/scratchdir
  export SCRATCH_DEV=/mnt/scratchdir


This patch (of 2):

Using iocb->ki_pos to check if the read bytes exceeds the file size and to
calculate the bytes to be read can help simplify the code logic. 
Meanwhile, this is also a preparation for improving tmpfs large folios
read performance in the following patch.

Link: https://lkml.kernel.org/r/cover.1729218573.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/e8863e289577e0dc1e365b5419bf2d1c9a24ae3d.1729218573.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

--- a/mm/shmem.c~mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic
+++ a/mm/shmem.c
@@ -3096,27 +3096,19 @@ static ssize_t shmem_file_read_iter(stru
 	unsigned long offset;
 	int error = 0;
 	ssize_t retval = 0;
-	loff_t *ppos = &iocb->ki_pos;
 
-	index = *ppos >> PAGE_SHIFT;
-	offset = *ppos & ~PAGE_MASK;
+	offset = iocb->ki_pos & ~PAGE_MASK;
 
 	for (;;) {
 		struct folio *folio = NULL;
 		struct page *page = NULL;
-		pgoff_t end_index;
 		unsigned long nr, ret;
-		loff_t i_size = i_size_read(inode);
+		loff_t end_offset, i_size = i_size_read(inode);
 
-		end_index = i_size >> PAGE_SHIFT;
-		if (index > end_index)
+		if (unlikely(iocb->ki_pos >= i_size))
 			break;
-		if (index == end_index) {
-			nr = i_size & ~PAGE_MASK;
-			if (nr <= offset)
-				break;
-		}
 
+		index = iocb->ki_pos >> PAGE_SHIFT;
 		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
 		if (error) {
 			if (error == -EINVAL)
@@ -3138,18 +3130,14 @@ static ssize_t shmem_file_read_iter(stru
 		 * We must evaluate after, since reads (unlike writes)
 		 * are called without i_rwsem protection against truncate
 		 */
-		nr = PAGE_SIZE;
 		i_size = i_size_read(inode);
-		end_index = i_size >> PAGE_SHIFT;
-		if (index == end_index) {
-			nr = i_size & ~PAGE_MASK;
-			if (nr <= offset) {
-				if (folio)
-					folio_put(folio);
-				break;
-			}
+		if (unlikely(iocb->ki_pos >= i_size)) {
+			if (folio)
+				folio_put(folio);
+			break;
 		}
-		nr -= offset;
+		end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
+		nr = min_t(loff_t, end_offset - iocb->ki_pos, PAGE_SIZE - offset);
 
 		if (folio) {
 			/*
@@ -3189,8 +3177,8 @@ static ssize_t shmem_file_read_iter(stru
 
 		retval += ret;
 		offset += ret;
-		index += offset >> PAGE_SHIFT;
 		offset &= ~PAGE_MASK;
+		iocb->ki_pos += ret;
 
 		if (!iov_iter_count(to))
 			break;
@@ -3201,7 +3189,6 @@ static ssize_t shmem_file_read_iter(stru
 		cond_resched();
 	}
 
-	*ppos = ((loff_t) index << PAGE_SHIFT) + offset;
 	file_accessed(file);
 	return retval ? retval : error;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch
mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch
mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch

