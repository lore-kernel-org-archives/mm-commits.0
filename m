From: akpm@linux-foundation.org
Subject: [merged] include-linux-semh-make-sysv_sem-empty-if-sysvipc-is-disabled.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:08 -0800
Message-ID: <201111072028.pA7KS8tc030086@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5622 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGU21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:28:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sem.h: make sysv_sem empty if SYSVIPC is disabled
has been removed from the -mm tree.  Its filename was
     include-linux-semh-make-sysv_sem-empty-if-sysvipc-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: include/linux/sem.h: make sysv_sem empty if SYSVIPC is disabled

For the sysvsem undo, each task struct contains a sysv_sem structure with
a pointer to the undo information.

This pointer is only necessary if sysvipc is enabled - thus the pointer
can be made conditional on CONFIG_SYSVIPC.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/sem.h~include-linux-semh-make-sysv_sem-empty-if-sysvipc-is-disabled include/linux/sem.h
--- a/include/linux/sem.h~include-linux-semh-make-sysv_sem-empty-if-sysvipc-is-disabled
+++ a/include/linux/sem.h
@@ -96,16 +96,21 @@ struct sem_array {
 	int			complex_count;	/* pending complex operations */
 };
 
+#ifdef CONFIG_SYSVIPC
+
 struct sysv_sem {
 	struct sem_undo_list *undo_list;
 };
 
-#ifdef CONFIG_SYSVIPC
