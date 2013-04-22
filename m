From: akpm@linux-foundation.org
Subject: + kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch added to -mm tree
Date: Mon, 22 Apr 2013 16:04:17 -0700
Message-ID: <20130422230417.D066D31C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:41225 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab3DVXES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 19:04:18 -0400
Received: by mail-gg0-f201.google.com with SMTP id q6so1210ggc.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 16:04:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gang.chen@asianux.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()
has been added to the -mm tree.  Its filename is
     kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()

audit_trim_trees() calls get_tree().  If a failure occurs we must call
put_tree().

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/audit_tree.c~kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees kernel/audit_tree.c
--- a/kernel/audit_tree.c~kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees
+++ a/kernel/audit_tree.c
@@ -617,10 +617,10 @@ void audit_trim_trees(void)
 		}
 		spin_unlock(&hash_lock);
 		trim_marked(tree);
-		put_tree(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
 		mutex_lock(&audit_filter_mutex);
+		put_tree(tree);
 	}
 	list_del(&cursor);
 	mutex_unlock(&audit_filter_mutex);
_

Patches currently in -mm which might be from gang.chen@asianux.com are

linux-next.patch
kernel-auditfilter-resource-management-tree-and-watch-will-memory-leak-when-failure-occurs.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch

