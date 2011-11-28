From: akpm@linux-foundation.org
Subject: [merged] netprio_cgroup-fix-build-break.patch removed from -mm tree
Date: Mon, 28 Nov 2011 12:59:32 -0800
Message-ID: <201111282059.pASKxXBX006097@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:65377 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab1K1U7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 15:59:42 -0500
Received: by wwp14 with SMTP id 14so158636wwp.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 12:59:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, davem@davemloft.net, john.r.fastabend@intel.com, kirr@mns.spb.ru, robert.w.love@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: netprio_cgroup: fix build break
has been removed from the -mm tree.  Its filename was
     netprio_cgroup-fix-build-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
