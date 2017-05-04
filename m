From: akpm@linux-foundation.org
Subject: [merged] fs-ocfs2-cluster-use-offset_in_page-macro.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:08:49 -0700
Message-ID: <20170504190849.8Xd-qLZOt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756241AbdEDTIu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/cluster: use offset_in_page() macro
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-cluster-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: fs/ocfs2/cluster: use offset_in_page() macro

Use offset_in_page() macro instead of open-coding.

Link: http://lkml.kernel.org/r/4dbc77ccaaed98b183cf4dba58a4fa325fd65048.1492758503.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-use-offset_in_page-macro fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-use-offset_in_page-macro
+++ a/fs/ocfs2/cluster/tcp.c
@@ -955,7 +955,7 @@ static void o2net_sendpage(struct o2net_
 		mutex_lock(&sc->sc_send_lock);
 		ret = sc->sc_sock->ops->sendpage(sc->sc_sock,
 						 virt_to_page(kmalloced_virt),
-						 (long)kmalloced_virt & ~PAGE_MASK,
+						 offset_in_page(kmalloced_virt),
 						 size, MSG_DONTWAIT);
 		mutex_unlock(&sc->sc_send_lock);
 		if (ret == size)
_

Patches currently in -mm which might be from geliangtang@gmail.com are


