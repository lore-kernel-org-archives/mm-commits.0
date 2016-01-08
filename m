From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-cleanup-redunant-lksb-flags-in-dlmcommonh.patch added to -mm tree
Date: Fri, 08 Jan 2016 15:37:20 -0800
Message-ID: <56904830.3/EZufevblzDtzU9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbcAHXhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 18:37:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: cleanup redunant lksb flags in dlmcommon.h
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-cleanup-redunant-lksb-flags-in-dlmcommonh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-cleanup-redunant-lksb-flags-in-dlmcommonh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-cleanup-redunant-lksb-flags-in-dlmcommonh.patch

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
Subject: ocfs2/dlm: cleanup redunant lksb flags in dlmcommon.h

lksb flags are defined both in dlmapi.h and dlmcommon.h. So clean them
up from dlmcommon.h.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-cleanup-redunant-lksb-flags-in-dlmcommonh fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-cleanup-redunant-lksb-flags-in-dlmcommonh
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -376,17 +376,6 @@ struct dlm_lock
 		 lksb_kernel_allocated:1;
 };
 
-
-#define DLM_LKSB_UNUSED1           0x01
-#define DLM_LKSB_PUT_LVB           0x02
-#define DLM_LKSB_GET_LVB           0x04
-#define DLM_LKSB_UNUSED2           0x08
-#define DLM_LKSB_UNUSED3           0x10
-#define DLM_LKSB_UNUSED4           0x20
-#define DLM_LKSB_UNUSED5           0x40
-#define DLM_LKSB_UNUSED6           0x80
-
