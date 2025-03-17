Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C98410E4
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742185867; cv=none; b=d8awYVmWNtx3HwJhII0/nd7YfOHJZH96R95qDYzT5K4+1g1s6UMljdwPXY8x4UX5KCllxyWylFkRvV23+mTFwVEUetSUJxciJoOVPPF1cCs/RtoWR/rVqyAGEL6LdWdWe3bLcZJ33IlGYQdihZBfLajIKSl7viteNYK+42g+duk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742185867; c=relaxed/simple;
	bh=IlVp1vQi0fPn493idhQnzfxlc3XvC5nA2d91igF6ts4=;
	h=Date:To:From:Subject:Message-Id; b=HKaRerGLGMEGtht0YApg1kA7X4bOO8Okw9pFziR9klhcytLPUSScwm+q3AsIAA6Y22oacG0Afs6ESUmpHfGbbfqONoJdRaOezax/fCSC6mf1N1z0bPJVXs0PqSXkFQENbgGYSvFrL0qZZni6ILNyeNWmw/6ZWWL+uuzJd4gGCyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=toUCS4Iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="toUCS4Iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C00C4CEEC;
	Mon, 17 Mar 2025 04:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742185866;
	bh=IlVp1vQi0fPn493idhQnzfxlc3XvC5nA2d91igF6ts4=;
	h=Date:To:From:Subject:From;
	b=toUCS4IwsAnzcAXslH27uqLuVkgK7zLtVJbdXh7c6YlbuqppRv8dE4iWB3izKl3yl
	 juavX/GC2/aapKXe2ceIX068mdWDVCoZ2wMqn31r3mExyYwZbH6lxsjJ6hV2tRGcYY
	 n/uVeDUx4ljlmtohM5/SqFfK9xxN0feXWCqFvGyI=
Date: Sun, 16 Mar 2025 21:31:06 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20250317043106.D1C00C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-madvise-split-out-mmap-locking-operations-for-madvise.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes
Date: Tue Feb 11 03:55:07 PM PST 2025

WARNING: suspect code indent for conditional statements (8, 12)
#57: FILE: mm/madvise.c:1598:
+	if (is_memory_failure(behavior))
+	    return 0;

WARNING: Statements should start on a tabstop
#58: FILE: mm/madvise.c:1599:
+	    return 0;

WARNING: suspect code indent for conditional statements (8, 12)
#72: FILE: mm/madvise.c:1612:
+	if (is_memory_failure(behavior))
+	    return;

WARNING: Statements should start on a tabstop
#73: FILE: mm/madvise.c:1613:
+	    return;

Please run checkpatch prior to sending patches

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes
+++ a/mm/madvise.c
@@ -1596,7 +1596,7 @@ static bool is_memory_failure(int behavi
 static int madvise_lock(struct mm_struct *mm, int behavior)
 {
 	if (is_memory_failure(behavior))
-	    return 0;
+		return 0;
 
 	if (madvise_need_mmap_write(behavior)) {
 		if (mmap_write_lock_killable(mm))
@@ -1610,7 +1610,7 @@ static int madvise_lock(struct mm_struct
 static void madvise_unlock(struct mm_struct *mm, int behavior)
 {
 	if (is_memory_failure(behavior))
-	    return;
+		return;
 
 	if (madvise_need_mmap_write(behavior))
 		mmap_write_unlock(mm);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

