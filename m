Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1D829A0
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 05:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732944407; cv=none; b=gxLgn/MbXxrcLVxoCU5vjEBE6FpOpJp7Eirb+IUbM/FHjZJTtXX8d6vdNONnsMvrIZJkY+gEEEJsyk9o5IqCE31VIDR7m5x5x17+TeAJRo9ktgE04S9MuTleUZ/oJPe73Ucr2ZYsb2M5iVIQnNR0SeZum74slel3HxUJC46PXLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732944407; c=relaxed/simple;
	bh=ycYtZFJe+pvyRsAm3xvK186EGc/SvhpXEq8M5BCVEtA=;
	h=Date:To:From:Subject:Message-Id; b=FIUOHCNEKmHovTbWZCGtgnIdpjmFUuQKwSA0w8tjwZhMYezZk5GXxsAGnDYEM/scWvhUpIJ6kvmgS/m6rXBRQoejpkMOP6Buuiatv1OAr36O3N9Q0lbpg5uuB4mzb8mClM0n82+xCYdzIbZQpPfppet3fdPPj/UnNY6MzOWNLBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QJGf4bJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QJGf4bJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6651C4CECC;
	Sat, 30 Nov 2024 05:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732944406;
	bh=ycYtZFJe+pvyRsAm3xvK186EGc/SvhpXEq8M5BCVEtA=;
	h=Date:To:From:Subject:From;
	b=QJGf4bJc8oW3BCd8pP4fQUrpYBnogGVJ5U19vx3IDjh2slDo11m+csERdCU3rdonT
	 Fy2lO2xNXZcSrXgDElSHJgRbPLWnVMLHfzs79UfdTVZCFvnm8RlXeIw0djrnY19t9p
	 hQVbS0oijs+CjJRzoQcAzfmXDjrwJSdjOy90MwN0=
Date: Fri, 29 Nov 2024 21:26:46 -0800
To: mm-commits@vger.kernel.org,gaoxiang17@xiaomi.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch added to mm-unstable branch
Message-Id: <20241130052646.D6651C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch

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
Subject: mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix
Date: Fri Nov 29 09:23:51 PM PST 2024

tweak grammer, fit to 80 cols

Cc: gaoxiang17 <gaoxiang17@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix
+++ a/mm/page_alloc.c
@@ -1854,11 +1854,12 @@ static bool can_steal_fallback(unsigned
 		return true;
 
 	/*
-	 * movable pages won't cause permanent fragmentation, so when you alloc small pages,
-	 * you just need to temporarily steal unmovable or reclaimable pages that are closest
-	 * to the request size. After a while, memory compact may occur to form large contiguous
-	 * pages, and the next movable allocation may not need to steal. Unmovable and reclaimable
-	 * allocation need to actually steal pages.
+	 * Movable pages won't cause permanent fragmentation, so when you alloc
+	 * small pages, you just need to temporarily steal unmovable or
+	 * reclaimable pages that are closest to the request size.  After a
+	 * while, memory compaction may occur to form large contiguous pages,
+	 * and the next movable allocation may not need to steal.  Unmovable and
+	 * reclaimable allocations need to actually steal pages.
 	 */
 	if (order >= pageblock_order / 2 ||
 		start_mt == MIGRATE_RECLAIMABLE ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch

