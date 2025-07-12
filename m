Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDB122E402
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 23:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752362576; cv=none; b=Ako1E+ZDPPGV/91I6OnDjym/2DJVj9rsXATvyqQ7q71s0qN/PRdeUeO1ipBoxLwSUVMOjcjzephmiEcvp0LZgj7JyE7bsqT++VyBswyqAa42Jsz5N3C0zERxeyNKyvGE7DSGI8CMv+l+uDFErAYbR6yWmHniW4A+QQ1VlKtXZBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752362576; c=relaxed/simple;
	bh=UyJx27ohwm/K4udNJUROvMP8LcVyyayNefutfv7rE5Y=;
	h=Date:To:From:Subject:Message-Id; b=NKglIW2Qpyrq2gKEN9oKPxFoVKnvQeAdvBXVJsL1ctyOS+uRxj1M8ZH+8TgP8/zOF3kRAc602l7xXcc616g68cw6GQeahT0HsWQ+6p/gvKRV9uWiLtpLjX6pluzOWn1jLcnxhtvFCfR/iLf+4QVY+unXCA73RQZUYLZhxxOc0ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WRS/xJK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRS/xJK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5AEC4CEEF;
	Sat, 12 Jul 2025 23:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752362575;
	bh=UyJx27ohwm/K4udNJUROvMP8LcVyyayNefutfv7rE5Y=;
	h=Date:To:From:Subject:From;
	b=WRS/xJK5nOIi9c5fGGzWW+rqcvd3aj2sxIBZuyrMP2VGrWDqsCIWeRaR94JzchECs
	 atHmg8xQvQmbAXSIUPRTkryDl12Aiz0jliK1Zk6PO7NhkNQhTasqSvOLUCHfaN2Z3M
	 t+zVvUJX/cXwa8cxc5ar3k11rEAaIJ3lKSew5bF0=
Date: Sat, 12 Jul 2025 16:22:55 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch added to mm-unstable branch
Message-Id: <20250712232255.DB5AEC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-swap-simplify-swapin-path-and-result-handling-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch

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
Subject: mm-shmem-swap-simplify-swapin-path-and-result-handling-fix
Date: Sat Jul 12 04:21:54 PM PDT 2025

fix comment, per Baolin

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-swap-simplify-swapin-path-and-result-handling-fix
+++ a/mm/shmem.c
@@ -2321,7 +2321,7 @@ static int shmem_swapin_folio(struct ino
 		}
 
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
-			/* Direct mTHP swapin skipping swap cache & readhaed */
+			/* Direct swapin skipping swap cache & readhaed */
 			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
 			if (IS_ERR(folio)) {
 				error = PTR_ERR(folio);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

