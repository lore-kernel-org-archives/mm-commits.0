From: akpm@linux-foundation.org
Subject: + ipc-semc-synchronize-the-proc-interface.patch added to -mm tree
Date: Wed, 25 Sep 2013 12:48:32 -0700
Message-ID: <52433e10.wSgu9h6tER5Zz74u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3IYTsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, efault@gmx.de, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-semc-synchronize-the-proc-interface.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,efault@gmx.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:48:32 -0700


The patch titled
     Subject: ipc/sem.c: synchronize the proc interface
has been added to the -mm tree.  Its filename is
     ipc-semc-synchronize-the-proc-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-synchronize-the-proc-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-synchronize-the-proc-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
ipc-semc-fix-race-in-sem_lock.patch
ipc-semc-optimize-sem_lock.patch
ipc-semc-synchronize-the-proc-interface.patch
slab-leaks3-default-y.patch

