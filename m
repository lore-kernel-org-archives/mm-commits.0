From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-redundant-re-initialization.patch added to -mm tree
Date: Mon, 23 May 2016 14:34:47 -0700
Message-ID: <57437777.Iucb16rUSIY5Y740%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbcEWVes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 17:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zren@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a redundant re-initialization
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-redundant-re-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-redundant-re-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-redundant-re-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Ren <zren@suse.com>
Subject: ocfs2: fix a redundant re-initialization

Obviously, memset() has zeroed the whole struct locking_max_version.
So, it's no need to zero its two fields individually.

Link: http://lkml.kernel.org/r/1463970605-18354-1-git-send-email-zren@suse.com
Signed-off-by: Eric Ren <zren@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-fix-a-redundant-re-initialization fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-fix-a-redundant-re-initialization
+++ a/fs/ocfs2/stackglue.c
@@ -735,8 +735,6 @@ static void __exit ocfs2_stack_glue_exit
 {
 	memset(&locking_max_version, 0,
 	       sizeof(struct ocfs2_protocol_version));
-	locking_max_version.pv_major = 0;
-	locking_max_version.pv_minor = 0;
 	ocfs2_sysfs_exit();
 	if (ocfs2_table_header)
 		unregister_sysctl_table(ocfs2_table_header);
_

Patches currently in -mm which might be from zren@suse.com are

ocfs2-fix-improper-handling-of-return-errno.patch
ocfs2-fix-a-redundant-re-initialization.patch

