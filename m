From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:02:14 -0700
Message-ID: <55ef22a6.kF0M9YyFo5/tLb0I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbbIHSCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded code in dlm_register_domain_handlers
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: remove unneeded code in dlm_register_domain_handlers

The last goto statement is unneeded, so remove it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1846,8 +1846,6 @@ static int dlm_register_domain_handlers(
 					sizeof(struct dlm_exit_domain),
 					dlm_begin_exit_domain_handler,
 					dlm, NULL, &dlm->dlm_domain_handlers);
-	if (status)
-		goto bail;
 
 bail:
 	if (status)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


