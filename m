From: akpm@linux-foundation.org
Subject: + netprio_cgroup-fix-build-break.patch added to -mm tree
Date: Wed, 23 Nov 2011 15:22:15 -0800
Message-ID: <201111232322.pANNMFUQ029417@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:58996 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab1KWXW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2011 18:22:29 -0500
Received: by qyk10 with SMTP id 10so208346qyk.1
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2011 15:22:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, davem@davemloft.net, john.r.fastabend@intel.com, kirr@mns.spb.ru, robert.w.love@intel.com, sfr@canb.auug.org.au


The patch titled
     Subject: netprio_cgroup: fix build break
has been added to the -mm tree.  Its filename is
     netprio_cgroup-fix-build-break.patch

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
From: Neil Horman <nhorman@tuxdriver.com>
Subject: netprio_cgroup: fix build break

I broke the build with the addition of netprio_cgroups if CONFIG_CGROUPS=n.
This patch corrects it by moving the offending struct into an ifdef
CONFIG_CGROUPS block.  Also clean up a few needless defines and inline functions
that don't get called if CONFIG_CGROUPS isn't defined while Im at it.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Kirill Smelkov <kirr@mns.spb.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: John Fastabend <john.r.fastabend@intel.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/netprio_cgroup.h |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN include/net/netprio_cgroup.h~netprio_cgroup-fix-build-break include/net/netprio_cgroup.h
--- a/include/net/netprio_cgroup.h~netprio_cgroup-fix-build-break
+++ a/include/net/netprio_cgroup.h
@@ -18,11 +18,6 @@
 #include <linux/hardirq.h>
 #include <linux/rcupdate.h>
 
-struct cgroup_netprio_state
-{
-	struct cgroup_subsys_state css;
-	u32 prioidx;
-};
 
 struct netprio_map {
 	struct rcu_head rcu;
@@ -32,6 +27,11 @@ struct netprio_map {
 
 #ifdef CONFIG_CGROUPS
 
+struct cgroup_netprio_state {
+	struct cgroup_subsys_state css;
+	u32 prioidx;
+};
+
 #ifndef CONFIG_NETPRIO_CGROUP
 extern int net_prio_subsys_id;
 #endif
@@ -52,14 +52,6 @@ static inline struct cgroup_netprio_stat
 #else
 
 #define sock_update_netprioidx(sk)
-#define skb_update_prio(skb)
-
-static inline struct cgroup_netprio_state
-		*task_netprio_state(struct task_struct *p)
-{
-	return NULL;
-}
