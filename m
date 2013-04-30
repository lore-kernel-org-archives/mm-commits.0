From: akpm@linux-foundation.org
Subject: [merged] kernel-auditfilter-resource-management-tree-and-watch-will-memory-leak-when-failure-occurs.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:30 -0700
Message-ID: <20130430184330.89D6B31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:65219 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3D3Snb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:31 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so85996qad.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen@asianux.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/auditfilter.c: tree and watch will memory leak when failure occurs
has been removed from the -mm tree.  Its filename was
     kernel-auditfilter-resource-management-tree-and-watch-will-memory-leak-when-failure-occurs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/auditfilter.c: tree and watch will memory leak when failure occurs

In audit_data_to_entry() when a failure occurs we must check and free the
tree and watch to avoid a memory leak.


  test:
    plan:
      test command:
        "auditctl -a exit,always -w /etc -F auid=-1"
        (on fedora17, need modify auditctl to let "-w /etc" has effect)
      running:
        under fedora17 x86_64, 2 CPUs 3.20GHz, 2.5GB RAM.
        let 15 auditctl processes continue running at the same time.
      monitor command:
        watch -d -n 1 "cat /proc/meminfo | awk '{print \$2}' \
          | head -n 4 | xargs \
          | awk '{print \"used \",\$1 - \$2 - \$3 - \$4}'"

    result:
      for original version:
        will use up all memory, within 3 hours.
        kill all auditctl, the memory still does not free.
      for new version (apply this patch):
        after 14 hours later, not find issues.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/auditfilter.c~kernel-auditfilter-resource-management-tree-and-watch-will-memory-leak-when-failure-occurs kernel/auditfilter.c
--- a/kernel/auditfilter.c~kernel-auditfilter-resource-management-tree-and-watch-will-memory-leak-when-failure-occurs
+++ a/kernel/auditfilter.c
@@ -594,6 +594,10 @@ exit_nofree:
 	return entry;
 
 exit_free:
+	if (entry->rule.watch)
+		audit_put_watch(entry->rule.watch); /* matches initial get */
+	if (entry->rule.tree)
+		audit_put_tree(entry->rule.tree); /* that's the temporary one */
 	audit_free_rule(entry);
 	return ERR_PTR(err);
 }
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
linux-next.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch

