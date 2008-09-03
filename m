From: akpm@linux-foundation.org
Subject: + res_counter-fix-off-by-one-bug-in-setting-limit.patch added to -mm tree
Date: Tue, 02 Sep 2008 17:17:09 -0700
Message-ID: <200809030017.m830H9aC020155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471AbYICARh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 20:17:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org


The patch titled
     res_counter: fix off-by-one bug in setting limit
has been added to the -mm tree.  Its filename is
     res_counter-fix-off-by-one-bug-in-setting-limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: res_counter: fix off-by-one bug in setting limit
From: Li Zefan <lizf@cn.fujitsu.com>

I found we can no longer set limit to 0 with 2.6.27-rcX:
 # mount -t cgroup -omemory xxx /mnt
 # mkdir /mnt/0
 # echo 0 > /mnt/0/memory.limit_in_bytes
 bash: echo: write error: Device or resource busy

It turned out 'limit' can't be set to 'usage', which is wrong IMO.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/res_counter.h~res_counter-fix-off-by-one-bug-in-setting-limit include/linux/res_counter.h
--- a/include/linux/res_counter.h~res_counter-fix-off-by-one-bug-in-setting-limit
+++ a/include/linux/res_counter.h
@@ -166,7 +166,7 @@ static inline int res_counter_set_limit(
 	int ret = -EBUSY;
 
 	spin_lock_irqsave(&cnt->lock, flags);
-	if (cnt->usage < limit) {
+	if (cnt->usage <= limit) {
 		cnt->limit = limit;
 		ret = 0;
 	}
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

devcgroup-fix-race-against-rmdir.patch
res_counter-fix-off-by-one-bug-in-setting-limit.patch
linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
devcgroup-use-kmemdup.patch
devcgroup-remove-unused-variable.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

