From: akpm@linux-foundation.org
Subject: + fs-ocfs2-cluster-use-offset_in_page-macro.patch added to -mm
 tree
Date: Tue, 25 Apr 2017 14:27:33 -0700
Message-ID: <58ffbf45.o2CxZMQlruAGm1CM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1954878AbdDYV1e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 17:27:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/cluster: use offset_in_page() macro
has been added to the -mm tree.  Its filename is
     fs-ocfs2-cluster-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-cluster-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-cluster-use-offset_in_page-macro.patch

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

fs-ocfs2-cluster-use-setup_timer.patch
fs-ocfs2-cluster-use-offset_in_page-macro.patch
writeback-use-setup_deferrable_timer.patch

