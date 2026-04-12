Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F13C24887E;
	Sun, 12 Apr 2026 18:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776018032; cv=none; b=JRXWjsyKZPhbnaQbMeFAqwHtwFBx7pVKkDCC7z1gXIq6QWiXkB27OViZmeZrVAu1Lh/PKKpnpAyO2iisJ7GC0UvtuZELlZwFTF/gDxnXmbvay0gWhTnOwrsM3qgOZ73N+KCVvP6HQa+fykg3jyVI/oGCF6w+mYDpQSEhDYdB69M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776018032; c=relaxed/simple;
	bh=9Czmqd3eb98+d1QSSEbn5IBIcurm2VOS10riL38HgNY=;
	h=Date:To:From:Subject:Message-Id; b=YmCneShGOTnHBPKjETuXuyW7DH2DcJzUkgeu9bMA/2HL+oUgE5jTUNebQrebtA8PPy7zQleuZVFqugGU9gChzHzke+44kqiqdOYZBC7jLqoOcUZok4wzMxkom+tPSjQ6SU/NOpXJ43EPZwCo13moiRviDBQgfKsxny0xEiFGdGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ogUseO3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ogUseO3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C6CC19424;
	Sun, 12 Apr 2026 18:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776018031;
	bh=9Czmqd3eb98+d1QSSEbn5IBIcurm2VOS10riL38HgNY=;
	h=Date:To:From:Subject:From;
	b=ogUseO3ReFOsEzOqFjsGl0fjBkVzFj/5nr335XlSZwHVchy5amNADmwRcVbzZoHSC
	 ibpVnjbpvYfMDx5eMkd2d0FJC3wfsvJ+1QJPI5TC7d9S0Do+pk19+ISxh0EADkAuOj
	 FennaRG+9BcCeimskOCaeEikCAG+jP1jthJ5XUOg=
Date: Sun, 12 Apr 2026 11:20:25 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,aarcange@redhat.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-preserve-write-protection-across-uffdio_move.patch added to mm-hotfixes-unstable branch
Message-Id: <20260412182030.B7C6CC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: preserve write protection across UFFDIO_MOVE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-preserve-write-protection-across-uffdio_move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-preserve-write-protection-across-uffdio_move.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Gregory Price <gourry@gourry.net>
Subject: userfaultfd: preserve write protection across UFFDIO_MOVE
Date: Thu, 9 Apr 2026 11:28:22 -0400

move_present_ptes() unconditionally makes the destination PTE writable,
dropping uffd-wp write-protection from the source PTE.

The original intent was to follow mremap() behavior, but mremap()'s
move_ptes() preserves the source write state unconditionally.

Modify uffd to preserve the source write state and check the uffd-wp
condition of the source before setting writable on the destination.

Link: https://lkml.kernel.org/r/20260409152822.1073083-1-gourry@gourry.net
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-preserve-write-protection-across-uffdio_move
+++ a/mm/userfaultfd.c
@@ -1123,7 +1123,10 @@ static long move_present_ptes(struct mm_
 			orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 		if (pte_dirty(orig_src_pte))
 			orig_dst_pte = pte_mkdirty(orig_dst_pte);
-		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_write(orig_src_pte))
+			orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_uffd_wp(orig_src_pte))
+			orig_dst_pte = pte_mkuffd_wp(orig_dst_pte);
 		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 
 		src_addr += PAGE_SIZE;
_

Patches currently in -mm which might be from gourry@gourry.net are

userfaultfd-preserve-write-protection-across-uffdio_move.patch

