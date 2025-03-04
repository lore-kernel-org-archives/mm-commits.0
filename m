Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A36E17555
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741046759; cv=none; b=O8xYyfa77kaA+E0BYbFQ0P9RoaTW4R7VkwoLlFIVVaaDkxkIYeGKoMHH1jFq67RYPn/dUVp+Fx7AUJuy6c2P1sFf1XHJZr7LI9xC0aONOA/z9cqZCkIpQRx+c+xnpYcrvDKUvNYW0WdvaX0eRIToJie3+DoHx5v6mC2XIlw9lSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741046759; c=relaxed/simple;
	bh=hetTTqxc3KZN7BBbwFIqjxfoGp6vSJ652JD2X6qmJ74=;
	h=Date:To:From:Subject:Message-Id; b=CGacidSsosGxaUjFYvXugV4ZFiZnE7+mRdWsmwYqfoa67/cQN2/Sc3OvirDMdvYs+7OOCx0atuuIHrdtAjqq3gcJP8Sb3XdzbWIDsQY6J9ghaHOJKmrfPeiGJ6tYEvUSmNBlKJSdbUyaF3SRwBVklHBTm2yqL2Rm3beSu3a8dL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j9rYTHSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j9rYTHSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8B2C4CEE8;
	Tue,  4 Mar 2025 00:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741046759;
	bh=hetTTqxc3KZN7BBbwFIqjxfoGp6vSJ652JD2X6qmJ74=;
	h=Date:To:From:Subject:From;
	b=j9rYTHStx88USLcCIFcszIIJQFBANGl7lEhBBA9nbt15AIdBRuRBt/S4NLjQIDcY3
	 ayRbpnUKajX2sVrf2t/wJWSisFU9tbacvcr3UEfikvR3yzL5wTil2fLxsPe4UC52Jb
	 WrhcZB9+rMT6QTtMHQbwFgnnAPJKQFpnr19LXIVs=
Date: Mon, 03 Mar 2025 16:05:58 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,lkp@intel.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-thread-state-through-move-page-table-operation-fix.patch added to mm-unstable branch
Message-Id: <20250304000559.0A8B2C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mremap-thread-state-through-move-page-table-operation-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-thread-state-through-move-page-table-operation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-thread-state-through-move-page-table-operation-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mremap-thread-state-through-move-page-table-operation-fix
Date: Mon Mar  3 04:03:07 PM PST 2025

fix move_huge_pud() stub

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503040759.5zpJdC2i-lkp@intel.com/
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-thread-state-through-move-page-table-operation-fix
+++ a/mm/mremap.c
@@ -475,8 +475,9 @@ static bool move_huge_pud(struct pagetab
 	return true;
 }
 #else
-static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
-			  unsigned long new_addr, pud_t *old_pud, pud_t *new_pud)
+static bool move_huge_pud(struct pagetable_move_control *pmc,
+			  unsigned long old_addr, unsigned long new_addr,
+			  pud_t *old_pud, pud_t *new_pud)
 {
 	WARN_ON_ONCE(1);
 	return false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-mremap-thread-state-through-move-page-table-operation-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

