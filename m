From: akpm@linux-foundation.org
Subject: [merged] fork-unshare-remove-dead-code.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:01 -0800
Message-ID: <20130228201201.A7D1A5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:57824 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1UMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:02 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so261080qah.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fork: unshare: remove dead code
has been removed from the -mm tree.  Its filename was
     fork-unshare-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: fork: unshare: remove dead code

If new_nsproxy is set we will always call switch_task_namespaces and then
set new_nsproxy back to NULL so the reassignment and fall through check
are redundant

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN kernel/fork.c~fork-unshare-remove-dead-code kernel/fork.c
--- a/kernel/fork.c~fork-unshare-remove-dead-code
+++ a/kernel/fork.c
@@ -1861,10 +1861,8 @@ SYSCALL_DEFINE1(unshare, unsigned long, 
 			exit_sem(current);
 		}
 
-		if (new_nsproxy) {
+		if (new_nsproxy)
 			switch_task_namespaces(current, new_nsproxy);
-			new_nsproxy = NULL;
-		}
 
 		task_lock(current);
 
@@ -1894,9 +1892,6 @@ SYSCALL_DEFINE1(unshare, unsigned long, 
 		}
 	}
 
-	if (new_nsproxy)
-		put_nsproxy(new_nsproxy);
