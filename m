From: akpm@linux-foundation.org
Subject: + ocfs2-do-not-log-enoent-in-unlink.patch added to -mm tree
Date: Fri, 24 Jan 2014 12:34:33 -0800
Message-ID: <52e2ce59.O6odfADNLNN3f4jf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaAXUee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 15:34:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joe.jin@oracle.com, jlbec@evilplan.org, xiaowei.hu@oracle.com

Subject: + ocfs2-do-not-log-enoent-in-unlink.patch added to -mm tree
To: xiaowei.hu@oracle.com,jlbec@evilplan.org,joe.jin@oracle.com,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 12:34:33 -0800


The patch titled
     Subject: ocfs2: do not log ENOENT in unlink()
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-log-enoent-in-unlink.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-log-enoent-in-unlink.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-log-enoent-in-unlink.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
Subject: ocfs2: do not log ENOENT in unlink()

Suppress log message like this: (open_delete,8328,0):ocfs2_unlink:951
ERROR: status = -2

Orabug:17445485

Cc: Joe Jin <joe.jin@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/namei.c~ocfs2-do-not-log-enoent-in-unlink fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-do-not-log-enoent-in-unlink
+++ a/fs/ocfs2/namei.c
@@ -948,7 +948,7 @@ leave:
 	ocfs2_free_dir_lookup_result(&orphan_insert);
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	if (status && (status != -ENOTEMPTY))
+	if (status && (status != -ENOTEMPTY) && (status != -ENOENT))
 		mlog_errno(status);
 
 	return status;
_

Patches currently in -mm which might be from xiaowei.hu@oracle.com are

ocfs2-do-not-log-enoent-in-unlink.patch

