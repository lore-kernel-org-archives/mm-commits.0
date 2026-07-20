Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8985207A20
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784591008; cv=none; b=J1HPSozK8f8+n//YdIz2ppDj2BpcWKh0g/5uSwOtWEHOEVJgylaG4ftw1snUdcQMM1SOHb2XgWNkWw1q+8DbuaqJqKIhBDI4zAxHwubCpiyCLqRsnZhJbeos0zwftblcpyxfpKPfwE2W/twXGrubo9gxDCzX50BzPnGN2sinF4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784591008; c=relaxed/simple;
	bh=DtWKmL+HGkQgyqJl6KWXtAmqCYnkc6IxOlvYEvqUTkY=;
	h=Date:To:From:Subject:Message-Id; b=X8jEPCTEkh0Mv/kzD5Ooo23QkSasufXztlyi53S7sq/alHlFoUHpzIrObwrHR6970XDphVV62R+0do/zZ9h0v0RiK9ricxe3sCG6y5CSFvjgOb1le4iBfvCWGTBR7sfABY0KjEw7vtuHzw9h4/dgXAUa4h+gMh8t0GcS0wwzEw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vGKLX/ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vGKLX/ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542991F000E9;
	Mon, 20 Jul 2026 23:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784591006;
	bh=2WsNx265Cec0bsyHlnQCJbq0/6qh+5D9x5z25Ds0jpo=;
	h=Date:To:From:Subject;
	b=vGKLX/ulhcdEt7rkZV0shas4mRSSt+VlatAOwb4DqSNrm3xl2wYNfVA0F7H+Jj4xN
	 DGhtk1DT+jqwR4UXR9ILSNZKmWovu99axQc+QV8KruQ7xnHScn4mHetYy2vL32xRAs
	 uYPIIe6IOEK5rlD3kidT5PwsoM9D1BQtjPJ7dt+g=
Date: Mon, 20 Jul 2026 16:43:25 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mike.kravetz@oracle.com,david@kernel.org,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-make-hugepage_put_subpool-tolerate-null.patch added to mm-new branch
Message-Id: <20260720234326.542991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: make hugepage_put_subpool() tolerate NULL
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-make-hugepage_put_subpool-tolerate-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-make-hugepage_put_subpool-tolerate-null.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
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

tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch
hugetlbfs-release-subpool-on-fill_super-failure.patch
hugetlb-make-hugepage_put_subpool-tolerate-null.patch
fat-release-buffer-head-after-rebuilding-parent.patch

