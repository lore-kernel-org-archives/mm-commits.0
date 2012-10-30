From: akpm@linux-foundation.org
Subject: + fork-unshare-remove-dead-code.patch added to -mm tree
Date: Tue, 30 Oct 2012 16:08:48 -0700
Message-ID: <20121030230848.7A78C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47994 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759806Ab2J3XIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 19:08:49 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so95814vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 16:08:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com


The patch titled
     Subject: fork: unshare: remove dead code
has been added to the -mm tree.  Its filename is
     fork-unshare-remove-dead-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1792,10 +1792,8 @@ SYSCALL_DEFINE1(unshare, unsigned long, 
 			exit_sem(current);
 		}
 
-		if (new_nsproxy) {
+		if (new_nsproxy)
 			switch_task_namespaces(current, new_nsproxy);
-			new_nsproxy = NULL;
-		}
 
 		task_lock(current);
 
@@ -1819,9 +1817,6 @@ SYSCALL_DEFINE1(unshare, unsigned long, 
 		task_unlock(current);
 	}
 
-	if (new_nsproxy)
-		put_nsproxy(new_nsproxy);
