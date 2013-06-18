From: akpm@linux-foundation.org
Subject: + fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch
 added to -mm tree
Date: Tue, 18 Jun 2013 13:41:57 -0700
Message-ID: <51c0c615.FRgpgRJrxhjMe5/p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3FRUl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 16:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: + fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch added to -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 13:41:57 -0700


The patch titled
     Subject: fs/ocfs2/cluster/tcp.c: free sc->sc_page in sc_kref_release()
has been added to the -mm tree.  Its filename is
     fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch

