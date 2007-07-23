From: akpm@linux-foundation.org
Subject: + fix-theoretical-ccids_readwrite_lock-race.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:33:44 -0700
Message-ID: <200707232333.l6NNXibL017798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56108 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238AbXGWXeK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:34:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, acme@redhat.com, davem@davemloft.net, mingo@elte.hu


The patch titled
     fix theoretical ccids_{read,write}_lock() race
has been added to the -mm tree.  Its filename is
     fix-theoretical-ccids_readwrite_lock-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix theoretical ccids_{read,write}_lock() race
From: Oleg Nesterov <oleg@tv-sign.ru>

Make sure that spin_unlock_wait() is properly ordered wrt atomic_inc().

(akpm: can't we convert this code to use rwlocks?)

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/ccid.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN net/dccp/ccid.c~fix-theoretical-ccids_readwrite_lock-race net/dccp/ccid.c
--- a/net/dccp/ccid.c~fix-theoretical-ccids_readwrite_lock-race
+++ a/net/dccp/ccid.c
@@ -40,6 +40,7 @@ static inline void ccids_write_unlock(vo
 static inline void ccids_read_lock(void)
 {
 	atomic_inc(&ccids_lockct);
+	smp_mb__after_atomic_inc();
 	spin_unlock_wait(&ccids_lock);
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

fix-theoretical-ccids_readwrite_lock-race.patch
i386-remove-unnecessary-code.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_poll-return-eintr-when-signalled.patch
idr_remove_all-kill-unused-variable.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
