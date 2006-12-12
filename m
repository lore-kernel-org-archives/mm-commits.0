From: akpm@osdl.org
Subject: + lockdep-fix-possible-race-while-disabling-lock-debugging-restore-fix-fix.patch added to -mm tree
Date: Tue, 12 Dec 2006 13:19:31 -0800
Message-ID: <200612122119.kBCLJVlv016075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42793 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbWLLVTh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 16:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, mingo@elte.hu


The patch titled
     lockdep-fix-possible-race-while-disabling-lock-debugging-restore-fix fix
has been added to the -mm tree.  Its filename is
     lockdep-fix-possible-race-while-disabling-lock-debugging-restore-fix-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockdep-fix-possible-race-while-disabling-lock-debugging-restore-fix fix
From: Jarek Poplawski <jarkao2@o2.pl>

build fix's refix

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/lockdep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/lockdep.c~lockdep-fix-possible-race-while-disabling-lock-debugging-restore-fix-fix kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-fix-possible-race-while-disabling-lock-debugging-restore-fix-fix
+++ a/kernel/lockdep.c
@@ -1760,8 +1760,8 @@ static int mark_lock(struct task_struct 
 		debug_atomic_dec(&nr_unused_locks);
 		break;
 	default:
-		__raw_spin_unlock(&lockdep_lock);
-		debug_locks_off();
+		if (!debug_locks_off_graph_unlock())
+			return 0;
 		WARN_ON(1);
 		return 0;
 	}
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
lockdep-fix-possible-races-while-disabling-lock-debugging-fix.patch
lockdep-fix-possible-race-while-disabling-lock-debugging-restore-fix.patch
lockdep-fix-possible-race-while-disabling-lock-debugging-restore-fix-fix.patch

