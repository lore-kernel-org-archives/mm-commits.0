From: akpm@linux-foundation.org
Subject: [merged] ipc-document-general-ipc-locking-scheme.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:50:59 -0700
Message-ID: <52321b23.CXlLoOqDh3y8Ivpa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3ILTvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: [merged] ipc-document-general-ipc-locking-scheme.patch removed from -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:50:59 -0700


The patch titled
     Subject: ipc: document general ipc locking scheme
has been removed from the -mm tree.  Its filename was
     ipc-document-general-ipc-locking-scheme.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

