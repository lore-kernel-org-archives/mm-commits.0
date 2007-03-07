From: akpm@linux-foundation.org
Subject: + exec-fix-remove_arg_zero-add-comment.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:42:08 -0800
Message-ID: <200703072242.l27Mg8Su011538@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992689AbXCGWmR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:42:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, npiggin@suse.de, ptesarik@suse.cz


The patch titled
     exec-fix-remove_arg_zero-add-comment
has been added to the -mm tree.  Its filename is
     exec-fix-remove_arg_zero-add-comment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ecryptfs-nested-locking-annotation.patch
nfs-fix-congestion-control-v4.patch
lists-add-list-splice-tail.patch
nfs-fix-congestion-control-use-atomic_longs.patch
exec-fix-remove_arg_zero-add-comment.patch
