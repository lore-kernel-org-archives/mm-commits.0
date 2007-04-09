From: akpm@linux-foundation.org
Subject: + lockdep-treats-down_write_trylock-like-regular-down_write.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:31:54 -0700
Message-ID: <200704091931.l39JVsbq021442@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXDITcv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, a.p.zijlstra@chello.nl, arjan@infradead.org, mingo@elte.hu


The patch titled
     Lockdep treats down_write_trylock like regular down_write
has been added to the -mm tree.  Its filename is
     lockdep-treats-down_write_trylock-like-regular-down_write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

lockdep-treats-down_write_trylock-like-regular-down_write.patch
