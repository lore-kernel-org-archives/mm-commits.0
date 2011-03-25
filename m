From: akpm@linux-foundation.org
Subject: [merged] sysctl_check-drop-dead-code.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:25 -0700
Message-ID: <201103250726.p2P7QJdk026131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933145Ab1CYH0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkirjanov@kernel.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl_check: drop dead code
has been removed from the -mm tree.  Its filename was
     sysctl_check-drop-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

