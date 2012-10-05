From: akpm@linux-foundation.org
Subject: [merged] proc_sysctlc-use-bug_on-instead-of-bug.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:02 -0700
Message-ID: <20121005202002.C27751E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52917 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:03 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so237464qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prasadjoshi.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc_sysctl.c: use BUG_ON instead of BUG
has been removed from the -mm tree.  Its filename was
     proc_sysctlc-use-bug_on-instead-of-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Prasad Joshi <prasadjoshi.linux@gmail.com>
Subject: proc_sysctl.c: use BUG_ON instead of BUG

The use of if (!head) BUG(); can be replaced with the single line
BUG_ON(!head).

Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/proc_sysctl.c~proc_sysctlc-use-bug_on-instead-of-bug fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~proc_sysctlc-use-bug_on-instead-of-bug
+++ a/fs/proc/proc_sysctl.c
@@ -266,8 +266,7 @@ void sysctl_head_put(struct ctl_table_he
 
 static struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *head)
 {
-	if (!head)
-		BUG();
+	BUG_ON(!head);
 	spin_lock(&sysctl_lock);
 	if (!use_table(head))
 		head = ERR_PTR(-ENOENT);
_

Patches currently in -mm which might be from prasadjoshi.linux@gmail.com are

origin.patch
linux-next.patch

