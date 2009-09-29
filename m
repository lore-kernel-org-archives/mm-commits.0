From: akpm@linux-foundation.org
Subject: + cgroup-catch-bad-css-refcnt-at-css_put.patch added to -mm tree
Date: Tue, 29 Sep 2009 12:46:25 -0700
Message-ID: <200909291946.n8TJkP4q031612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbZI2Tqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     cgroup: catch bad css refcnt at css_put
has been added to the -mm tree.  Its filename is
     cgroup-catch-bad-css-refcnt-at-css_put.patch

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
Subject: cgroup: catch bad css refcnt at css_put
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

__css_put() doesn't check a bug as refcnt goes to minus.
I think it should be caught. This patch adds a check for it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-catch-bad-css-refcnt-at-css_put kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-catch-bad-css-refcnt-at-css_put
+++ a/kernel/cgroup.c
@@ -3708,8 +3708,10 @@ static void check_for_release(struct cgr
 void __css_put(struct cgroup_subsys_state *css)
 {
 	struct cgroup *cgrp = css->cgroup;
+	int val;
 	rcu_read_lock();
-	if (atomic_dec_return(&css->refcnt) == 1) {
+	val = atomic_dec_return(&css->refcnt);
+	if (val == 1) {
 		if (notify_on_release(cgrp)) {
 			set_bit(CGRP_RELEASABLE, &cgrp->flags);
 			check_for_release(cgrp);
@@ -3717,6 +3719,7 @@ void __css_put(struct cgroup_subsys_stat
 		cgroup_wakeup_rmdir_waiter(cgrp);
 	}
 	rcu_read_unlock();
+	WARN_ON_ONCE(val < 1);
 }
 
 /*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-refcnt-goes-to-minus.patch
cgroup-catch-bad-css-refcnt-at-css_put.patch
memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim.patch
memcg-reduce-check-for-softlimit-excess.patch

