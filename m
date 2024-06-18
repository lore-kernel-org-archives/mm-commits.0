Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912C916D4E4
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 21:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718744932; cv=none; b=Y64SpKHpPQ59MWEMpjCycA+HyukjkwzwzVZZJ0hxrWDtpq3bpR+LNrGOGYxDtCeMgmeOY/mp8JbQaLzwsztKQjOVc/9bDogANVPJifhn6V8MXRA1YRpd0lpogBU6wlr+FXXbagslDC+07CIni0wmu07Fg+7N6dWp2PxcxfgnZrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718744932; c=relaxed/simple;
	bh=oYR+ajeG3F0VoxpCkcRvz5Bn08FFJDuJivG/Xrds05k=;
	h=Date:To:From:Subject:Message-Id; b=FNcM9PAka66lrGuY4cRQqlukGNzKQNrL4PwYu+h0DmLU4/bkrCX+nFaaDph1cerHizJmHh8tDwRZgQFRX0H9kxgl1TD0dULIjmidHrpcu8uURbhNw804Srxw1pdN5PVPy1bW4RMG/5aF0Y1TD/F4zMfIVP+2QmQZ3FoSjb/Q+sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Vg8bQAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Vg8bQAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EAEC3277B;
	Tue, 18 Jun 2024 21:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718744932;
	bh=oYR+ajeG3F0VoxpCkcRvz5Bn08FFJDuJivG/Xrds05k=;
	h=Date:To:From:Subject:From;
	b=0Vg8bQAnTiRUHuVZ4jB3dptjXbd3iCyXokTnPGc6YMRBeIvOGHPFqam94P/lZdX3C
	 4aaeuUOynM8CpeEEith4D0EByHTOVXtbn+0PlrYXP7lyOx0rQEbLSAQnSJJ+Uz06oj
	 NammrgVqo4v7FoAncDBfuZZ/Rn64yrDIcUJU2qxM=
Date: Tue, 18 Jun 2024 14:08:51 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch added to mm-unstable branch
Message-Id: <20240618210851.F3EAEC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch

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
Subject: mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix
Date: Tue Jun 18 02:06:07 PM PDT 2024

comment fixes, per David and akpm

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    6 +++---
 mm/swapfile.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix
+++ a/mm/memory.c
@@ -4341,9 +4341,9 @@ check_folio:
 		folio_add_lru_vma(folio, vma);
 	} else if (!folio_test_anon(folio)) {
 		/*
-		 * We currently only expect small !anon folios, for which we now
-		 * that they are either fully exclusive or fully shared. If we
-		 * ever get large folios here, we have to be careful.
+		 * We currently only expect small !anon folios, which are either
+		 * fully exclusive or fully shared. If we ever get large folios
+		 * here, we have to be careful.
 		 */
 		VM_WARN_ON_ONCE(folio_test_large(folio));
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
--- a/mm/swapfile.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix
+++ a/mm/swapfile.c
@@ -1917,9 +1917,9 @@ static int unuse_pte(struct vm_area_stru
 		if (pte_swp_exclusive(old_pte))
 			rmap_flags |= RMAP_EXCLUSIVE;
 		/*
-		 * We currently only expect small !anon folios, for which we now that
-		 * they are either fully exclusive or fully shared. If we ever get
-		 * large folios here, we have to be careful.
+		 * We currently only expect small !anon folios, which are either
+		 * fully exclusive or fully shared. If we ever get large folios
+		 * here, we have to be careful.
 		 */
 		if (!folio_test_anon(folio)) {
 			VM_WARN_ON_ONCE(folio_test_large(folio));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch

