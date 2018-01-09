From: akpm@linux-foundation.org
Subject: + ipc-mqueue-add-missing-error-code-in-init_mqueue_fs.patch added to -mm tree
Date: Tue, 09 Jan 2018 15:33:02 -0800
Message-ID: <5a55512e.nVS4qEdBLyiMa5DU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932267AbeAIXdD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:33:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: add missing error code in init_mqueue_fs()
has been added to the -mm tree.  Its filename is
     ipc-mqueue-add-missing-error-code-in-init_mqueue_fs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-mqueue-add-missing-error-code-in-init_mqueue_fs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-mqueue-add-missing-error-code-in-init_mqueue_fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ipc/mqueue: add missing error code in init_mqueue_fs()

We should propogate the error code here but we accidentally return
success.

Link: http://lkml.kernel.org/r/20180109092919.ndrvscdllrmzz6jo@mwanda
Fixes: 946086abeddf ("mqueue: switch to on-demand creation of internal mount")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN ipc/mqueue.c~ipc-mqueue-add-missing-error-code-in-init_mqueue_fs ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-add-missing-error-code-in-init_mqueue_fs
+++ a/ipc/mqueue.c
@@ -1610,8 +1610,10 @@ static int __init init_mqueue_fs(void)
 		goto out_filesystem;
 
 	m = kern_mount_data(&mqueue_fs_type, &init_ipc_ns);
-	if (IS_ERR(m))
+	if (IS_ERR(m)) {
+		error = PTR_ERR(m);
 		goto out_filesystem;
+	}
 	init_ipc_ns.mq_mnt = m;
 	return 0;
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-hugetlb-get-rid-of-surplus-page-accounting-tricks-fix.patch
ipc-mqueue-add-missing-error-code-in-init_mqueue_fs.patch

