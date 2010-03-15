From: akpm@linux-foundation.org
Subject: [merged] memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:11 -0400
Message-ID: <201003150700.o2F70i5s016655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0COHBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, xemul@open


The patch titled
     memcg: update memcg_test.txt to describe memory thresholds
has been removed from the -mm tree.  Its filename was
     memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: update memcg_test.txt to describe memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Decription of sanity check for memory thresholds.

Signed-off-by: Kirill A.  Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memcg_test.txt |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN Documentation/cgroups/memcg_test.txt~memcg-update-memcg_testtxt-to-describe-memory-thresholds Documentation/cgroups/memcg_test.txt
--- a/Documentation/cgroups/memcg_test.txt~memcg-update-memcg_testtxt-to-describe-memory-thresholds
+++ a/Documentation/cgroups/memcg_test.txt
@@ -396,3 +396,24 @@ Under below explanation, we assume CONFI
 	memory.stat of both A and B.
 	See 8.2 of Documentation/cgroups/memory.txt to see what value should be
 	written to move_charge_at_immigrate.
+
+ 9.10 Memory thresholds
+	Memory controler implements memory thresholds using cgroups notification
+	API. You can use Documentation/cgroups/cgroup_event_listener.c to test
+	it.
+
+	(Shell-A) Create cgroup and run event listener
+	# mkdir /cgroup/A
+	# ./cgroup_event_listener /cgroup/A/memory.usage_in_bytes 5M
+
+	(Shell-B) Add task to cgroup and try to allocate and free memory
+	# echo $$ >/cgroup/A/tasks
+	# a="$(dd if=/dev/zero bs=1M count=10)"
+	# a=
+
+	You will see message from cgroup_event_listener every time you cross
+	the thresholds.
+
+	Use /cgroup/A/memory.memsw.usage_in_bytes to test memsw thresholds.
+
+	It's good idea to test root cgroup as well.
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

