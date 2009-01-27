From: akpm@linux-foundation.org
Subject: + memcg-update-document-to-mention-swapoff-should-be-test.patch added to -mm tree
Date: Mon, 26 Jan 2009 22:55:50 -0800
Message-ID: <200901270655.n0R6toEK018889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbZA0G4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 01:56:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: update document to mention that swapoff should be tested
has been added to the -mm tree.  Its filename is
     memcg-update-document-to-mention-swapoff-should-be-test.patch

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
Subject: memcg: update document to mention that swapoff should be tested
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Considering the recently found problem "memcg: fix refcnt handling at
swapoff", it's better to mention swapoff behavior in the memcg_test
document.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memcg_test.txt |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/memcg_test.txt~memcg-update-document-to-mention-swapoff-should-be-test Documentation/cgroups/memcg_test.txt
--- a/Documentation/cgroups/memcg_test.txt~memcg-update-document-to-mention-swapoff-should-be-test
+++ a/Documentation/cgroups/memcg_test.txt
@@ -1,6 +1,6 @@
 Memory Resource Controller(Memcg)  Implementation Memo.
-Last Updated: 2008/12/15
-Base Kernel Version: based on 2.6.28-rc8-mm.
+Last Updated: 2009/1/19
+Base Kernel Version: based on 2.6.29-rc2.
 
 Because VM is getting complex (one of reasons is memcg...), memcg's behavior
 is complex. This is a document for memcg's internal behavior.
@@ -340,3 +340,23 @@ Under below explanation, we assume CONFI
 	# mount -t cgroup none /cgroup -t cpuset,memory,cpu,devices
 
 	and do task move, mkdir, rmdir etc...under this.
+
+ 9.7 swapoff.
+	Besides management of swap is one of complicated parts of memcg,
+	call path of swap-in at swapoff is not same as usual swap-in path..
+	It's worth to be tested explicitly.
+
+	For example, test like following is good.
+	(Shell-A)
+	# mount -t cgroup none /cgroup -t memory
+	# mkdir /cgroup/test
+	# echo 40M > /cgroup/test/memory.limit_in_bytes
+	# echo 0 > /cgroup/test/tasks
+	Run malloc(100M) program under this. You'll see 60M of swaps.
+	(Shell-B)
+	# move all tasks in /cgroup/test to /cgroup
+	# /sbin/swapoff -a
+	# rmdir /test/cgroup
+	# kill malloc task.
+
+	Of course, tmpfs v.s. swapoff test should be tested, too.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

cgroups-use-hierarchy-mutex-in-creation-failure-path.patch
memcg-get-put-parents-at-create-free.patch
memcg-get-put-parents-at-create-free-fix.patch
memcg-fix-refcnt-handling-at-swapoff.patch
memcg-update-document-to-mention-swapoff-should-be-test.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch

