From: akpm@linux-foundation.org
Subject: - exec-fix-remove_arg_zero-add-comment.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:29:44 -0700
Message-ID: <200704301929.l3UJTiRT012878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946726AbXD3TaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:30:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, npiggin@suse.de, ptesarik@suse.cz, mm-commits@vger.kernel.org


The patch titled
     exec-fix-remove_arg_zero-add-comment
has been removed from the -mm tree.  Its filename was
     exec-fix-remove_arg_zero-add-comment.patch

This patch was dropped because it was folded into exec-fix-remove_arg_zero.patch

------------------------------------------------------
Subject: exec-fix-remove_arg_zero-add-comment
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Add Peter's comment to Nick's patch.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~exec-fix-remove_arg_zero-add-comment fs/exec.c
--- a/fs/exec.c~exec-fix-remove_arg_zero-add-comment
+++ a/fs/exec.c
@@ -982,9 +982,13 @@ void compute_creds(struct linux_binprm *
 	task_unlock(current);
 	security_bprm_post_apply_creds(bprm);
 }
-
 EXPORT_SYMBOL(compute_creds);
 
+/*
+ * Arguments are '\0' separated strings found at the location bprm->p
+ * points to; chop off the first by relocating brpm->p to right after
+ * the first '\0' encountered.
+ */
 void remove_arg_zero(struct linux_binprm *bprm)
 {
 	if (bprm->argc) {
@@ -1023,7 +1027,6 @@ void remove_arg_zero(struct linux_binprm
 		bprm->argc--;
 	}
 }
-
 EXPORT_SYMBOL(remove_arg_zero);
 
 /*
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
mm-remove-destroy_dirty_buffers-from-invalidate_bdev.patch
mm-optimize-kill_bdev.patch
mm-optimize-acorn-partition-truncate.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
exec-fix-remove_arg_zero.patch
exec-fix-remove_arg_zero-add-comment.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
nfs-fix-congestion-control-use-atomic_longs.patch
