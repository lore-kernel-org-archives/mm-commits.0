Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E664E27470;
	Wed,  6 Aug 2025 22:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754518749; cv=none; b=pUq4k0XmEePrVOj8XvtaLn7JBxOsgFbMH3Ae7jTshYFTI7IJjQw8A30Q0KOS//87dp70fyEteRNoNf4/ZgoCG7QTumKcoJPUWlOyOyxdPPdX6zLRg5C5nvidobBIJyEELrQ/mZdOcFMq7oZpHX1qvx03tJPNz7ZCCREUyaw0SkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754518749; c=relaxed/simple;
	bh=0m1tghLmX6WNM0Yd8oXQ/+Crn7eUyCxjE9pVcNF36ec=;
	h=Date:To:From:Subject:Message-Id; b=aNTjjdT0LmOvcfS1OnZsJSMGJQFVLqpXLCAiJp6Ne2bvSWbPHMnJHVHdzN/tGvz/D9wbJu9EENXoS1PlRTe8rec094z7f/agKh5XC6XbVVu7ZG4rAt7pU5xC3+egGMNeMPz+uW1TP4ojHWpLIVXAwHGGiv/XvTGmBfR7M0j1qIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T8Xg04QE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T8Xg04QE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50836C4CEE7;
	Wed,  6 Aug 2025 22:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754518748;
	bh=0m1tghLmX6WNM0Yd8oXQ/+Crn7eUyCxjE9pVcNF36ec=;
	h=Date:To:From:Subject:From;
	b=T8Xg04QEGFLh6oQMLpHiX2cLCFMfoitp/iz2c0VHz+FQdUH53tHZdBeqP7i8mhaVi
	 e7v/PDbGRL3NZyAGluhhtH92+GA9H5obHZF8Yqem/DGh9huuJhVLlxuLWlbokKenKt
	 F1rSAU1dYpV5BFcmpXBS7RqslaoUAvNiidLdjj9U=
Date: Wed, 06 Aug 2025 15:19:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,lokeshgidra@google.com,david@redhat.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20250806221908.50836C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a migration entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a migration entry
Date: Wed, 6 Aug 2025 15:00:22 -0700

When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
obtaining a folio and accessing it even though the entry is swp_entry_t. 
Add the missing check and let split_huge_pmd() handle migration entries.

Link: https://lkml.kernel.org/r/20250806220022.926763-1-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry
+++ a/mm/userfaultfd.c
@@ -1821,13 +1821,16 @@ ssize_t move_pages(struct userfaultfd_ct
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
+				/* Can be a migration entry */
+				if (pmd_present(*src_pmd)) {
+					struct folio *folio = pmd_folio(*src_pmd);
 
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
-					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+					if (!folio || (!is_huge_zero_folio(folio) &&
+						       !PageAnonExclusive(&folio->page))) {
+						spin_unlock(ptl);
+						err = -EBUSY;
+						break;
+					}
 				}
 
 				spin_unlock(ptl);
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch
mm-limit-the-scope-of-vma_start_read.patch
mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch

