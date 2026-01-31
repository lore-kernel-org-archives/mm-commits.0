Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF303254BD
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 20:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769891419; cv=none; b=Pkv9x2qHO1ZhqGBxsbaDFbxb6ZLDGlGkPjlX8k24KeWx3yQoI/m8iiPiaTEPGNCFhCXrsDxL9XcBCcBQ0iWA8/qzyd48Y11dxPJ+zEU4/Eb9PAUWgG2cIi929kJ1p11o9jHCI+ut4hsNUyUuo5V2eDG/bbh/hKZw8sdxwmH/6h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769891419; c=relaxed/simple;
	bh=pOrZJv2tYmTkSjn7ShtiUuYL+GdRoOWODacRB2Pnl6o=;
	h=Date:To:From:Subject:Message-Id; b=JjH5q2DLxGbTLpyZUWGZZ7poCHUvfWP/B4//9BgizfVsmFX+3tlbTg7vWlJ9OiOmfwRuE59ASbubq7buRSkREVtb8pcpQQnUZ2eh+3PQ9f5x/h0w271Ia3+YO1r1l9ll2CTQxgGfzuW0HkFbR4hVx2+LXqRWaHvv1dIEkz86ocI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h+e8EId/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+e8EId/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83952C4CEF1;
	Sat, 31 Jan 2026 20:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769891418;
	bh=pOrZJv2tYmTkSjn7ShtiUuYL+GdRoOWODacRB2Pnl6o=;
	h=Date:To:From:Subject:From;
	b=h+e8EId/397/llGuslxYERn18gVp4EWRQGddjOLfoHRsFNt0DS596VkrWiJ/3mHFP
	 NBUmx8h7+ICgN8GLkFmatJ53z+DxcaWLwymJY8/NKVmR0jf3WghDluF5BlXJAx7x7k
	 SXfGYgNmrCmSqiIFYbla6J88YWbQQntXEbYAL7rI=
Date: Sat, 31 Jan 2026 12:30:17 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20260131203018.83952C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes
Date: Sat Jan 31 12:29:16 PM PST 2026

ERROR: code indent should use tabs where possible
#492: FILE: lib/maple_tree.c:3167:
+^I^I^I^I^I         slot_max, ma_pivots(mn, mt),$

ERROR: code indent should use tabs where possible
#493: FILE: lib/maple_tree.c:3168:
+^I^I^I^I^I         ma_slots(mn, mt));$

total: 2 errors, 0 warnings, 721 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/maple_tree-start-using-maple-copy-node-for-destination.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes
+++ a/lib/maple_tree.c
@@ -3164,8 +3164,8 @@ static inline void cp_dst_to_slots(struc
 		if (mt_is_alloc(mas->tree)) {
 			if (ma_is_leaf(mt)) {
 				cp->gap[d] = ma_leaf_max_gap(mn, mt, slot_min,
-					         slot_max, ma_pivots(mn, mt),
-					         ma_slots(mn, mt));
+						 slot_max, ma_pivots(mn, mt),
+						 ma_slots(mn, mt));
 			} else {
 				unsigned long *gaps = ma_gaps(mn, mt);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

