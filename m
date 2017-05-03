From: akpm@linux-foundation.org
Subject: [patch 004/102] fs/ocfs2/cluster: use setup_timer
Date: Wed, 03 May 2017 14:51:38 -0700
Message-ID: <20170503215138.02wNoC8PK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECVvj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:51:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geliangtang@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
