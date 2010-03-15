From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:53 -0400
Message-ID: <201003150655.o2F6tQCn016155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759761Ab0COGzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: convert raw_cmd_copyin from while(1) to label: goto
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: convert raw_cmd_copyin from while(1) to label: goto
From: Joe Perches <joe@perches.com>

Reduces indent.
Makes a bit more readable and intelligible.
Return value now at bottom of function.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   73 ++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 35 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto
+++ a/drivers/block/floppy.c
@@ -3126,6 +3126,7 @@ static inline int raw_cmd_copyout(int cm
 		}
 		ptr = ptr->next;
 	}
+
 	return 0;
 }
 
@@ -3156,18 +3157,19 @@ static inline int raw_cmd_copyin(int cmd
 	int i;
 
 	*rcmd = NULL;
-	while (1) {
-		ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
-		if (!ptr)
-			return -ENOMEM;
-		*rcmd = ptr;
-		ret = copy_from_user(ptr, param, sizeof(*ptr));
-		if (ret)
-			return -EFAULT;
-		ptr->next = NULL;
-		ptr->buffer_length = 0;
-		param += sizeof(struct floppy_raw_cmd);
-		if (ptr->cmd_count > 33)
+
+loop:
+	ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
+	if (!ptr)
+		return -ENOMEM;
+	*rcmd = ptr;
+	ret = copy_from_user(ptr, param, sizeof(*ptr));
+	if (ret)
+		return -EFAULT;
+	ptr->next = NULL;
+	ptr->buffer_length = 0;
+	param += sizeof(struct floppy_raw_cmd);
+	if (ptr->cmd_count > 33)
 			/* the command may now also take up the space
 			 * initially intended for the reply & the
 			 * reply count. Needed for long 82078 commands
@@ -3176,34 +3178,35 @@ static inline int raw_cmd_copyin(int cmd
 			 * 16 bytes for a structure, you'll one day
 			 * discover that you really need 17...
 			 */
+		return -EINVAL;
+
+	for (i = 0; i < 16; i++)
+		ptr->reply[i] = 0;
+	ptr->resultcode = 0;
+	ptr->kernel_data = NULL;
+
+	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
+		if (ptr->length <= 0)
 			return -EINVAL;
+		ptr->kernel_data = (char *)fd_dma_mem_alloc(ptr->length);
+		fallback_on_nodma_alloc(&ptr->kernel_data, ptr->length);
+		if (!ptr->kernel_data)
+			return -ENOMEM;
+		ptr->buffer_length = ptr->length;
+	}
+	if (ptr->flags & FD_RAW_WRITE) {
+		ret = fd_copyin(ptr->data, ptr->kernel_data, ptr->length);
+		if (ret)
+			return ret;
+	}
 
-		for (i = 0; i < 16; i++)
-			ptr->reply[i] = 0;
-		ptr->resultcode = 0;
-		ptr->kernel_data = NULL;
-
-		if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
-			if (ptr->length <= 0)
-				return -EINVAL;
-			ptr->kernel_data =
-			    (char *)fd_dma_mem_alloc(ptr->length);
-			fallback_on_nodma_alloc(&ptr->kernel_data, ptr->length);
-			if (!ptr->kernel_data)
-				return -ENOMEM;
-			ptr->buffer_length = ptr->length;
-		}
-		if (ptr->flags & FD_RAW_WRITE) {
-			ret = fd_copyin(ptr->data, ptr->kernel_data,
-					ptr->length);
-			if (ret)
-				return ret;
-		}
+	if (ptr->flags & FD_RAW_MORE) {
 		rcmd = &(ptr->next);
-		if (!(ptr->flags & FD_RAW_MORE))
-			return 0;
 		ptr->rate &= 0x43;
+		goto loop;
 	}
+
+	return 0;
 }
 
 static int raw_cmd_ioctl(int cmd, void __user *param)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

