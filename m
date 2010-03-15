From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-some-unnecessary-casting.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:49 -0400
Message-ID: <201003150655.o2F6tMm9016151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759759Ab0COGza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove some unnecessary casting
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-some-unnecessary-casting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove some unnecessary casting
From: Joe Perches <joe@perches.com>

Remove char/void __user * use.
Remove kmalloc cast.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-some-unnecessary-casting drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-some-unnecessary-casting
+++ a/drivers/block/floppy.c
@@ -3104,13 +3104,13 @@ static struct cont_t raw_cmd_cont = {
 	.done		= raw_cmd_done
 };
 
-static inline int raw_cmd_copyout(int cmd, char __user *param,
+static inline int raw_cmd_copyout(int cmd, void __user *param,
 				  struct floppy_raw_cmd *ptr)
 {
 	int ret;
 
 	while (ptr) {
-		ret = copy_to_user((void __user *)param, ptr, sizeof(*ptr));
+		ret = copy_to_user(param, ptr, sizeof(*ptr));
 		if (ret)
 			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
@@ -3148,7 +3148,7 @@ static void raw_cmd_free(struct floppy_r
 	}
 }
 
-static inline int raw_cmd_copyin(int cmd, char __user *param,
+static inline int raw_cmd_copyin(int cmd, void __user *param,
 				 struct floppy_raw_cmd **rcmd)
 {
 	struct floppy_raw_cmd *ptr;
@@ -3157,12 +3157,11 @@ static inline int raw_cmd_copyin(int cmd
 
 	*rcmd = NULL;
 	while (1) {
-		ptr = (struct floppy_raw_cmd *)
-		    kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
+		ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
 		if (!ptr)
 			return -ENOMEM;
 		*rcmd = ptr;
-		ret = copy_from_user(ptr, (void __user *)param, sizeof(*ptr));
+		ret = copy_from_user(ptr, param, sizeof(*ptr));
 		if (ret)
 			return -EFAULT;
 		ptr->next = NULL;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

