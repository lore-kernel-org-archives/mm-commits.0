From: akpm@linux-foundation.org
Subject: + mempolicy-fix-dangling-reference-to-tmpfs-superblock-mpol.patch added to -mm tree
Date: Tue, 15 Jun 2010 12:22:55 -0700
Message-ID: <201006151922.o5FJMtBJ026124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138Ab0FOTX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jun 2010 15:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, cl@linux-foundation.org, error27@gmail.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com


The patch titled
     mempolicy: fix dangling reference to tmpfs superblock mpol
has been added to the -mm tree.  Its filename is
     mempolicy-fix-dangling-reference-to-tmpfs-superblock-mpol.patch

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
Subject: mempolicy: fix dangling reference to tmpfs superblock mpol
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

My patch to "Factor out duplicate put/frees in mpol_shared_policy_init()
to a common return path"; and Dan Carpenter's fix thereto both left a
dangling reference to the incoming tmpfs superblock mempolicy structure. 
A similar leak was introduced earlier when the nodemask was moved offstack
to the scratch area despite the note in the comment block regarding the
incoming ref.

Move the remaining 'put of the incoming "mpol" to the common exit path to
drop the reference.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-fix-dangling-reference-to-tmpfs-superblock-mpol mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-fix-dangling-reference-to-tmpfs-superblock-mpol
+++ a/mm/mempolicy.c
@@ -2094,7 +2094,7 @@ void mpol_shared_policy_init(struct shar
 		NODEMASK_SCRATCH(scratch);
 
 		if (!scratch)
-			return;
+			goto put_mpol;
 		/* contextualize the tmpfs mount point mempolicy */
 		new = mpol_new(mpol->mode, mpol->flags, &mpol->w.user_nodemask);
 		if (IS_ERR(new))
@@ -2103,19 +2103,20 @@ void mpol_shared_policy_init(struct shar
 		task_lock(current);
 		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask, scratch);
 		task_unlock(current);
-		mpol_put(mpol);	/* drop our ref on sb mpol */
 		if (ret)
-			goto put_free;
+			goto put_new;
 
 		/* Create pseudo-vma that contains just the policy */
 		memset(&pvma, 0, sizeof(struct vm_area_struct));
 		pvma.vm_end = TASK_SIZE;	/* policy covers entire file */
 		mpol_set_shared_policy(sp, &pvma, new); /* adds ref */
 
-put_free:
+put_new:
 		mpol_put(new);			/* drop initial ref */
 free_scratch:
 		NODEMASK_SCRATCH_FREE(scratch);
+put_mpol:
+		mpol_put(mpol);	/* drop our incoming ref on sb mpol */
 	}
 }
 
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

linux-next.patch
mempolicy-fix-dangling-reference-to-tmpfs-superblock-mpol.patch
topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage.patch

