From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:41:27 -0700
Message-ID: <523218e7.4mFKxCDXIvsUdlCF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, guozhonghua@h3c.com, error27@gmail.com, sunil.mushran@oracle.com

Subject: [merged] fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences.patch removed from -mm tree
To: sunil.mushran@oracle.com,error27@gmail.com,guozhonghua@h3c.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:27 -0700


The patch titled
     Subject: fs/ocfs2/cluster/tcp.c: fix possible null pointer dereferences
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: fs/ocfs2/cluster/tcp.c: fix possible null pointer dereferences

Fix some possible null pointer dereferences that were detected by the
static code analyser, smatch.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Reported-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences
+++ a/fs/ocfs2/cluster/tcp.c
@@ -543,8 +543,9 @@ static void o2net_set_nn_state(struct o2
 	}
 
 	if (was_valid && !valid) {
-		printk(KERN_NOTICE "o2net: No longer connected to "
-		       SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
+		if (old_sc)
+			printk(KERN_NOTICE "o2net: No longer connected to "
+				SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
 		o2net_complete_nodes_nsw(nn);
 	}
 
@@ -1695,13 +1696,12 @@ static void o2net_start_connect(struct w
 		ret = 0;
 
 out:
-	if (ret) {
+	if (ret && sc) {
 		printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
 		       " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
 		/* 0 err so that another will be queued and attempted
 		 * from set_nn_state */
-		if (sc)
-			o2net_ensure_shutdown(nn, sc, 0);
+		o2net_ensure_shutdown(nn, sc, 0);
 	}
 	if (sc)
 		sc_put(sc);
_

Patches currently in -mm which might be from sunil.mushran@oracle.com are

origin.patch

