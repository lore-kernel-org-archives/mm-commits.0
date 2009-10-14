From: akpm@linux-foundation.org
Subject: + rwsem-spinlock-remove-useless-function-exports.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:11:44 -0700
Message-ID: <200910140211.n9E2BiNg023910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962AbZJNCMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, dhowells@redhat.com


The patch titled
     rwsem-spinlock: remove useless function exports
has been added to the -mm tree.  Its filename is
     rwsem-spinlock-remove-useless-function-exports.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
xtensa-use-generic-sys_pipe.patch
rwsem-spinlock-remove-useless-function-exports.patch

