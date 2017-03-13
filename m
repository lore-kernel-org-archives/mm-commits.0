From: akpm@linux-foundation.org
Subject: + fs-ocfs2-cluster-use-setup_timer.patch added to -mm tree
Date: Mon, 13 Mar 2017 13:56:20 -0700
Message-ID: <58c70774.eg1IoXxFxh0qOwau%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbdCMU4W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2017 16:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/cluster: use setup_timer
has been added to the -mm tree.  Its filename is
     fs-ocfs2-cluster-use-setup_timer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-cluster-use-setup_timer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-cluster-use-setup_timer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-ocfs2-cluster-use-setup_timer.patch
writeback-use-setup_deferrable_timer.patch

