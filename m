From: akpm@linux-foundation.org
Subject: + mm-revalidate-anon_vma-in-page_lock_anon_vma.patch added to -mm tree
Date: Thu, 08 Apr 2010 16:46:15 -0700
Message-ID: <201004082346.o38NkFAH016047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934033Ab0DHXrH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 19:47:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, hugh.dickins@tiscali.co.uk, riel@redhat.com, torvalds@linux-foundation.org


The patch titled
     mm: revalidate anon_vma in page_lock_anon_vma()
has been added to the -mm tree.  Its filename is
     mm-revalidate-anon_vma-in-page_lock_anon_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: revalidate anon_vma in page_lock_anon_vma()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

There is nothing preventing the anon_vma from being detached while we are
spinning to acquire the lock.  Most (all?) current users end up calling
something like vma_address(page, vma) on it, which has a fairly good
chance of weeding out wonky vmas.

However suppose the anon_vma got freed and re-used while we were waiting
to acquire the lock, and the new anon_vma fits with the page->index
(because that is the only thing vma_address() uses to determine if the
page fits in a particular vma, we could end up traversing faulty anon_vma
chains.

Close this hole for good by re-validating that page->mapping still holds
the very same anon_vma pointer after we acquire the lock, if not be
utterly paranoid and retry the whole operation (which will very likely
bail, because it's unlikely the page got attached to a different anon_vma
in the meantime).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/rmap.c~mm-revalidate-anon_vma-in-page_lock_anon_vma mm/rmap.c
--- a/mm/rmap.c~mm-revalidate-anon_vma-in-page_lock_anon_vma
+++ a/mm/rmap.c
@@ -294,6 +294,7 @@ struct anon_vma *page_lock_anon_vma(stru
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
+again:
 	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
@@ -302,6 +303,12 @@ struct anon_vma *page_lock_anon_vma(stru
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
 	spin_lock(&anon_vma->lock);
+
+	if (page_rmapping(page) != anon_vma) {
+		spin_unlock(&anon_vma->lock);
+		goto again;
+	}
+
 	return anon_vma;
 out:
 	rcu_read_unlock();
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
x86-remove-last-traces-of-quicklist-usage.patch
powerpc-add-rcu_read_lock-to-gup_fast-implementation.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch
mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
kernel-user-remove-unreachable-code.patch
bitops-optimize-hweight-by-making-use-of-compile-time-evaluation.patch
x86-add-optimized-popcnt-variants.patch

