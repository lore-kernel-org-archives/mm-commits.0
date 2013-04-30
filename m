From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:03 -0700
Message-ID: <20130430184403.78AC031C2C5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:61291 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3D3SoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:04 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so84470vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix error return code in ocfs2_info_handle_freefrag()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: ocfs2: fix error return code in ocfs2_info_handle_freefrag()

Fix to return a negative error code from the error handling case instead
of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/ioctl.c~ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag
+++ a/fs/ocfs2/ioctl.c
@@ -706,8 +706,10 @@ int ocfs2_info_handle_freefrag(struct in
 
 	o2info_set_request_filled(&oiff->iff_req);
 
-	if (o2info_to_user(*oiff, req))
+	if (o2info_to_user(*oiff, req)) {
+		status = -EFAULT;
 		goto bail;
+	}
 
 	status = 0;
 bail:
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch
drivers-w1-slaves-w1_ds2780c-fix-the-error-handling-in-w1_ds2780_add_slave.patch
drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave.patch
drivers-w1-slaves-w1_ds2760c-fix-the-error-handling-in-w1_ds2760_add_slave.patch

