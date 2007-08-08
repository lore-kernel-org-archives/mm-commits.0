From: akpm@linux-foundation.org
Subject: - tiny-sched_getaffinity-cleanup.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:08:00 -0700
Message-ID: <200708081908.l78J80tS025833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44757 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937775AbXHHTIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:08:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     tiny sched_getaffinity cleanup
has been removed from the -mm tree.  Its filename was
     tiny-sched_getaffinity-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-sched.patch
