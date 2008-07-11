From: akpm@linux-foundation.org
Subject: + use-warn-in-kernel-lockdepc.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:45:20 -0700
Message-ID: <200807111851.m6BIp1cK031287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756855AbYGKSvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, mingo@elte.hu


The patch titled
     use WARN() in kernel/lockdep.c
has been added to the -mm tree.  Its filename is
     use-warn-in-kernel-lockdepc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use WARN() in kernel/lockdep.c
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/lockdep.c~use-warn-in-kernel-lockdepc kernel/lockdep.c
--- a/kernel/lockdep.c~use-warn-in-kernel-lockdepc
+++ a/kernel/lockdep.c
@@ -1643,11 +1643,10 @@ static void check_chain_key(struct task_
 		hlock = curr->held_locks + i;
 		if (chain_key != hlock->prev_chain_key) {
 			debug_locks_off();
-			printk("hm#1, depth: %u [%u], %016Lx != %016Lx\n",
+			WARN(1, "hm#1, depth: %u [%u], %016Lx != %016Lx\n",
 				curr->lockdep_depth, i,
 				(unsigned long long)chain_key,
 				(unsigned long long)hlock->prev_chain_key);
-			WARN_ON(1);
 			return;
 		}
 		id = hlock->class - lock_classes;
@@ -1662,11 +1661,10 @@ static void check_chain_key(struct task_
 	}
 	if (chain_key != curr->curr_chain_key) {
 		debug_locks_off();
-		printk("hm#2, depth: %u [%u], %016Lx != %016Lx\n",
+		WARN(1, "hm#2, depth: %u [%u], %016Lx != %016Lx\n",
 			curr->lockdep_depth, i,
 			(unsigned long long)chain_key,
 			(unsigned long long)curr->curr_chain_key);
-		WARN_ON(1);
 	}
 #endif
 }
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-panicc.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch

