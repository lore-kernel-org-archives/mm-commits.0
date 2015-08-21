From: akpm@linux-foundation.org
Subject: + ocfs2-fix-bug-when-o2hb_register_callback-fails.patch added to
 -mm tree
Date: Fri, 21 Aug 2015 13:59:19 -0700
Message-ID: <55d79127.7nSS4MlVz4BcQ3ft%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbbHUU7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Aug 2015 16:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix BUG when o2hb_register_callback fails
has been added to the -mm tree.  Its filename is
     ocfs2-fix-bug-when-o2hb_register_callback-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-bug-when-o2hb_register_callback-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-bug-when-o2hb_register_callback-fails.patch

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
Subject: ocfs2: fix BUG when o2hb_register_callback fails

In dlm_register_domain_handlers, if o2hb_register_callback fails, it will
call dlm_unregister_domain_handlers to unregister.  This will trigger the
BUG_ON in o2hb_unregister_callback because hc_magic is 0.  So we should
call o2hb_setup_callback to initialize hc first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-bug-when-o2hb_register_callback-fails fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-bug-when-o2hb_register_callback-fails
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1725,12 +1725,13 @@ static int dlm_register_domain_handlers(
 
 	o2hb_setup_callback(&dlm->dlm_hb_down, O2HB_NODE_DOWN_CB,
 			    dlm_hb_node_down_cb, dlm, DLM_HB_NODE_DOWN_PRI);
+	o2hb_setup_callback(&dlm->dlm_hb_up, O2HB_NODE_UP_CB,
+			    dlm_hb_node_up_cb, dlm, DLM_HB_NODE_UP_PRI);
+
 	status = o2hb_register_callback(dlm->name, &dlm->dlm_hb_down);
 	if (status)
 		goto bail;
 
-	o2hb_setup_callback(&dlm->dlm_hb_up, O2HB_NODE_UP_CB,
-			    dlm_hb_node_up_cb, dlm, DLM_HB_NODE_UP_PRI);
 	status = o2hb_register_callback(dlm->name, &dlm->dlm_hb_up);
 	if (status)
 		goto bail;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-fix-several-issues-of-append-dio.patch
ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch
ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
ocfs2-adjust-code-to-match-locking-unlocking-order.patch
ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch
ocfs2-fix-bug-when-o2hb_register_callback-fails.patch
ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch

