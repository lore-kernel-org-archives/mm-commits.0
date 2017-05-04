From: akpm@linux-foundation.org
Subject: [merged] fs-ocfs2-cluster-use-setup_timer.patch removed
 from -mm tree
Date: Thu, 04 May 2017 12:08:42 -0700
Message-ID: <20170504190842.vqxNtBHBn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756220AbdEDTIo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:08:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/cluster: use setup_timer
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-cluster-use-setup_timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: fs/ocfs2/cluster: use setup_timer

Use setup_timer() instead of init_timer() to simplify the code.

Link: http://lkml.kernel.org/r/5e75bf07beb91e092d5aa36c36769949a480456a.1489060564.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-use-setup_timer fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-use-setup_timer
+++ a/fs/ocfs2/cluster/tcp.c
@@ -450,9 +450,8 @@ static struct o2net_sock_container *sc_a
 	INIT_WORK(&sc->sc_shutdown_work, o2net_shutdown_sc);
 	INIT_DELAYED_WORK(&sc->sc_keepalive_work, o2net_sc_send_keep_req);
 
-	init_timer(&sc->sc_idle_timeout);
-	sc->sc_idle_timeout.function = o2net_idle_timer;
-	sc->sc_idle_timeout.data = (unsigned long)sc;
+	setup_timer(&sc->sc_idle_timeout, o2net_idle_timer,
+		    (unsigned long)sc);
 
 	sclog(sc, "alloced\n");
 
_

Patches currently in -mm which might be from geliangtang@gmail.com are


