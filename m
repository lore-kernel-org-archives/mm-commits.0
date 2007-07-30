From: akpm@linux-foundation.org
Subject: + tiny-sched_getaffinity-cleanup.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:59:05 -0700
Message-ID: <200707302359.l6UNx5sI005161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765676AbXG3X7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:59:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, mingo@elte.hu


The patch titled
     tiny sched_getaffinity cleanup
has been added to the -mm tree.  Its filename is
     tiny-sched_getaffinity-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tiny sched_getaffinity cleanup
From: Ulrich Drepper <drepper@redhat.com>

Unless I'm missing something quite tricky here's another tiny cleanup.  The
generated code is not affected (gcc is smart enough) but for people looking
over the code it is just irritating to have the extra conditional.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/sched.c~tiny-sched_getaffinity-cleanup kernel/sched.c
--- a/kernel/sched.c~tiny-sched_getaffinity-cleanup
+++ a/kernel/sched.c
@@ -4466,10 +4466,8 @@ long sched_getaffinity(pid_t pid, cpumas
 out_unlock:
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&sched_hotcpu_mutex);
-	if (retval)
-		return retval;
 
-	return 0;
+	return retval;
 }
 
 /**
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
cpu-online-file-permission.patch
tiny-sched_getaffinity-cleanup.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
