Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107D125E82A
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 23:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740611052; cv=none; b=YSH2lp62JEZ65sfEz85WR73dMAYmS1zL1I+ltAAOplNautvql6POO13f7KA10FUZ4pPTy/tdLUSS322kHgp/4fzN6ccjVrqEUA2I1Mri5FlInsD27+oRldrKpd8pH5hRH8hCzqX1nlD7W8SYrrLUYuMwhCSMyVdCZLNXjoOfjfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740611052; c=relaxed/simple;
	bh=eJZ3ZJG5taxSwmk9QCq3b7oN9QblZhP9jPMON/hqeRE=;
	h=Date:To:From:Subject:Message-Id; b=iUa2F+JRZig7KKGgsnM4iFM2+faCdTqwG1wd9Hc8mWNbtJbJOg1GKfbkl2LXosDGBv2xjEP7/HFaLXT3FmNvq7z5GoLzMTHe7ezqyZiPPc1muxQ2Hs1F+Hvz/ua92eom21gj/hvlgECMjvX2FxTwqsS8evL+hWbCm4FeASZLZhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NBTnip4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NBTnip4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD64C4CED6;
	Wed, 26 Feb 2025 23:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740611051;
	bh=eJZ3ZJG5taxSwmk9QCq3b7oN9QblZhP9jPMON/hqeRE=;
	h=Date:To:From:Subject:From;
	b=NBTnip4eEqGwUN3GxPUKiz9lez8bpWzjdgVBeSPE0eidlnOws+hdXxBDif4wT+J3X
	 xkpxJzlrLE4wKV2IKaloaUXxBLJamLpK93YE+eyoAeQEm+sD7LWv+Tcp9hP38OKRO0
	 3YYAjXEbjCNxyusXst/KjhUW65QhEMKqZRIrYp+0=
Date: Wed, 26 Feb 2025 15:04:10 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250226230411.5AD64C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: minor cleanup according to Peter Xu
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Barry Song <v-songbaohua@oppo.com>
Subject: minor cleanup according to Peter Xu
Date: Wed, 26 Feb 2025 15:22:17 +1300

According to Peter Xu:
1. Unnecessary line move.
2. Can drop this folio check as it just did check
   "!IS_ERR_OR_NULL(folio)"
3. Not sure if it can do any harm, but maybe still nicer
   to put swap before locking folio.

Link: https://lkml.kernel.org/r/20250226024411.47092-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/userfaultfd.c~mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache-fix
+++ a/mm/userfaultfd.c
@@ -1105,8 +1105,8 @@ static int move_swap_pte(struct mm_struc
 
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
-
 	double_pt_unlock(dst_ptl, src_ptl);
+
 	return 0;
 }
 
@@ -1373,7 +1373,7 @@ retry:
 			folio = filemap_get_folio(swap_address_space(entry),
 					swap_cache_index(entry));
 		if (!IS_ERR_OR_NULL(folio)) {
-			if (folio && folio_test_large(folio)) {
+			if (folio_test_large(folio)) {
 				err = -EBUSY;
 				folio_put(folio);
 				goto out;
@@ -1384,10 +1384,10 @@ retry:
 				pte_unmap(&orig_src_pte);
 				pte_unmap(&orig_dst_pte);
 				src_pte = dst_pte = NULL;
-				/* now we can block and wait */
-				folio_lock(src_folio);
 				put_swap_device(si);
 				si = NULL;
+				/* now we can block and wait */
+				folio_lock(src_folio);
 				goto retry;
 			}
 		}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache.patch
mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache-fix.patch
mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch
mm-support-tlbbatch-flush-for-a-range-of-ptes.patch
mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch
mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch

