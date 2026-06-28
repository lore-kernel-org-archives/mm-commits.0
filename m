Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2586830170F;
	Sun, 28 Jun 2026 20:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782680080; cv=none; b=CfAK6apLHHF286aJ9wX6Btu4uOnvkgw/p1Bwcygi+BGx7kaqklTefNSvy27TR+BB41ngEiW1BYGqp6G9P2CWTNQZLSmtgCZauveU2MUc5O73jGCVJJAUliyKbVAup8mm+hFAFR/mJiCwDR/sKL0F6AUsfDIFYi+v8CQRCqXqgks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782680080; c=relaxed/simple;
	bh=W3nTxPUBBu7vk++7MY27nuqUiphabA0nsJ3ThjqZlvc=;
	h=Date:To:From:Subject:Message-Id; b=VnsT85CKUZ0lx4f6TRvp1hdV+RQhxgj/HdqkKLOeJDQF8PEaCPImeNfEBjSaBRuiF9fD2PJX4/B77HFmJ5VWitk1oXNmYAKtanrGqJmZxvQ65SHYLMpn3HKoPAiDIrnjCqQPWEkBAVAhLD8mpt9kAnBUfpIUXixHW270+cE20WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w8SIBk2A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w8SIBk2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D64D1F00A3E;
	Sun, 28 Jun 2026 20:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782680078;
	bh=F9WtqoHTj2gG6PG2hrBF10wwZJs0ce7ZB6f8q44/kmg=;
	h=Date:To:From:Subject;
	b=w8SIBk2Am8E7XgqCFOlsVsdCBuCZo5Dw6FNYLaNSy8KLZCcRQ9djzWtcYX37oc1u3
	 n0l0f1ohwhIBqu0Bk2SCmMcwK6pHKUE/qQwPfhSO6BoZ3OZHoo25e4Yr7sxz8wEzaI
	 5Jo/n5q9lmqYO7lAkWxp2vDwummmCQVhlxwYNFbA=
Date: Sun, 28 Jun 2026 13:54:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,jianhuizzzzz@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-clear-uffd-wp-pte-state-when-re-registering-without-wp.patch added to mm-new branch
Message-Id: <20260628205438.8D64D1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: clear uffd-wp PTE state when re-registering without WP
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-clear-uffd-wp-pte-state-when-re-registering-without-wp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-clear-uffd-wp-pte-state-when-re-registering-without-wp.patch

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
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: mm/userfaultfd: clear uffd-wp PTE state when re-registering without WP
Date: Mon, 1 Jun 2026 16:26:09 +0800

UFFDIO_REGISTER can be issued on a range that is already registered in the
same userfaultfd context, replacing the VMA's userfaultfd tracking mode. 
For example, a range can be registered with UFFDIO_REGISTER_MODE_WP and
later re-registered with UFFDIO_REGISTER_MODE_MISSING.

When the second registration removes VM_UFFD_WP, the VMA flags are updated
but existing uffd-wp state in page-table entries is left behind.  That
stale state can survive in swap PTEs.  On swapin, do_swap_page() restores
_PAGE_UFFD_WP from the swap PTE and can then install a writable PTE,
triggering page_table_check:

  pte_uffd_wp(pte) && pte_write(pte)

Handle removal of WP mode through UFFDIO_REGISTER the same way as
UFFDIO_UNREGISTER: resolve the per-PTE uffd-wp state before dropping
VM_UFFD_WP from the VMA.

Also make the same-context fast path require an exact UFFD mode match. 
The old subset check treats MISSING|WP -> MISSING as a no-op, even though
WP mode is being removed.

Link: https://lore.kernel.org/20260601082609.170076-1-jianhuizzzzz@gmail.com
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
Reported-by: syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=18d274a59b87cf80e86d
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-clear-uffd-wp-pte-state-when-re-registering-without-wp
+++ a/mm/userfaultfd.c
@@ -2235,13 +2235,21 @@ static int userfaultfd_register_range(st
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
 			goto skip;
 
 		if (vma->vm_start > start)
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
+		/*
+		 * Re-registering into the same userfaultfd can remove WP mode.
+		 * Clear any per-PTE uffd-wp state before dropping VM_UFFD_WP,
+		 * matching the UFFDIO_UNREGISTER cleanup semantics.
+		 */
+		if (userfaultfd_wp(vma) && !(vm_flags & VM_UFFD_WP))
+			uffd_wp_range(vma, start, vma_end - start, false);
+
 		new_vma_flags = vma->flags;
 		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
 		vma_flags_set_mask(&new_vma_flags, vma_flags);
_

Patches currently in -mm which might be from jianhuizzzzz@gmail.com are

mm-userfaultfd-clear-uffd-wp-pte-state-when-re-registering-without-wp.patch

