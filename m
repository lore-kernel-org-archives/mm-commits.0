From: akpm@linux-foundation.org
Subject: + cgroups-fix-2632-regression-causing-bug_on-in-cgroup_diput.patch added to -mm tree
Date: Wed, 30 Dec 2009 15:36:29 -0800
Message-ID: <200912302336.nBUNaTnR008502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbZL3Xhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 18:37:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anderson@redhat.com, bblum@andrew.cmu.edu, lizf@cn.fujitsu.com, menage@google.com, stable@kernel.org


The patch titled
     cgroups: fix 2.6.32 regression causing BUG_ON() in cgroup_diput()
has been added to the -mm tree.  Its filename is
     cgroups-fix-2632-regression-causing-bug_on-in-cgroup_diput.patch

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
Subject: cgroups: fix 2.6.32 regression causing BUG_ON() in cgroup_diput()
From: Dave Anderson <anderson@redhat.com>

The LTP cgroup test suite generates a "kernel BUG at kernel/cgroup.c:790!"
here in cgroup_diput():

                 /*
                  * if we're getting rid of the cgroup, refcount should ensure
                  * that there are no pidlists left.
                  */
                 BUG_ON(!list_empty(&cgrp->pidlists));

The cgroup pidlist rework in 2.6.32 generates the BUG_ON, which is caused
when pidlist_array_load() calls cgroup_pidlist_find():

(1) if a matching cgroup_pidlist is found, it down_write's the mutex of the
     pre-existing cgroup_pidlist, and increments its use_count.
(2) if no matching cgroup_pidlist is found, then a new one is allocated, it
     down_write's its mutex, and the use_count is set to 0.
(3) the matching, or new, cgroup_pidlist gets returned back to pidlist_array_load(),
     which increments its use_count -- regardless whether new or pre-existing --
     and up_write's the mutex.

So if a matching list is ever encountered by cgroup_pidlist_find() during
the life of a cgroup directory, it results in an inflated use_count value,
preventing it from ever getting released by cgroup_release_pid_array(). 
Then if the directory is subsequently removed, cgroup_diput() hits the
BUG_ON() when it finds that the directory's cgroup is still populated with
a pidlist.

The patch simply removes the use_count increment when a matching pidlist
is found by cgroup_pidlist_find(), because it gets bumped by the calling
pidlist_array_load() function while still protected by the list's mutex.

Signed-off-by: Dave Anderson <anderson@redhat.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: Paul Menage <menage@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-fix-2632-regression-causing-bug_on-in-cgroup_diput kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-2632-regression-causing-bug_on-in-cgroup_diput
+++ a/kernel/cgroup.c
@@ -2468,7 +2468,6 @@ static struct cgroup_pidlist *cgroup_pid
 			/* make sure l doesn't vanish out from under us */
 			down_write(&l->mutex);
 			mutex_unlock(&cgrp->pidlist_mutex);
-			l->use_count++;
 			return l;
 		}
 	}
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from anderson@redhat.com are

cgroups-fix-2632-regression-causing-bug_on-in-cgroup_diput.patch

