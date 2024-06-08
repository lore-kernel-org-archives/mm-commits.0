Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C52F9C8
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 04:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717820392; cv=none; b=cE+8F3CX2a4ljoeustp9xWTHRlE4qRAtlGq0Q3R4b0VNqS4XK0lln+Wx/96PlrqvXbY3pYCeSbqJYLL9fXrcWkfqPxAc1VfyhHsx/rUtjRJR/pKolXVo2ds/phzs7WiMMCYW8k0QG2DbbU1DLxFKnm42pQQwYyzL52tUWg4uEFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717820392; c=relaxed/simple;
	bh=l/VefjkCIc5G6A+HMK4VZHYbqdlt6Q88qqLhF1cDM9E=;
	h=Date:To:From:Subject:Message-Id; b=aGuFE27ywJw6BEFzJie+NLABITaivz4mWIJWbWsTISlvc8EtO6zEuwQUgebC0uOKSdTdYZymzTk0pyWtKUcs/gF/4gM3DuypBYZ/il1Qil0OkHSIZo3ZYifOl3GRi8FH1ck7xYMh81/QLDcMbHKqMq5heJps90y7tRqbGX6n+BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JQY49CG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JQY49CG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC953C2BD11;
	Sat,  8 Jun 2024 04:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717820391;
	bh=l/VefjkCIc5G6A+HMK4VZHYbqdlt6Q88qqLhF1cDM9E=;
	h=Date:To:From:Subject:From;
	b=JQY49CG788mkX3SsU3FKHW6KBwFW2g1pcAstU9raGt+MSZxhSLh0djyCymKBB3vJ0
	 NOdFQkQqL5oXDA0eVIz6HMfcGmC1SYvHs0FRL9bPhNncD9vE5SmYlWJDg3d2OS6khb
	 Erv+I9HHKCmUlumd7oxQwb4hLSN+CHiJo3N8JHQo=
Date: Fri, 07 Jun 2024 21:19:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,minchan@kernel.org,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch added to mm-unstable branch
Message-Id: <20240608041951.CC953C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: set pte writable while pte_soft_dirty() is true in do_swap_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: set pte writable while pte_soft_dirty() is true in do_swap_page()
Date: Sat, 8 Jun 2024 09:13:58 +1200

This patch leverages the new pte_needs_soft_dirty_wp() helper to optimize
a scenario where softdirty is enabled, but the softdirty flag has already
been set in do_swap_page().  In this situation, we can use pte_mkwrite
instead of applying write-protection since we don't depend on write
faults.

Link: https://lkml.kernel.org/r/20240607211358.4660-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page
+++ a/mm/memory.c
@@ -4322,7 +4322,7 @@ check_folio:
 	if (!folio_test_ksm(folio) &&
 	    (exclusive || folio_ref_count(folio) == 1)) {
 		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
-		    !vma_soft_dirty_enabled(vma)) {
+		    !pte_needs_soft_dirty_wp(vma, pte)) {
 			pte = pte_mkwrite(pte, vma);
 			if (vmf->flags & FAULT_FLAG_WRITE) {
 				pte = pte_mkdirty(pte);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch
mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch
mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch

