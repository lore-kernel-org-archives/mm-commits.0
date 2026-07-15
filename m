Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ADD4534A2
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 17:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784135901; cv=none; b=EFpUAzsXwtxv2NNjAWTEjhAw913SRzZuDJgdPt25RXxtlsgfCKnhUNipM5Ya6yYki9eWHH2ZdZFo5gWJJXnG32hCR1MFUsfpniE4Lb0TomUq7Wto6pPZFhcn2SpOkg67uKmCr/KfAp5WSxzQtJHdUkX/21qkJrko/zFPNCwBJZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784135901; c=relaxed/simple;
	bh=aBO+BetGxvGvIEgVEx02C7dTddD/1cbNCoPYeWk4hwo=;
	h=Date:To:From:Subject:Message-Id; b=pmrzS6JZrMgmgE56A+63U9jyo7uPY7ljCkX26ZywYYN828TP1T8r1KUZ0zomov0otnIplDMGR0apSpEkcZSpPsh5k5+gEvRdCjnz0NuzYxs5IjwNgw9PYO9pxqtcfxRQnS+eVnuiogcRtld7M39VsZd3hHZSg8oUOwBsfXHt+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vEoAjjXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vEoAjjXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFCC1F000E9;
	Wed, 15 Jul 2026 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784135898;
	bh=BPoy8J4tDJN077ceiUg85//wI/23dXa8KRH9NWZpB78=;
	h=Date:To:From:Subject;
	b=vEoAjjXPJmx2ExOIwhVH8lGfNwY7VTDM3i2SzzON8KbE66xJGpMbANLBXBJgBw78b
	 rCYtYTvvLSFQCO32AZZoG5w5pQnfezxGl1FXAFhMTJQwLUEHbfxl6XY1aTztwnC2Rt
	 uqafy5UjQTi7zF1tSD0Dg1zE9tlFiwaGBRxTMv9s=
Date: Wed, 15 Jul 2026 10:18:18 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,sj@kernel.org,rdunlap@infradead.org,ljs@kernel.org,david@kernel.org,corbet@lwn.net,manuelebner@mailbox.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-fix-braces.patch added to mm-new branch
Message-Id: <20260715171818.9FFCC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm: Fix braces
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-fix-braces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-fix-braces.patch

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
From: Manuel Ebner <manuelebner@mailbox.org>
Subject: docs/mm: Fix braces
Date: Mon, 29 Jun 2026 18:11:56 +0200

Correct typos in mm documentation by balancing parentheses.

Link: https://lore.kernel.org/20260629161156.90213-2-manuelebner@mailbox.org
Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/hmm.rst           |    2 +-
 Documentation/mm/process_addrs.rst |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/hmm.rst~docs-mm-fix-braces
+++ a/Documentation/mm/hmm.rst
@@ -349,7 +349,7 @@ between device driver specific code and
    system memory and device private memory.
 
    One of the first steps migrate_vma_setup() does is to invalidate other
-   device's MMUs with the ``mmu_notifier_invalidate_range_start(()`` and
+   device's MMUs with the ``mmu_notifier_invalidate_range_start()`` and
    ``mmu_notifier_invalidate_range_end()`` calls around the page table
    walks to fill in the ``args->src`` array with PFNs to be migrated.
    The ``invalidate_range_start()`` callback is passed a
--- a/Documentation/mm/process_addrs.rst~docs-mm-fix-braces
+++ a/Documentation/mm/process_addrs.rst
@@ -724,7 +724,7 @@ the zap and the invocation of :c:func:`!
 
 Since it is assumed that all such steps have been taken, page table entries are
 cleared without page table locks (in the :c:func:`!pgd_clear`, :c:func:`!p4d_clear`,
-:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions.
+:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions).
 
 .. note:: It is possible for leaf page tables to be torn down independent of
           the page tables above it as is done by
_

Patches currently in -mm which might be from manuelebner@mailbox.org are

docs-mm-fix-braces.patch

