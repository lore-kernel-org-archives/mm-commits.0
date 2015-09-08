From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:10 -0700
Message-ID: <55ef22a2./V/upnlZFv6dg+ch%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbIHSCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded code in ocfs2_dlm_init
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
