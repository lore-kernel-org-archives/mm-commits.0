From: akpm@linux-foundation.org
Subject: [merged] ipc-update-locking-scheme-comments.patch removed from
 -mm tree
Date: Thu, 17 Oct 2013 11:12:55 -0700
Message-ID: <526028a7.I6d5il5T3MtybFKl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3JQSMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, davidlohr@hp.com

Subject: [merged] ipc-update-locking-scheme-comments.patch removed from -mm tree
To: davidlohr@hp.com,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:55 -0700


The patch titled
     Subject: ipc: update locking scheme comments
has been removed from the -mm tree.  Its filename was
     ipc-update-locking-scheme-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc: update locking scheme comments

The initial documentation was a bit incomplete, update accordingly.

[akpm@linux-foundation.org: make it more readable in 80 columns]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff -puN ipc/util.c~ipc-update-locking-scheme-comments ipc/util.c
--- a/ipc/util.c~ipc-update-locking-scheme-comments
+++ a/ipc/util.c
@@ -17,12 +17,27 @@
  *            Pavel Emelianov <xemul@openvz.org>
  *
  * General sysv ipc locking scheme:
- *  when doing ipc id lookups, take the ids->rwsem
- *      rcu_read_lock()
- *          obtain the ipc object (kern_ipc_perm)
- *          perform security, capabilities, auditing and permission checks, etc.
- *          acquire the ipc lock (kern_ipc_perm.lock) throught ipc_lock_object()
- *             perform data updates (ie: SET, RMID, LOCK/UNLOCK commands)
+ *	rcu_read_lock()
+ *          obtain the ipc object (kern_ipc_perm) by looking up the id in an idr
+ *	    tree.
+ *	    - perform initial checks (capabilities, auditing and permission,
+ *	      etc).
+ *	    - perform read-only operations, such as STAT, INFO commands.
+ *	      acquire the ipc lock (kern_ipc_perm.lock) through
+ *	      ipc_lock_object()
+ *		- perform data updates, such as SET, RMID commands and
+ *		  mechanism-specific operations (semop/semtimedop,
+ *		  msgsnd/msgrcv, shmat/shmdt).
+ *	    drop the ipc lock, through ipc_unlock_object().
+ *	rcu_read_unlock()
+ *
+ *  The ids->rwsem must be taken when:
+ *	- creating, removing and iterating the existing entries in ipc
+ *	  identifier sets.
+ *	- iterating through /proc/sysvipc/* files.
+ *
+ *  Note that sems have a special fast path that avoids kern_ipc_perm.lock -
+ *  see sem_lock().
  */
 
 #include <linux/mm.h>
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch

