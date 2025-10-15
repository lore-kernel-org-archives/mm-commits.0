Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31431EBFE0
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 00:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760489996; cv=none; b=RJeaY5yOENOZwqd5BRFRfWRHv3wJRAR9zL3DSRS0Q0TUJrbo1NlclHOIG3zxkB8/KaQMO2KXKutS8egIwtDUfK4NKc5A5DXCTtBYe+fS5aprNXC/kOuL6+qFXG4eaMV0gR/yHV/nN5XV3CCdi108KNm34dg5Eb84dTTuGdAxwv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760489996; c=relaxed/simple;
	bh=k60RSILyGhaEicl+EAFgFQfqvxNHjbfJ9RqsFkHzoA4=;
	h=Date:To:From:Subject:Message-Id; b=UPplN8r+GcU1YBfIijlfExZjjDa3r+zScXN3PQjGqEKIwftgCdSf0qMOyTgS/VNx9y3nIiCroz+PV5d5mS5CJnPsFE/zJ5ojbvrFNcCbUiNJ5o8Codz8I8OD80/nkn0VtA73G07lp2gGVION+Tg1LKtr/hAFoCydT86DMCcK3QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=anBF/WSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="anBF/WSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA31C4CEE7;
	Wed, 15 Oct 2025 00:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760489996;
	bh=k60RSILyGhaEicl+EAFgFQfqvxNHjbfJ9RqsFkHzoA4=;
	h=Date:To:From:Subject:From;
	b=anBF/WSLKg6UgSfBg4Dd6Oy7wqtPB00vX1yfWFDekephurtutsnGeN8hvo0SFVYM3
	 FFJpAJXIPuR0KzHz5pVvt2VLlg6n46Wx9vKJu1z9Ggl8UtNyc6m2D9bgFKB1KH8tYI
	 sHjqIXEa/8v+YVQf/9xNRgen2aNllY6qM/hHHBaE=
Date: Tue, 14 Oct 2025 17:59:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,cl@gentwo.org,bigeasy@linutronix.de,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempool-clarify-behavior-of-mempool_alloc_preallocated.patch added to mm-new branch
Message-Id: <20251015005955.EAA31C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mempool: clarify behavior of mempool_alloc_preallocated()
has been added to the -mm mm-new branch.  Its filename is
     mempool-clarify-behavior-of-mempool_alloc_preallocated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempool-clarify-behavior-of-mempool_alloc_preallocated.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: mempool: clarify behavior of mempool_alloc_preallocated()
Date: Tue, 14 Oct 2025 14:17:23 +0200

The documentation of that function promises to never sleep.  However on
PREEMPT_RT a spinlock_t might in fact sleep.

Reword the documentation so users can predict its behavior better.

mempool could also replace spinlock_t with raw_spinlock_t which doesn't
sleep even on PREEMPT_RT but that would take away the improved
preemptibility of sleeping locks.

Link: https://lkml.kernel.org/r/20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempool.c~mempool-clarify-behavior-of-mempool_alloc_preallocated
+++ a/mm/mempool.c
@@ -461,8 +461,8 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
  *             mempool_create().
  *
  * This function is similar to mempool_alloc, but it only attempts allocating
- * an element from the preallocated elements. It does not sleep and immediately
- * returns if no preallocated elements are available.
+ * an element from the preallocated elements. It only takes a single spinlock_t
+ * and immediately returns if no preallocated elements are available.
  *
  * Return: pointer to the allocated element or %NULL if no elements are
  * available.
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

mempool-clarify-behavior-of-mempool_alloc_preallocated.patch
compiler-remove-arch_sel.patch

