Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E0B32C85
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 05:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806610; cv=none; b=WKJM0DQPm7GpKRGD/pE0Sq2J2bGJPIDUttx4lCzGQ9Kej7jIBHVjbVTyfj0vH51QBOrdBk6OpAyYZN4Cx1nHm8b7rsii0wM4z2bZPcS+mw0w4tAWdxUGAH9Nx0iCpvOMV9NvEF1h5FYKcKmFs37uCmvOCPNlJXuRVaqXzEvKhJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806610; c=relaxed/simple;
	bh=Gd5LslFNnLLEfwnngYCNJX2D/XXtA7JeKVtVX05835o=;
	h=Date:To:From:Subject:Message-Id; b=W8CqYqvoE3NtVTkLuRkWiz4kzdhlW2j6YxGGx/6z857ylBnELMV1uRjcbVL31s1P12z/1hf10UxLj5mGMgcCjvsHSWsQuw4/10IMUqGHYiyC0Q/yj9wuVENVb803kDzkRTbaoeaXOGkrIVs1JJ8Rj67NuCfFHom6KZc3YjDjiPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rD9xkY8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rD9xkY8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39888C4CEE4;
	Wed, 21 May 2025 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806610;
	bh=Gd5LslFNnLLEfwnngYCNJX2D/XXtA7JeKVtVX05835o=;
	h=Date:To:From:Subject:From;
	b=rD9xkY8POERPzdWE4q/7Z80J3y/vUJYvYkHEWvply8KWBccOdh9DnK8Z8iYJf1QO+
	 7ivanjbJkFwFY3dvGTgTO4WcRxwNAzjOyOKCsjSdH1o+Sz3saAqblX2mnfvcJFLEYK
	 dDyVpAv2m7NSfHmSVTOw1Fv9+C7KjqcL5JmOexdM=
Date: Tue, 20 May 2025 22:50:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangerkun@huawei.com,willy@infradead.org,wangkefeng.wang@huawei.com,yi.zhang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-truncate-fix-out-of-bounds-when-doing-a-right-aligned-split.patch removed from -mm tree
Message-Id: <20250521055010.39888C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/truncate: fix out-of-bounds when doing a right-aligned split
has been removed from the -mm tree.  Its filename was
     mm-truncate-fix-out-of-bounds-when-doing-a-right-aligned-split.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: mm/truncate: fix out-of-bounds when doing a right-aligned split
Date: Mon, 12 May 2025 14:28:25 +0800

When performing a right split on a folio, the split_at2 may point to a
not-present page if the offset + length equals the original folio size,
which will trigger the following error:

 BUG: unable to handle page fault for address: ffffea0006000008
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 143ffb9067 P4D 143ffb9067 PUD 143ffb8067 PMD 0
 Oops: Oops: 0000 [#1] SMP PTI
 CPU: 0 UID: 0 PID: 502640 Comm: fsx Not tainted 6.15.0-rc3-gc6156189fc6b #889 PR
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/4
 RIP: 0010:truncate_inode_partial_folio+0x208/0x620
 Code: ff 03 48 01 da e8 78 7e 13 00 48 83 05 10 b5 5a 0c 01 85 c0 0f 85 1c 02 001
 RSP: 0018:ffffc90005bafab0 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: ffffea0005ffff00 RCX: 0000000000000002
 RDX: 000000000000000c RSI: 0000000000013975 RDI: ffffc90005bafa30
 RBP: ffffea0006000000 R08: 0000000000000000 R09: 00000000000009bf
 R10: 00000000000007e0 R11: 0000000000000000 R12: 0000000000001633
 R13: 0000000000000000 R14: ffffea0005ffff00 R15: fffffffffffffffe
 FS:  00007f9f9a161740(0000) GS:ffff8894971fd000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffffea0006000008 CR3: 000000017c2ae000 CR4: 00000000000006f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  truncate_inode_pages_range+0x226/0x720
  truncate_pagecache+0x57/0x90
  ...

Fix this issue by skipping the split if truncation aligns with the folio
size, make sure the split page number lies within the folio.

Link: https://lkml.kernel.org/r/20250512062825.3533342-1-yi.zhang@huaweicloud.com
Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: ErKun Yang <yangerkun@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/truncate.c~mm-truncate-fix-out-of-bounds-when-doing-a-right-aligned-split
+++ a/mm/truncate.c
@@ -191,6 +191,7 @@ int truncate_inode_folio(struct address_
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 {
 	loff_t pos = folio_pos(folio);
+	size_t size = folio_size(folio);
 	unsigned int offset, length;
 	struct page *split_at, *split_at2;
 
@@ -198,14 +199,13 @@ bool truncate_inode_partial_folio(struct
 		offset = start - pos;
 	else
 		offset = 0;
-	length = folio_size(folio);
-	if (pos + length <= (u64)end)
-		length = length - offset;
+	if (pos + size <= (u64)end)
+		length = size - offset;
 	else
 		length = end + 1 - pos - offset;
 
 	folio_wait_writeback(folio);
-	if (length == folio_size(folio)) {
+	if (length == size) {
 		truncate_inode_folio(folio->mapping, folio);
 		return true;
 	}
@@ -224,16 +224,20 @@ bool truncate_inode_partial_folio(struct
 		return true;
 
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	split_at2 = folio_page(folio,
-			PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
-
 	if (!try_folio_split(folio, split_at, NULL)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
 		 * for shmem truncate
 		 */
-		struct folio *folio2 = page_folio(split_at2);
+		struct folio *folio2;
+
+		if (offset + length == size)
+			goto no_split;
+
+		split_at2 = folio_page(folio,
+				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
+		folio2 = page_folio(split_at2);
 
 		if (!folio_try_get(folio2))
 			goto no_split;
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


