From: akpm@linux-foundation.org
Subject: + cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch added to -mm tree
Date: Wed, 04 Mar 2009 13:47:05 -0800
Message-ID: <200903042147.n24Ll5Xi006321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637AbZCDVrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:47:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharata@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup: remove rcu_read_lock() from css_get_next()
has been added to the -mm tree.  Its filename is
     cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch

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
Subject: cgroup: remove rcu_read_lock() from css_get_next()
From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Callers of css_get_next() are already calling css_get_next() under
rcu_read_lock() and hence there there is no need for css_get_next() to
re-acquire rcu_read_lock().  As per the comments in css_get_next(), let
the callers accquire the rcu_read_lock().

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/cgroup.c~cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next
+++ a/kernel/cgroup.c
@@ -3500,7 +3500,6 @@ css_get_next(struct cgroup_subsys *ss, i
 		return NULL;
 
 	BUG_ON(!ss->use_id);
-	rcu_read_lock();
 	/* fill start point for scan */
 	tmpid = id;
 	while (1) {
@@ -3524,8 +3523,6 @@ css_get_next(struct cgroup_subsys *ss, i
 		/* continue to scan from next id */
 		tmpid = tmpid + 1;
 	}
