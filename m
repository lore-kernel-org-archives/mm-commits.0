From: akpm@linux-foundation.org
Subject: + reduce-cpusetc-write_lock_irq-to-read_lock.patch added to -mm tree
Date: Thu, 24 May 2007 15:04:30 -0700
Message-ID: <200705242204.l4OM4UtT004361@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493AbXEXWFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, pj@sgi.com


The patch titled
     Reduce cpuset.c write_lock_irq() to read_lock()
has been added to the -mm tree.  Its filename is
     reduce-cpusetc-write_lock_irq-to-read_lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Reduce cpuset.c write_lock_irq() to read_lock()
From: Paul Menage <menage@google.com>

cpuset.c:update_nodemask() uses a write_lock_irq() on tasklist_lock to
block concurrent forks; a read_lock() suffices and is less intrusive.

Signed-off-by: Paul Menage<menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~reduce-cpusetc-write_lock_irq-to-read_lock kernel/cpuset.c
--- a/kernel/cpuset.c~reduce-cpusetc-write_lock_irq-to-read_lock
+++ a/kernel/cpuset.c
@@ -923,10 +923,10 @@ static int update_nodemask(struct cpuset
 		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
 		if (!mmarray)
 			goto done;
-		write_lock_irq(&tasklist_lock);		/* block fork */
+		read_lock(&tasklist_lock);		/* block fork */
 		if (atomic_read(&cs->count) <= ntasks)
 			break;				/* got enough */
-		write_unlock_irq(&tasklist_lock);	/* try again */
+		read_unlock(&tasklist_lock);	/* try again */
 		kfree(mmarray);
 	}
 
@@ -948,7 +948,7 @@ static int update_nodemask(struct cpuset
 			continue;
 		mmarray[n++] = mm;
 	} while_each_thread(g, p);
-	write_unlock_irq(&tasklist_lock);
+	read_unlock(&tasklist_lock);
 
 	/*
 	 * Now that we've dropped the tasklist spinlock, we can
_

Patches currently in -mm which might be from menage@google.com are

reduce-cpusetc-write_lock_irq-to-read_lock.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
