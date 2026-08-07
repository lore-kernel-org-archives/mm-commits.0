Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64993B19A3
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068134; cv=none; b=WcRxi6s9EXcqVNp/MgCafY4/ORas/n5TIFhoN5Sapgm3F3ez6Th/0cdgyhKzlxFIjKSDrZ74kJCjXC/D/2Re3wUMIzvuFtQBc9+H3eFoXMCn+5z+mSvR1Lle3Mw3++D1WgQPE35+vKetl3mzzH9iMQ1bbCAsiNITBKiLu6y5KAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068134; c=relaxed/simple;
	bh=x3um0/7zRlA+hrIKki4QnHacFfj0yKvn8bqDenrqMwQ=;
	h=Date:To:From:Subject:Message-Id; b=bN8Baevl7eQcCHV1ddKIG61AzrzcpyvIr9lSlCcfEbjNDvTEsrhdoGnju9oizAqcr3xCjIVO8e/Zu2dQcLO5hBHB2RA1Yp7bDFPLGhM/iVwuwdAkCh4lUFlv+1ACbBrzr/Rl6yu0n6bnmnaJ8UT2EoTci18BkjGYCo0lkLRrLE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZTyE6fz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZTyE6fz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6D71F00A3E;
	Fri,  7 Aug 2026 02:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068133;
	bh=SKw+SPaxQT/9KxAagW+8TdPNrdKmMDuZjabBeV2/0Q8=;
	h=Date:To:From:Subject;
	b=ZTyE6fz3Aouizer0bu5hjsyWX2l1/J9XbQXgFnYgt0YyrJbNg/zCiTh7kpdB7tBGV
	 XA4VNXhLDGkMH7BY1EDyIuA5/UpnQ+U2Ih+H7iX75jiTz3CPuH1mex5TPOQ4uBmFah
	 NpV+Uw6NgVnH6XK9Xb6Bm15e2e/8f9LUYECQRMU8=
Date: Thu, 06 Aug 2026 19:02:12 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-make-hugepage_put_subpool-tolerate-null.patch removed from -mm tree
Message-Id: <20260807020213.2D6D71F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: make hugepage_put_subpool() tolerate NULL
has been removed from the -mm tree.  Its filename was
     hugetlb-make-hugepage_put_subpool-tolerate-null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: hugetlb: make hugepage_put_subpool() tolerate NULL
Date: Mon, 20 Jul 2026 15:38:41 +0800

Both callers of hugepage_put_subpool() check whether the subpool pointer
is NULL before calling it.  Move the NULL check into
hugepage_put_subpool() so callers can use the helper unconditionally.

This is a follow-up cleanup after using hugepage_put_subpool() from the
hugetlbfs_fill_super() failure path.

Link: https://lore.kernel.org/20260720073841.1389354-1-chenyichong@uniontech.com
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    6 ++----
 mm/hugetlb.c         |    3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-make-hugepage_put_subpool-tolerate-null
+++ a/fs/hugetlbfs/inode.c
@@ -1129,8 +1129,7 @@ static void hugetlbfs_put_super(struct s
 	if (sbi) {
 		sb->s_fs_info = NULL;
 
-		if (sbi->spool)
-			hugepage_put_subpool(sbi->spool);
+		hugepage_put_subpool(sbi->spool);
 
 		kfree(sbi);
 	}
@@ -1419,8 +1418,7 @@ hugetlbfs_fill_super(struct super_block
 		goto out_free;
 	return 0;
 out_free:
-	if (sbinfo->spool)
-		hugepage_put_subpool(sbinfo->spool);
+	hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
--- a/mm/hugetlb.c~hugetlb-make-hugepage_put_subpool-tolerate-null
+++ a/mm/hugetlb.c
@@ -182,6 +182,9 @@ void hugepage_put_subpool(struct hugepag
 {
 	unsigned long flags;
 
+	if (!spool)
+		return;
+
 	spin_lock_irqsave(&spool->lock, flags);
 	BUG_ON(!spool->count);
 	spool->count--;
_

Patches currently in -mm which might be from chenyichong@uniontech.com are


