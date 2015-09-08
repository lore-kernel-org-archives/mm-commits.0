From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-bug-when-o2hb_register_callback-fails.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:12 -0700
Message-ID: <55ef22a4.J6XJAuL3GFee5YWW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbIHSCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix BUG when o2hb_register_callback fails
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-bug-when-o2hb_register_callback-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


