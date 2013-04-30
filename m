From: akpm@linux-foundation.org
Subject: [merged] kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:27 -0700
Message-ID: <20130430184327.7E5325A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:42503 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3D3Sn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:28 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so84405vbe.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen@asianux.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()
has been removed from the -mm tree.  Its filename was
     kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()

audit_trim_trees() calls get_tree().  If a failure occurs we must call
put_tree().

[akpm@linux-foundation.org: run put_tree() before mutex_lock() for small scalability improvement]
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
@@ -617,9 +617,9 @@ void audit_trim_trees(void)
 		}
 		spin_unlock(&hash_lock);
 		trim_marked(tree);
-		put_tree(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
+		put_tree(tree);
 		mutex_lock(&audit_filter_mutex);
 	}
 	list_del(&cursor);
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
linux-next.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch

