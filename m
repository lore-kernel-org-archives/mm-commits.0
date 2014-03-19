From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-type-conversion-risk-when-get-cluster-attributes.patch added to
 -mm tree
Date: Wed, 19 Mar 2014 13:57:34 -0700
Message-ID: <532a04be.sAQb6aBtXqQWIdzz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbaCSU5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 16:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: + ocfs2-fix-type-conversion-risk-when-get-cluster-attributes.patch added to -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 13:57:34 -0700


The patch titled
     Subject: ocfs2: fix type conversion risk when get cluster attributes
has been added to the -mm tree.  Its filename is
     ocfs2-fix-type-conversion-risk-when-get-cluster-attributes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-type-conversion-risk-when-get-cluster-attributes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-type-conversion-risk-when-get-cluster-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch
ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
ocfs2-fix-type-conversion-risk-when-get-cluster-attributes.patch

