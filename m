From: akpm@linux-foundation.org
Subject: + proc_sysctlc-use-bug_on-instead-of-bug.patch added to -mm tree
Date: Tue, 04 Sep 2012 16:18:08 -0700
Message-ID: <20120904231808.E46635C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39278 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab2IDXSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 19:18:12 -0400
Received: by lbbge1 with SMTP id ge1so317370lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 16:18:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prasadjoshi.linux@gmail.com


The patch titled
     Subject: proc_sysctl.c: use BUG_ON instead of BUG
has been added to the -mm tree.  Its filename is
     proc_sysctlc-use-bug_on-instead-of-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
proc_sysctlc-use-bug_on-instead-of-bug.patch

