From: akpm@linux-foundation.org
Subject: + ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch added to -mm tree
Date: Wed, 25 Feb 2015 14:42:29 -0800
Message-ID: <54ee4fd5.mSiSaMHX7lQRUAfE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbbBYWma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Feb 2015 17:42:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: avoid a pointless delay in o2cb_cluster_check()
has been added to the -mm tree.  Its filename is
     ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: avoid a pointless delay in o2cb_cluster_check()

Fix an off-by-one when attempting to avoid an msleep() on the final loop
iteration.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_o2cb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/stack_o2cb.c~ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check fs/ocfs2/stack_o2cb.c
--- a/fs/ocfs2/stack_o2cb.c~ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check
+++ a/fs/ocfs2/stack_o2cb.c
@@ -295,7 +295,7 @@ static int o2cb_cluster_check(void)
 		set_bit(node_num, netmap);
 		if (!memcmp(hbmap, netmap, sizeof(hbmap)))
 			return 0;
-		if (i < O2CB_MAP_STABILIZE_COUNT)
+		if (i < O2CB_MAP_STABILIZE_COUNT - 1)
 			msleep(1000);
 	}
 
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

ocfs2-remove-unneeded-rc-for-kfree.patch
ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch

