From: akpm@linux-foundation.org
Subject: + lost-sysctl-fix.patch added to -mm tree
Date: Sat, 26 Jul 2008 23:25:21 -0700
Message-ID: <200807270625.m6R6PLmi006138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbYG0GZY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 02:25:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ZenIV.linux.org.ukviro@ZenIV.linux.org.uk


The patch titled
     lost sysctl fix
has been added to the -mm tree.  Its filename is
     lost-sysctl-fix.patch

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
Subject: lost sysctl fix
From: Al Viro <viro@ZenIV.linux.org.uk>

try_attach() should walk into the matching subdirectory, not the first one...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN kernel/sysctl.c~lost-sysctl-fix kernel/sysctl.c
--- a/kernel/sysctl.c~lost-sysctl-fix
+++ a/kernel/sysctl.c
@@ -1704,43 +1704,45 @@ static __init int sysctl_init(void)
 
 core_initcall(sysctl_init);
 
-static int is_branch_in(struct ctl_table *branch, struct ctl_table *table)
+static struct ctl_table *is_branch_in(struct ctl_table *branch,
+				      struct ctl_table *table)
 {
 	struct ctl_table *p;
 	const char *s = branch->procname;
 
 	/* branch should have named subdirectory as its first element */
 	if (!s || !branch->child)
-		return 0;
+		return NULL;
 
 	/* ... and nothing else */
 	if (branch[1].procname || branch[1].ctl_name)
-		return 0;
+		return NULL;
 
 	/* table should contain subdirectory with the same name */
 	for (p = table; p->procname || p->ctl_name; p++) {
 		if (!p->child)
 			continue;
 		if (p->procname && strcmp(p->procname, s) == 0)
-			return 1;
+			return p;
 	}
-	return 0;
+	return NULL;
 }
 
 /* see if attaching q to p would be an improvement */
 static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
 {
 	struct ctl_table *to = p->ctl_table, *by = q->ctl_table;
+	struct ctl_table *next;
 	int is_better = 0;
 	int not_in_parent = !p->attached_by;
 
-	while (is_branch_in(by, to)) {
+	while ((next = is_branch_in(by, to)) != NULL) {
 		if (by == q->attached_by)
 			is_better = 1;
 		if (to == p->attached_by)
 			not_in_parent = 1;
 		by = by->child;
-		to = to->child;
+		to = next->child;
 	}
 
 	if (is_better && not_in_parent) {
_

Patches currently in -mm which might be from viro@ZenIV.linux.org.uk are

origin.patch
linux-next.patch
lost-sysctl-fix.patch

