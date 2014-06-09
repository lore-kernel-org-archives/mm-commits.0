From: akpm@linux-foundation.org
Subject: [merged] ipc-shmc-check-for-integer-overflow-during-shmget.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:37:22 -0700
Message-ID: <53960cf2.VAzYazEj6ZWGARRL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFIThX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, kosaki.motohiro@jp.fujitsu.com, davidlohr@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-shmc-check-for-integer-overflow-during-shmget.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr@hp.com,kosaki.motohiro@jp.fujitsu.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:37:22 -0700


The patch titled
     Subject: ipc/shm.c: check for integer overflow during shmget.
has been removed from the -mm tree.  Its filename was
     ipc-shmc-check-for-integer-overflow-during-shmget.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/shm.c: check for integer overflow during shmget.

SHMMAX is the upper limit for the size of a shared memory segment, counted
in bytes.  The actual allocation is that size, rounded up to the next full
page.

Add a check that prevents the creation of segments where the rounded up
size causes an integer overflow.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN ipc/shm.c~ipc-shmc-check-for-integer-overflow-during-shmget ipc/shm.c
--- a/ipc/shm.c~ipc-shmc-check-for-integer-overflow-during-shmget
+++ a/ipc/shm.c
@@ -493,6 +493,9 @@ static int newseg(struct ipc_namespace *
 	if (size < SHMMIN || size > ns->shm_ctlmax)
 		return -EINVAL;
 
+	if (numpages << PAGE_SHIFT < size)
+		return -ENOSPC;
+
 	if (ns->shm_tot + numpages < ns->shm_tot ||
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

