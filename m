Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8E7189915
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854832; cv=none; b=ENzLv4oxCMHveGszoI6hoFu48qF6vn467xEd1DsaE7h05dxe+v3IVXBBqCH5J1StTQwuS66SYtQK1fwCLVlKbh3y+9i4X0Zsm/Lsffu9owLnbnIrEkQsr+ab7ywzmdjZjNq1h1vDEeG4Ppp2uP0k843/LcApBu7fp+u2jg/D+Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854832; c=relaxed/simple;
	bh=gXi1U2dE/dqm+ecoGx/GOtZ5NrrcgoIZ7FD+LUi9i40=;
	h=Date:To:From:Subject:Message-Id; b=BpHyMmQEovaMfgKD4MzoZscGTirxiBfbn/lLFUdLLI8oHFKnSth9bAxSGnyEr99I5JVOKbu7iEMlXvP8lQOq6eR0ayXH9kU5cODTIJo9vFBgHnLsCv2yrHTmhbSKImlg7tdeijlxjc3KvKQrkCW0aKS3WUrQQIREYXnFYS4pMdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tMJi464a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tMJi464a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8413FC4CED5;
	Wed,  6 Nov 2024 01:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854832;
	bh=gXi1U2dE/dqm+ecoGx/GOtZ5NrrcgoIZ7FD+LUi9i40=;
	h=Date:To:From:Subject:From;
	b=tMJi464aHRLlzSrmG1a3CijTmc8StzWP4m+KGBIgeTWeqbd0O1kQg+KtgATyCLVcC
	 FjbYdPZXHF8Iv+4zLtsTpQK9HncxDKE6MFrNptCZ5zCCrQcJigrH1GIdXR6O1kWu4D
	 0XtOEUsavLSG4yP9CTKB6xUoLmbh2dDnRknvt34g=
Date: Tue, 05 Nov 2024 17:00:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch removed from -mm tree
Message-Id: <20241106010032.8413FC4CED5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: update iocb->ki_pos directly to simplify tmpfs read logic
has been removed from the -mm tree.  Its filename was
     mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3093,27 +3093,19 @@ static ssize_t shmem_file_read_iter(stru
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
@@ -3135,18 +3127,14 @@ static ssize_t shmem_file_read_iter(stru
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
@@ -3186,8 +3174,8 @@ static ssize_t shmem_file_read_iter(stru
 
 		retval += ret;
 		offset += ret;
-		index += offset >> PAGE_SHIFT;
 		offset &= ~PAGE_MASK;
+		iocb->ki_pos += ret;
 
 		if (!iov_iter_count(to))
 			break;
@@ -3198,7 +3186,6 @@ static ssize_t shmem_file_read_iter(stru
 		cond_resched();
 	}
 
-	*ppos = ((loff_t) index << PAGE_SHIFT) + offset;
 	file_accessed(file);
 	return retval ? retval : error;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


