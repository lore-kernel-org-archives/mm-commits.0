From: akpm@linux-foundation.org
Subject: + introduce-write_trylock_irqsave.patch added to -mm tree
Date: Thu, 10 May 2007 17:00:45 -0700
Message-ID: <200705110000.l4B00jVS001882@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871AbXEKABU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 20:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ssatyam@cse.iitk.ac.in, mingo@elte.hu, sripathik@in.ibm.com


The patch titled
     introduce write_trylock_irqsave()
has been added to the -mm tree.  Its filename is
     introduce-write_trylock_irqsave.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 7 insertions(+)

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

git-gfs2-nmw.patch
drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch
introduce-write_trylock_irqsave.patch
