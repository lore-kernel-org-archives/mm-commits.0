From: akpm@linux-foundation.org
Subject: + memcg-update-memcg_testtxt.patch added to -mm tree
Date: Tue, 16 Feb 2010 13:35:01 -0800
Message-ID: <201002162135.o1GLZ1B6006357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933090Ab0BPVfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 16:35:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name


The patch titled
     memcg: update memcg_test.txt
has been added to the -mm tree.  Its filename is
     memcg-update-memcg_testtxt.patch

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
Subject: memcg: update memcg_test.txt
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Update memcg_test.txt to describe how to test the move-charge feature.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memcg_test.txt |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/memcg_test.txt~memcg-update-memcg_testtxt Documentation/cgroups/memcg_test.txt
--- a/Documentation/cgroups/memcg_test.txt~memcg-update-memcg_testtxt
+++ a/Documentation/cgroups/memcg_test.txt
@@ -1,6 +1,6 @@
 Memory Resource Controller(Memcg)  Implementation Memo.
-Last Updated: 2009/1/20
-Base Kernel Version: based on 2.6.29-rc2.
+Last Updated: 2010/2
+Base Kernel Version: based on 2.6.33-rc7-mm(candidate for 34).
 
 Because VM is getting complex (one of reasons is memcg...), memcg's behavior
 is complex. This is a document for memcg's internal behavior.
@@ -378,3 +378,21 @@ Under below explanation, we assume CONFI
 	#echo 50M > memory.limit_in_bytes
 	#echo 50M > memory.memsw.limit_in_bytes
 	run 51M of malloc
+
+ 9.9 Move charges at task migration
+	Charges associated with a task can be moved along with task migration.
+
+	(Shell-A)
+	#mkdir /cgroup/A
+	#echo $$ >/cgroup/A/tasks
+	run some programs which uses some amount of memory in /cgroup/A.
+
+	(Shell-B)
+	#mkdir /cgroup/B
+	#echo 1 >/cgroup/B/memory.move_charge_at_immigrate
+	#echo "pid of the program running in group A" >/cgroup/B/tasks
+
+	You can see charges have been moved by reading *.usage_in_bytes or
+	memory.stat of both A and B.
+	See 8.2 of Documentation/cgroups/memory.txt to see what value should be
+	written to move_charge_at_immigrate.
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-fix-oom-killing-a-child-process-in-an-other-cgroup.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch

