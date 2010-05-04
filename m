From: akpm@linux-foundation.org
Subject: [wrecked] ir-keytable-avoid-double-lock.patch removed from -mm tree
Date: Tue, 04 May 2010 11:27:15 -0400
Message-ID: <201005041828.o44ISkeD011377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932478Ab0EDS25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 14:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, dtor@mail.ru, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     ir-keytable: avoid double lock
has been removed from the -mm tree.  Its filename was
     ir-keytable-avoid-double-lock.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ir-keytable: avoid double lock
From: Dan Carpenter <error27@gmail.com>

It's possible that we wanted to resize to a smaller size but we didn't
have enough memory to create the new table.  We need to test for that here
so we don't try to lock twice and dead lock.  Also we free the "oldkeymap"
on that path and that would be bad.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/IR/ir-keytable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/IR/ir-keytable.c~ir-keytable-avoid-double-lock drivers/media/IR/ir-keytable.c
--- a/drivers/media/IR/ir-keytable.c~ir-keytable-avoid-double-lock
+++ a/drivers/media/IR/ir-keytable.c
@@ -217,7 +217,7 @@ static void ir_delete_key(struct ir_scan
 		memcpy(&newkeymap[elem], &oldkeymap[elem + 1],
 		       (newsize - elem) * sizeof(*newkeymap));
 
-	if (resize) {
+	if (resize && newkeymap != oldkeymap) {
 		/*
 		 * As the copy happened to a temporary table, only here
 		 * it needs to lock while replacing the table pointers
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch
drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch
drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch
drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch
ir-keytable-avoid-double-lock.patch
cx231xx-improve-error-handling.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

