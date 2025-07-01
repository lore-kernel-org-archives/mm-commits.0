Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF9A263C6A
	for <mm-commits@vger.kernel.org>; Tue,  1 Jul 2025 20:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751402872; cv=none; b=M207CCIuvMTmVcxh6DJDAWA5HB6X5pTB/A+YEq0b1PssuJ6zANrygEoXwB+FdL23jjSrRTHHpGmMIX7INCVVzLv415ASLj5AdQhWr4FLqwPkkpLR8d5pDhsDHVj5xOrSND7WxsSavurSteDZ0WaTRdTctrPR73Tw4PkYvNOIdjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751402872; c=relaxed/simple;
	bh=ahWLHoIE5bu4hy65xufWyKcrmr+ubZYxJRs0x3WMKbU=;
	h=Date:To:From:Subject:Message-Id; b=h/sg0rvrVDFf7qbS9Zo8Ov3qqbPFYRLddE+PO1azMgl2GAvCKcFcKPzyKcQsqmi4pLq+Uq8fIz5zNWtS+EIEbPLqrmWZhGdGSOo/qrKByq+mLnlOfytuaYgcYzK8av0EYwcQueswocnQBROcHL/kT18ao1rGrVV4egeb8k3r8eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qb32Hs2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qb32Hs2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6BDC4CEEB;
	Tue,  1 Jul 2025 20:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751402871;
	bh=ahWLHoIE5bu4hy65xufWyKcrmr+ubZYxJRs0x3WMKbU=;
	h=Date:To:From:Subject:From;
	b=qb32Hs2k2iRZV9OfnaUDzrUAAv1BDei/kBwOLIF2EwLaZRNKynFxx4cZA63oc2Iy0
	 WVrgf4IWYExxC2zGA4VHFu9BLtTxPqSiSVsJqR+LOMSP1CkpnGFrr10hg1Gxs1Jpb0
	 tXOHP12M+nel5xLpXZWk2zUpfueZTBPv3LwSzXCk=
Date: Tue, 01 Jul 2025 13:47:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,tomas@vondra.me,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,bertranddrouvot.pg@gmail.com,apopple@nvidia.com,myon@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-do_pages_stat-in-32-bit-mode.patch added to mm-hotfixes-unstable branch
Message-Id: <20250701204751.DB6BDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: fix do_pages_stat in compat mode
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-fix-do_pages_stat-in-32-bit-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-do_pages_stat-in-32-bit-mode.patch

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
From: Christoph Berg <myon@debian.org>
Subject: mm/migrate: fix do_pages_stat in compat mode
Date: Tue, 24 Jun 2025 16:44:27 +0200

For arrays with more than 16 entries, the old code would incorrectly
advance the pages pointer by 16 words instead of 16 compat_uptr_t.  Fix by
doing the pointer arithmetic inside get_compat_pages_array where pages32
is already a correctly-typed pointer.

Discovered while working on PostgreSQL 18's new NUMA introspection code.

Link: https://lkml.kernel.org/r/aGREU0XTB48w9CwN@msg.df7cb.de
Fixes: 5b1b561ba73c ("mm: simplify compat_sys_move_pages")
Signed-off-by: Christoph Berg <myon@debian.org>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reported-by: Bertrand Drouvot <bertranddrouvot.pg@gmail.com>
Reported-by: Tomas Vondra <tomas@vondra.me>
Closes: https://www.postgresql.org/message-id/flat/6342f601-77de-4ee0-8c2a-3deb50ceac5b%40vondra.me#86402e3d80c031788f5f55b42c459471
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-migrate-fix-do_pages_stat-in-32-bit-mode
+++ a/mm/migrate.c
@@ -2399,6 +2399,7 @@ set_status:
 
 static int get_compat_pages_array(const void __user *chunk_pages[],
 				  const void __user * __user *pages,
+				  unsigned long chunk_offset,
 				  unsigned long chunk_nr)
 {
 	compat_uptr_t __user *pages32 = (compat_uptr_t __user *)pages;
@@ -2406,7 +2407,7 @@ static int get_compat_pages_array(const
 	int i;
 
 	for (i = 0; i < chunk_nr; i++) {
-		if (get_user(p, pages32 + i))
+		if (get_user(p, pages32 + chunk_offset + i))
 			return -EFAULT;
 		chunk_pages[i] = compat_ptr(p);
 	}
@@ -2425,27 +2426,28 @@ static int do_pages_stat(struct mm_struc
 #define DO_PAGES_STAT_CHUNK_NR 16UL
 	const void __user *chunk_pages[DO_PAGES_STAT_CHUNK_NR];
 	int chunk_status[DO_PAGES_STAT_CHUNK_NR];
+	unsigned long chunk_offset = 0;
 
 	while (nr_pages) {
 		unsigned long chunk_nr = min(nr_pages, DO_PAGES_STAT_CHUNK_NR);
 
 		if (in_compat_syscall()) {
 			if (get_compat_pages_array(chunk_pages, pages,
-						   chunk_nr))
+						   chunk_offset, chunk_nr))
 				break;
 		} else {
-			if (copy_from_user(chunk_pages, pages,
+			if (copy_from_user(chunk_pages, pages + chunk_offset,
 				      chunk_nr * sizeof(*chunk_pages)))
 				break;
 		}
 
 		do_pages_stat_array(mm, chunk_nr, chunk_pages, chunk_status);
 
-		if (copy_to_user(status, chunk_status, chunk_nr * sizeof(*status)))
+		if (copy_to_user(status + chunk_offset, chunk_status,
+				 chunk_nr * sizeof(*status)))
 			break;
 
-		pages += chunk_nr;
-		status += chunk_nr;
+		chunk_offset += chunk_nr;
 		nr_pages -= chunk_nr;
 	}
 	return nr_pages ? -EFAULT : 0;
_

Patches currently in -mm which might be from myon@debian.org are

mm-migrate-fix-do_pages_stat-in-32-bit-mode.patch

