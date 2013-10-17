From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-synchronize-the-proc-interface.patch removed
 from -mm tree
Date: Thu, 17 Oct 2013 11:12:17 -0700
Message-ID: <52602881.1WK0Z3IF8onrEZo1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab3JQSMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, efault@gmx.de, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-semc-synchronize-the-proc-interface.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,efault@gmx.de,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:17 -0700


The patch titled
     Subject: ipc/sem.c: synchronize the proc interface
has been removed from the -mm tree.  Its filename was
     ipc-semc-synchronize-the-proc-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: synchronize the proc interface

The proc interface is not aware of sem_lock(), it calls ipc_lock_object()
directly.  This means that simple semop() operations can run in parallel
with the proc interface.  Right now, this is uncritical, because the
implementation doesn't do anything that requires a proper synchronization.

But it is dangerous and therefore should be fixed.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN ipc/sem.c~ipc-semc-synchronize-the-proc-interface ipc/sem.c
--- a/ipc/sem.c~ipc-semc-synchronize-the-proc-interface
+++ a/ipc/sem.c
@@ -2103,6 +2103,14 @@ static int sysvipc_sem_proc_show(struct
 	struct sem_array *sma = it;
 	time_t sem_otime;
 
+	/*
+	 * The proc interface isn't aware of sem_lock(), it calls
+	 * ipc_lock_object() directly (in sysvipc_find_ipc).
+	 * In order to stay compatible with sem_lock(), we must wait until
+	 * all simple semop() calls have left their critical regions.
+	 */
+	sem_wait_array(sma);
+
 	sem_otime = get_semotime(sma);
 
 	return seq_printf(s,
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

