From: akpm@linux-foundation.org
Subject: + ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch added to -mm tree
Date: Fri, 14 Aug 2015 14:13:12 -0700
Message-ID: <55ce59e8.6JpY/2PCguBSI9M3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbbHNVNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Aug 2015 17:13:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded code in ocfs2_dlm_init
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: remove unneeded code in ocfs2_dlm_init

status is already initialized and it will only be 0 or negatives in the
code flow.  So remove the unneeded assignment after the lable 'local'.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-remove-unneeded-code-in-ocfs2_dlm_init fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-remove-unneeded-code-in-ocfs2_dlm_init
+++ a/fs/ocfs2/dlmglue.c
@@ -3035,8 +3035,6 @@ local:
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
 
 	osb->cconn = conn;
