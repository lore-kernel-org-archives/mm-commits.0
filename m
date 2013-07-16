From: akpm@linux-foundation.org
Subject: + ipc-document-general-ipc-locking-scheme.patch added to -mm tree
Date: Tue, 16 Jul 2013 15:51:55 -0700
Message-ID: <51e5ce8b.V/cCR2Vte1DVHy+8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657Ab3GPWv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 18:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipc-document-general-ipc-locking-scheme.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 15:51:55 -0700


The patch titled
     Subject: ipc: document general ipc locking scheme
has been added to the -mm tree.  Its filename is
     ipc-document-general-ipc-locking-scheme.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-document-general-ipc-locking-scheme.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-document-general-ipc-locking-scheme.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: document general ipc locking scheme

As suggested by Andrew, add a generic initial locking scheme used
throughout all sysv ipc mechanisms.  Documenting the ids rwsem, how rcu
can be enough to do the initial checks and when to actually acquire the
kern_ipc_perm.lock spinlock.

I found that adding it to util.c was generic enough.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN ipc/util.c~ipc-document-general-ipc-locking-scheme ipc/util.c
--- a/ipc/util.c~ipc-document-general-ipc-locking-scheme
+++ a/ipc/util.c
@@ -15,6 +15,14 @@
  * Jun 2006 - namespaces ssupport
  *            OpenVZ, SWsoft Inc.
  *            Pavel Emelianov <xemul@openvz.org>
+ *
+ * General sysv ipc locking scheme:
+ *  when doing ipc id lookups, take the ids->rwsem
+ *      rcu_read_lock()
+ *          obtain the ipc object (kern_ipc_perm)
+ *          perform security, capabilities, auditing and permission checks, etc.
+ *          acquire the ipc lock (kern_ipc_perm.lock) throught ipc_lock_object()
+ *             perform data updates (ie: SET, RMID, LOCK/UNLOCK commands)
  */
 
 #include <linux/mm.h>
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcshm-shorten-critical-region-in-shmctl_down.patch
ipc-drop-ipcctl_pre_down.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-introduce-shmctl_nolock.patch
ipcshm-make-shmctl_nolock-lockless.patch
ipcshm-shorten-critical-region-for-shmctl.patch
ipcshm-cleanup-do_shmat-pasta.patch
ipcshm-shorten-critical-region-for-shmat.patch
ipc-rename-ids-rw_mutex.patch
ipcmsg-drop-msg_unlock.patch
ipc-document-general-ipc-locking-scheme.patch

