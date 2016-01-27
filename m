From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-a-typo-in-dlmcommonh.patch added to -mm tree
Date: Tue, 26 Jan 2016 19:45:31 -0800
Message-ID: <56a83d5b.XwiG/wYG/kYB4TND%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbcA0Dpd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix a typo in dlmcommon.h
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-a-typo-in-dlmcommonh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-a-typo-in-dlmcommonh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-a-typo-in-dlmcommonh.patch

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
Subject: ocfs2/dlm: fix a typo in dlmcommon.h

Refer to cluster/tcp.h, NET_MAX_PAYLOAD_BYTES is a typo for
O2NET_MAX_PAYLOAD_BYTES.

Since currently DLM_MIG_LOCKRES_RESERVED is not actually used, it won't
cause any problem.  But we'd better correct it for further use.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-fix-a-typo-in-dlmcommonh fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-fix-a-typo-in-dlmcommonh
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -546,7 +546,7 @@ struct dlm_master_requery
  * };
  *
  * from ../cluster/tcp.h
- *    NET_MAX_PAYLOAD_BYTES  (4096 - sizeof(net_msg))
+ *    O2NET_MAX_PAYLOAD_BYTES  (4096 - sizeof(net_msg))
  *    (roughly 4080 bytes)
  * and sizeof(dlm_migratable_lockres) = 112 bytes
  * and sizeof(dlm_migratable_lock) = 16 bytes
@@ -587,7 +587,7 @@ struct dlm_migratable_lockres
 
 /* from above, 128 bytes
  * for some undetermined future use */
-#define DLM_MIG_LOCKRES_RESERVED   (NET_MAX_PAYLOAD_BYTES - \
+#define DLM_MIG_LOCKRES_RESERVED   (O2NET_MAX_PAYLOAD_BYTES - \
 				    DLM_MIG_LOCKRES_MAX_LEN)
 
 struct dlm_create_lock
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-cluster-fix-memory-leak-in-o2hb_region_release.patch
ocfs2-dlm-fix-a-typo-in-dlmcommonh.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

