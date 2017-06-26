From: akpm@linux-foundation.org
Subject: +
 ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak.patch added to -mm tree
Date: Mon, 26 Jun 2017 15:58:33 -0700
Message-ID: <59519199.ayzDzHGEpKXlPfKf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdFZW6e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 18:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: free 'dummy_sc' in sc_fop_release() to prevent memory leak
has been added to the -mm tree.  Its filename is
     ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: free 'dummy_sc' in sc_fop_release() to prevent memory leak

'sd->dbg_sock' is malloced in sc_common_open(), but not freed at the end
of sc_fop_release().

Link: http://lkml.kernel.org/r/594FB0A4.2050105@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/netdebug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/cluster/netdebug.c~ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak fs/ocfs2/cluster/netdebug.c
--- a/fs/ocfs2/cluster/netdebug.c~ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak
+++ a/fs/ocfs2/cluster/netdebug.c
@@ -426,6 +426,7 @@ static int sc_fop_release(struct inode *
 	struct o2net_sock_container *dummy_sc = sd->dbg_sock;
 
 	o2net_debug_del_sc(dummy_sc);
+	kfree(dummy_sc);
 	return seq_release_private(inode, file);
 }
 
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak.patch

