From: akpm@linux-foundation.org
Subject: + kernel-auditfilter-resource-management-tree-and-watch-will-memory-leak-when-failure-occurs.patch added to -mm tree
Date: Wed, 17 Apr 2013 13:09:46 -0700
Message-ID: <20130417200946.813E05AA07D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46739 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067Ab3DQUJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Apr 2013 16:09:50 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so120844ghb.3
        for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2013 13:09:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gang.chen@asianux.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/auditfilter.c: tree and watch will memory leak when failure occurs
has been added to the -mm tree.  Its filename is
     kernel-auditfilter-resource-management-tree-and-watch-will-memory-leak-when-failure-occurs.patch

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

linux-next.patch
kernel-auditfilter-resource-management-tree-and-watch-will-memory-leak-when-failure-occurs.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch

