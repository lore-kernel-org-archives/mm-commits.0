From: akpm@linux-foundation.org
Subject: [merged] ocfs2-dlm-remove-redundant-null-pointer-check.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:12 -0700
Message-ID: <20130430184412.79A8131C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:40809 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3D3SoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:13 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so84537vbe.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: remove redundant null pointer check
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-remove-redundant-null-pointer-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: ocfs2/dlm: remove redundant null pointer check

kfree on a NULL pointer is a no-op.  Remove the redundant null pointer
check.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-null-pointer-check fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-null-pointer-check
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1498,10 +1498,8 @@ leave:
 
 	dlm_put(dlm);
 	if (ret < 0) {
-		if (buf)
-			kfree(buf);
-		if (item)
-			kfree(item);
+		kfree(buf);
+		kfree(item);
 		mlog_errno(ret);
 	}
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

