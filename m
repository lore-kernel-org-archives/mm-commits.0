From: akpm@linux-foundation.org
Subject: - lockdep-treats-down_write_trylock-like-regular-down_write.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:17 -0700
Message-ID: <200705090249.l492nHVU009206@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969826AbXEICuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, a.p.zijlstra@chello.nl, arjan@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Lockdep treats down_write_trylock like regular down_write
has been removed from the -mm tree.  Its filename was
     lockdep-treats-down_write_trylock-like-regular-down_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Lockdep treats down_write_trylock like regular down_write
From: Pavel Emelianov <xemul@sw.ru>

This causes constructions like

down_write(&mm1->mmap_sem);
if (down_write_trylock(&mm2->mmap_sem)) {
       ...
       up_write(&mm2->mmap_sem);
}
up_write(&mm1->mmap_sem);

generate a lockdep warning about circular locking dependence.

Call rwsem_acquire() with trylock set to 1.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rwsem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rwsem.c~lockdep-treats-down_write_trylock-like-regular-down_write kernel/rwsem.c
--- a/kernel/rwsem.c~lockdep-treats-down_write_trylock-like-regular-down_write
+++ a/kernel/rwsem.c
@@ -60,7 +60,7 @@ int down_write_trylock(struct rw_semapho
 	int ret = __down_write_trylock(sem);
 
 	if (ret == 1)
-		rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
+		rwsem_acquire(&sem->dep_map, 0, 1, _RET_IP_);
 	return ret;
 }
 
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
