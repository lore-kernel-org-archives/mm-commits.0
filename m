Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A511DE2A7
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 22:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758580395; cv=none; b=lk4pxJS2JRYo1cZQ3AuPYcStJvCn/UFwAvtqnrA42FYTtFxKe5wu528LocKVXZtgiij21thbZ+f23yHcPf8pAjIjz7nAp2aM7J42kOvHhlTlHO7K97szawjk5COZrpZ3sPF38QYjJQXtO9zxPXQxLKsJPDwANm7REypAD5y18ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758580395; c=relaxed/simple;
	bh=y0LE/kufETZkXiL0SJpNSwThic5bUI29UOsfYL9Il0Y=;
	h=Date:To:From:Subject:Message-Id; b=N+C1V3kdvik0N89UzS9o3rGICsvo/nkGNF2sXWjE/S+BMOeGofiTBb0lanhSzdTTS6r/CLEkTgWPmQ/Qk5CKUIagFehK/g09oJGRtPBbbtSUUpELyIcu54F3RmHKfrv93sAwKjXtE5a8VV6jPHPtsUgokcZjp2XGdylKq65UPbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ht6cFgxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ht6cFgxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E692C4CEF0;
	Mon, 22 Sep 2025 22:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758580395;
	bh=y0LE/kufETZkXiL0SJpNSwThic5bUI29UOsfYL9Il0Y=;
	h=Date:To:From:Subject:From;
	b=ht6cFgxaUdb13DwHXBcaSOmw9KBO4oWi97hF+HEq5oxn4PtkthwNOlUln1Q0QNo6P
	 ACkO3vpZw3Aj3QYDaIocDGIWZYZZu1UFozD5y4uESu+ZEk+SUbDOeLzAhkFJirbHin
	 AVLVS61Y3+hTt5FLLQMnDxviV7VtiWKj9eDNywu0=
Date: Mon, 22 Sep 2025 15:33:14 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-shmem-fix-too-little-space-for-tmpfs-only-fallback-4kb.patch removed from -mm tree
Message-Id: <20250922223315.1E692C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix too little space for tmpfs only fallback 4KB
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-too-little-space-for-tmpfs-only-fallback-4kb.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: shmem: fix too little space for tmpfs only fallback 4KB
Date: Mon, 8 Sep 2025 20:31:28 +0800

When the system memory is sufficient, allocating memory is always
successful, but when tmpfs size is low (e.g.  1MB), it falls back directly
from 2MB to 4KB, and other small granularity (8KB ~ 1024KB) will not be
tried.

Therefore add check whether the remaining space of tmpfs is sufficient for
allocation.  If there is too little space left, try smaller large folio.

Link: https://lkml.kernel.org/r/20250908123128.900254-1-vernon2gm@gmail.com
Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/shmem.c~mm-shmem-fix-too-little-space-for-tmpfs-only-fallback-4kb
+++ a/mm/shmem.c
@@ -1820,6 +1820,7 @@ static unsigned long shmem_suitable_orde
 					   unsigned long orders)
 {
 	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t aligned_index;
 	unsigned long pages;
 	int order;
@@ -1835,6 +1836,18 @@ static unsigned long shmem_suitable_orde
 	while (orders) {
 		pages = 1UL << order;
 		aligned_index = round_down(index, pages);
+
+		/*
+		 * Check whether the remaining space of tmpfs is sufficient for
+		 * allocation. If there is too little space left, try smaller
+		 * large folio.
+		 */
+		if (sbinfo->max_blocks && percpu_counter_read(&sbinfo->used_blocks)
+						+ pages > sbinfo->max_blocks) {
+			order = next_order(&orders, order);
+			continue;
+		}
+
 		/*
 		 * Check for conflict before waiting on a huge allocation.
 		 * Conflict might be that a huge page has just been allocated
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are


