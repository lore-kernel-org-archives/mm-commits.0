From: akpm@linux-foundation.org
Subject: + mempolicy-err_ptr-dereference-in-mpol_shared_policy_init.patch added to -mm tree
Date: Tue, 25 May 2010 15:01:29 -0700
Message-ID: <201005252201.o4PM1T4E017435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933004Ab0EYWCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 18:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com


The patch titled
     mempolicy: ERR_PTR dereference in mpol_shared_policy_init()
has been added to the -mm tree.  Its filename is
     mempolicy-err_ptr-dereference-in-mpol_shared_policy_init.patch

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
Subject: mempolicy: ERR_PTR dereference in mpol_shared_policy_init()
From: Dan Carpenter <error27@gmail.com>

The original code called mpol_put(new) while "new" was an ERR_PTR.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mempolicy-err_ptr-dereference-in-mpol_shared_policy_init mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-err_ptr-dereference-in-mpol_shared_policy_init
+++ a/mm/mempolicy.c
@@ -2098,7 +2098,7 @@ void mpol_shared_policy_init(struct shar
 		/* contextualize the tmpfs mount point mempolicy */
 		new = mpol_new(mpol->mode, mpol->flags, &mpol->w.user_nodemask);
 		if (IS_ERR(new))
-			goto put_free; /* no valid nodemask intersection */
+			goto free_scratch; /* no valid nodemask intersection */
 
 		task_lock(current);
 		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask, scratch);
@@ -2114,6 +2114,7 @@ void mpol_shared_policy_init(struct shar
 
 put_free:
 		mpol_put(new);			/* drop initial ref */
+free_scratch:
 		NODEMASK_SCRATCH_FREE(scratch);
 	}
 }
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
mempolicy-err_ptr-dereference-in-mpol_shared_policy_init.patch
linux-next.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
proc-cleanup-remove-unused-assignments.patch

