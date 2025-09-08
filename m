Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C2A1B87F2
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 23:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757373746; cv=none; b=bCAnt2o3mlwIiOxGStkqPddykTbgxY2Y/B2VOctU0sR28Wda/gLFjc7ZuefyQqi4NjScC7UOOKg2abXh14UzLRKBqN2b2tOSprQtzo2206G7FfgnTtcvrbQP0cdc5uuzmjrtV9NY5U6TNx2qbqCbNai29nHTnNfFmETvJpXUmyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757373746; c=relaxed/simple;
	bh=bakZ8elQXuZvrsJ27dcGa04TSRf2xdA1fSsMyR3Twuo=;
	h=Date:To:From:Subject:Message-Id; b=pMzpn82OtWDBBXeetk7TUBcJS/JexSc21Y8v/UmeD3W0a6RQzPYzojSMqAAYXrh2RE/7Bqc9WdtMJEQZ2GaGv2q74WqVu/N06bgnpcMRleSd7OJBbmv/rxILq2TdRnuyiNGGr4Zel2rNCMF99dmtQqmaipWyibD/rQJGR2GBw+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BdDNfcn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BdDNfcn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D240C4CEF1;
	Mon,  8 Sep 2025 23:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757373745;
	bh=bakZ8elQXuZvrsJ27dcGa04TSRf2xdA1fSsMyR3Twuo=;
	h=Date:To:From:Subject:From;
	b=BdDNfcn80q6yu8KmIjsuuaP7qsq2DGJAYF78oySg1g2tglowVk/KEsgeTTD8PZdtp
	 tMI3maTxBN/MSq2CF47ql5GEvF4w4qWPVnWL7EUOcM9RGbdFPW/tmZFRm2NJOcXuuo
	 d68PQRyWIhv21yoTre4qsVyw2bF8vza/oLKCttmQ=
Date: Mon, 08 Sep 2025 16:22:24 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-too-little-space-for-tmpfs-only-fallback-4kb.patch added to mm-new branch
Message-Id: <20250908232225.7D240C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix too little space for tmpfs only fallback 4KB
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-fix-too-little-space-for-tmpfs-only-fallback-4kb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-too-little-space-for-tmpfs-only-fallback-4kb.patch

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

mm-shmem-fix-too-little-space-for-tmpfs-only-fallback-4kb.patch

