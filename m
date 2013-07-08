From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:14 -0700
Message-ID: <51db11a2.+gPIzzfAGXcEWwk4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3GHTXP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: [merged] fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch removed from -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:14 -0700


The patch titled
     Subject: fs/ocfs2/cluster/tcp.c: free sc->sc_page in sc_kref_release()
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: fs/ocfs2/cluster/tcp.c: free sc->sc_page in sc_kref_release()

There is a memory leak in sc_kref_release().  When free struct
o2net_sock_container (sc), we should release sc->sc_page.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release
+++ a/fs/ocfs2/cluster/tcp.c
@@ -406,6 +406,9 @@ static void sc_kref_release(struct kref
 	sc->sc_node = NULL;
 
 	o2net_debug_del_sc(sc);
+
+	if (sc->sc_page)
+		__free_page(sc->sc_page);
 	kfree(sc);
 }
 
_

Patches currently in -mm which might be from younger.liu@huawei.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch

