From: akpm@linux-foundation.org
Subject: + sysctl_check-drop-dead-code.patch added to -mm tree
Date: Tue, 08 Feb 2011 13:39:25 -0800
Message-ID: <201102082139.p18LdQTd026980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846Ab1BHVkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 16:40:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkirjanov@kernel.org, ebiederm@xmission.com


The patch titled
     sysctl_check: drop dead code
has been added to the -mm tree.  Its filename is
     sysctl_check-drop-dead-code.patch

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
Subject: sysctl_check: drop dead code
From: Denis Kirjanov <dkirjanov@kernel.org>

Drop dead code.

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/sysctl_check.c~sysctl_check-drop-dead-code kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl_check-drop-dead-code
+++ a/kernel/sysctl_check.c
@@ -145,10 +145,6 @@ int sysctl_check_table(struct nsproxy *n
 			if (!table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
 #endif
-#if 0
-			if (!table->procname && table->proc_handler)
-				set_fail(&fail, table, "proc_handler without procname");
-#endif
 			sysctl_check_leaf(namespaces, table, &fail);
 		}
 		if (table->mode > 0777)
_

Patches currently in -mm which might be from dkirjanov@kernel.org are

linux-next.patch
sysctl_check-drop-table-procname-checks.patch
sysctl_check-drop-dead-code.patch

