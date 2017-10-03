From: akpm@linux-foundation.org
Subject: +
 sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 03 Oct 2017 15:04:42 -0700
Message-ID: <59d4097a.8b2W43fqTT4ELfin%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbdJCWEn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 18:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -223,8 +223,8 @@ int ipc_get_maxid(struct ipc_ids *ids)
  */
 #define ipc_idr_alloc(ids, new)						\
 	idr_alloc(&(ids)->ipcs_idr, (new),				\
-		  (ids)->next_id < 0 ? 0: ipcid_to_idx((ids)->next_id), \
-		  0, GFP_NOWAIT);
+		  (ids)->next_id < 0 ? 0 : ipcid_to_idx((ids)->next_id),\
+		  0, GFP_NOWAIT)
 
 static inline int ipc_buildid(int id, struct ipc_ids *ids,
 			      struct kern_ipc_perm *new)
@@ -243,7 +243,7 @@ static inline int ipc_buildid(int id, st
 
 #else
 #define ipc_idr_alloc(ids, new)					\
-	idr_alloc(&(ids)->ipcs_idr, (new), 0, 0, GFP_NOWAIT);
+	idr_alloc(&(ids)->ipcs_idr, (new), 0, 0, GFP_NOWAIT)
 
 static inline int ipc_buildid(int id, struct ipc_ids *ids,
 			      struct kern_ipc_perm *new)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

