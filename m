From: akpm@linux-foundation.org
Subject: [folded-merged]
 sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
 removed from -mm tree
Date: Fri, 17 Nov 2017 15:18:59 -0800
Message-ID: <5a0f6e63.GuJ1xr2KnEY9QLzS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030451AbdKQXTB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:19:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch

This patch was dropped because it was folded into sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#14: 
03f595668017f ("ipc: add sysctl to specify desired next object id"). 

WARNING: macros should not use a trailing semicolon
#75: FILE: ipc/util.c:224:
+#define ipc_idr_alloc(ids, new)						\
+	idr_alloc(&(ids)->ipcs_idr, (new),				\
+		  (ids)->next_id < 0 ? 0: ipcid_to_idx((ids)->next_id), \
+		  0, GFP_NOWAIT);

ERROR: spaces required around that ':' (ctx:VxW)
#77: FILE: ipc/util.c:226:
+		  (ids)->next_id < 0 ? 0: ipcid_to_idx((ids)->next_id), \
 		                        ^

WARNING: macros should not use a trailing semicolon
#96: FILE: ipc/util.c:245:
+#define ipc_idr_alloc(ids, new)					\
+	idr_alloc(&(ids)->ipcs_idr, (new), 0, 0, GFP_NOWAIT);

total: 2 errors, 2 warnings, 117 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN ipc/util.c~sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes ipc/util.c
--- a/ipc/util.c~sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes
+++ a/ipc/util.c
@@ -224,8 +224,8 @@ int ipc_get_maxid(struct ipc_ids *ids)
  */
 #define ipc_idr_alloc(ids, new)						\
 	idr_alloc(&(ids)->ipcs_idr, (new),				\
-		  (ids)->next_id < 0 ? 0: ipcid_to_idx((ids)->next_id), \
-		  0, GFP_NOWAIT);
+		  (ids)->next_id < 0 ? 0 : ipcid_to_idx((ids)->next_id),\
+		  0, GFP_NOWAIT)
 
 static inline int ipc_buildid(int id, struct ipc_ids *ids,
 			      struct kern_ipc_perm *new)
@@ -244,7 +244,7 @@ static inline int ipc_buildid(int id, st
 
 #else
 #define ipc_idr_alloc(ids, new)					\
-	idr_alloc(&(ids)->ipcs_idr, (new), 0, 0, GFP_NOWAIT);
+	idr_alloc(&(ids)->ipcs_idr, (new), 0, 0, GFP_NOWAIT)
 
 static inline int ipc_buildid(int id, struct ipc_ids *ids,
 			      struct kern_ipc_perm *new)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch

