From: akpm@linux-foundation.org
Subject: [merged] rwsem-spinlock-remove-useless-function-exports.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:42 -0800
Message-ID: <200912152155.nBFLtg4H015506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755064AbZLOWF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:05:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     rwsem-spinlock: remove useless function exports
has been removed from the -mm tree.  Its filename was
     rwsem-spinlock-remove-useless-function-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rwsem-spinlock: remove useless function exports
From: Amerigo Wang <amwang@redhat.com>

These functions need not to be exported, since no drivers should use them.

__init_rwsem() is an exception, because init_rwsem(), which is a macro,
is used.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rwsem-spinlock.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN lib/rwsem-spinlock.c~rwsem-spinlock-remove-useless-function-exports lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c~rwsem-spinlock-remove-useless-function-exports
+++ a/lib/rwsem-spinlock.c
@@ -34,6 +34,7 @@ void __init_rwsem(struct rw_semaphore *s
 	spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
 }
+EXPORT_SYMBOL(__init_rwsem);
 
 /*
  * handle the lock release when processes blocked on it that can now run
@@ -305,12 +306,3 @@ void __downgrade_write(struct rw_semapho
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
-EXPORT_SYMBOL(__init_rwsem);
-EXPORT_SYMBOL(__down_read);
-EXPORT_SYMBOL(__down_read_trylock);
-EXPORT_SYMBOL(__down_write_nested);
-EXPORT_SYMBOL(__down_write);
-EXPORT_SYMBOL(__down_write_trylock);
-EXPORT_SYMBOL(__up_read);
-EXPORT_SYMBOL(__up_write);
-EXPORT_SYMBOL(__downgrade_write);
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch
xtensa-use-generic-sys_pipe.patch
ipc-remove-unreachable-code-in-semc.patch
ipc-remove-unreachable-code-in-semc-fix.patch
ipc-hard_msgmax-should-be-higher-not-lower-on-64bit.patch
kexec-premit-reduction-of-the-reserved-memory-size.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

