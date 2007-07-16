From: akpm@linux-foundation.org
Subject: - introduce-write_trylock_irqsave.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:53 -0700
Message-ID: <200707162053.l6GKrr2b001685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760228AbXGPVas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:30:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssatyam@cse.iitk.ac.in, mingo@elte.hu, sripathik@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     introduce write_trylock_irqsave()
has been removed from the -mm tree.  Its filename was
     introduce-write_trylock_irqsave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: introduce write_trylock_irqsave()
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Introduce a write_trylock_irqsave() implementation.  Similar in style to
the implementation of spin_trylock_irqsave() in mainline.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/spinlock.h~introduce-write_trylock_irqsave include/linux/spinlock.h
--- a/include/linux/spinlock.h~introduce-write_trylock_irqsave
+++ a/include/linux/spinlock.h
@@ -282,6 +282,13 @@ do {						\
 	1 : ({ local_irq_restore(flags); 0; }); \
 })
 
+#define write_trylock_irqsave(lock, flags) \
+({ \
+	local_irq_save(flags); \
+	write_trylock(lock) ? \
+	1 : ({ local_irq_restore(flags); 0; }); \
+})
+
 /*
  * Locks two spinlocks l1 and l2.
  * l1_first indicates if spinlock l1 should be taken first.
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

origin.patch
git-ocfs2.patch
