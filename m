From: akpm@linux-foundation.org
Subject: + sysctl_check-drop-table-procname-checks.patch added to -mm tree
Date: Tue, 08 Feb 2011 13:39:23 -0800
Message-ID: <201102082139.p18LdN4f026977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846Ab1BHVkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 16:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkirjanov@kernel.org, ebiederm@xmission.com


The patch titled
     sysctl_check: drop table->procname checks
has been added to the -mm tree.  Its filename is
     sysctl_check-drop-table-procname-checks.patch

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

linux-next.patch
sysctl_check-drop-table-procname-checks.patch
sysctl_check-drop-dead-code.patch

