From: akpm@linux-foundation.org
Subject: [merged] memcg-update-memcg_testtxt.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:59:29 -0400
Message-ID: <201003150700.o2F7028h016595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935747Ab0COHAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:00:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     memcg: update memcg_test.txt
has been removed from the -mm tree.  Its filename was
     memcg-update-memcg_testtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch

