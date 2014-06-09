From: akpm@linux-foundation.org
Subject: [merged] ipc-shmc-check-for-overflows-of-shm_tot.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:37:17 -0700
Message-ID: <53960ced.dQJmetXcHHcxColy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaFIThS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, kosaki.motohiro@jp.fujitsu.com, davidlohr@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-shmc-check-for-overflows-of-shm_tot.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr@hp.com,kosaki.motohiro@jp.fujitsu.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:37:17 -0700


The patch titled
     Subject: ipc/shm.c: check for overflows of shm_tot
has been removed from the -mm tree.  Its filename was
     ipc-shmc-check-for-overflows-of-shm_tot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/shm.c: check for overflows of shm_tot

shm_tot counts the total number of pages used by shm segments.

If SHMALL is ULONG_MAX (or nearly ULONG_MAX), then the number can
overflow.  Subsequent calls to shmctl(,SHM_INFO,) would return wrong
values for shm_tot.

The patch adds a detection for overflows.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN ipc/shm.c~ipc-shmc-check-for-overflows-of-shm_tot ipc/shm.c
--- a/ipc/shm.c~ipc-shmc-check-for-overflows-of-shm_tot
+++ a/ipc/shm.c
@@ -493,7 +493,8 @@ static int newseg(struct ipc_namespace *
 	if (size < SHMMIN || size > ns->shm_ctlmax)
 		return -EINVAL;
 
-	if (ns->shm_tot + numpages > ns->shm_ctlall)
+	if (ns->shm_tot + numpages < ns->shm_tot ||
+			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
 	shp = ipc_rcu_alloc(sizeof(*shp));
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

