From: akpm@linux-foundation.org
Subject: [merged] sysctl_check-drop-table-procname-checks.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:23 -0700
Message-ID: <201103250726.p2P7QHxT026128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933145Ab1CYH0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkirjanov@kernel.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl_check: drop table->procname checks
has been removed from the -mm tree.  Its filename was
     sysctl_check-drop-table-procname-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl_check: drop table->procname checks
From: Denis Kirjanov <dkirjanov@kernel.org>

Since the for loop checks for the table->procname drop useless
table->procname checks inside the loop body

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/sysctl_check.c~sysctl_check-drop-table-procname-checks kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl_check-drop-table-procname-checks
+++ a/kernel/sysctl_check.c
@@ -111,11 +111,9 @@ int sysctl_check_table(struct nsproxy *n
 		const char *fail = NULL;
 
 		if (table->parent) {
-			if (table->procname && !table->parent->procname)
+			if (!table->parent->procname)
 				set_fail(&fail, table, "Parent without procname");
 		}
-		if (!table->procname)
-			set_fail(&fail, table, "No procname");
 		if (table->child) {
 			if (table->data)
 				set_fail(&fail, table, "Directory with data?");
@@ -144,7 +142,7 @@ int sysctl_check_table(struct nsproxy *n
 					set_fail(&fail, table, "No maxlen");
 			}
 #ifdef CONFIG_PROC_SYSCTL
-			if (table->procname && !table->proc_handler)
+			if (!table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
 #endif
 #if 0
_

Patches currently in -mm which might be from dkirjanov@kernel.org are

origin.patch

