From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-type-conversion-risk-when-get-cluster-attributes.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:30:17 -0700
Message-ID: <533f0849.mjDZ814O1TU4Uz63%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaDDTaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] ocfs2-fix-type-conversion-risk-when-get-cluster-attributes.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:17 -0700


The patch titled
     Subject: ocfs2: fix type conversion risk when get cluster attributes
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-type-conversion-risk-when-get-cluster-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix type conversion risk when get cluster attributes

In o2nm_cluster, cl_idle_timeout_ms, cl_keepalive_delay_ms, as well as
cl_reconnect_delay_ms, are defined as type of unsigned int.  So we should
also use unsigned int in the helper functions.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-fix-type-conversion-risk-when-get-cluster-attributes fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-fix-type-conversion-risk-when-get-cluster-attributes
+++ a/fs/ocfs2/cluster/tcp.c
@@ -262,17 +262,17 @@ static void o2net_update_recv_stats(stru
 
 #endif /* CONFIG_OCFS2_FS_STATS */
 
-static inline int o2net_reconnect_delay(void)
+static inline unsigned int o2net_reconnect_delay(void)
 {
 	return o2nm_single_cluster->cl_reconnect_delay_ms;
 }
 
-static inline int o2net_keepalive_delay(void)
+static inline unsigned int o2net_keepalive_delay(void)
 {
 	return o2nm_single_cluster->cl_keepalive_delay_ms;
 }
 
-static inline int o2net_idle_timeout(void)
+static inline unsigned int o2net_idle_timeout(void)
 {
 	return o2nm_single_cluster->cl_idle_timeout_ms;
 }
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch

