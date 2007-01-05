From: akpm@osdl.org
Subject: + fix-oom-killing-of-swapoff.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:52:15 -0800
Message-ID: <200701052052.l05KqF9J032039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59641 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbXAEUws (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:52:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, stable@kernel.org


The patch titled
     fix OOM killing of swapoff
has been added to the -mm tree.  Its filename is
     fix-oom-killing-of-swapoff.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix OOM killing of swapoff
From: Hugh Dickins <hugh@veritas.com>

These days, if you swapoff when there isn't enough memory, OOM killer gives
"BUG: scheduling while atomic" and the machine hangs: badness() needs to do
its PF_SWAPOFF return after the task_unlock (tasklist_lock is also held
here, so p isn't going to be freed: PF_SWAPOFF might get turned off at any
moment, but that doesn't really matter).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/oom_kill.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~fix-oom-killing-of-swapoff mm/oom_kill.c
--- a/mm/oom_kill.c~fix-oom-killing-of-swapoff
+++ a/mm/oom_kill.c
@@ -61,12 +61,6 @@ unsigned long badness(struct task_struct
 	}
 
 	/*
-	 * swapoff can easily use up all memory, so kill those first.
-	 */
-	if (p->flags & PF_SWAPOFF)
-		return ULONG_MAX;
-
-	/*
 	 * The memory size of the process is the basis for the badness.
 	 */
 	points = mm->total_vm;
@@ -77,6 +71,12 @@ unsigned long badness(struct task_struct
 	task_unlock(p);
 
 	/*
+	 * swapoff can easily use up all memory, so kill those first.
+	 */
+	if (p->flags & PF_SWAPOFF)
+		return ULONG_MAX;
+
+	/*
 	 * Processes which fork a lot of child processes are likely
 	 * a good choice. We add half the vmsize of the children if they
 	 * have an own mm. This prevents forking servers to flood the
_

Patches currently in -mm which might be from hugh@veritas.com are

fix-bug_onpageslab-from-fallback_alloc.patch
fix-oom-killing-of-swapoff.patch
ext2-reservations.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
