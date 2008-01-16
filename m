From: akpm@linux-foundation.org
Subject: - gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject-hvcs-fixup-container_of-usage.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:05 -0800
Message-ID: <200801160139.m0G1d5h6013971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42438 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756405AbYAPBtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     hvcs: fixup container_of() usage
has been removed from the -mm tree.  Its filename was
     gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject-hvcs-fixup-container_of-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hvcs: fixup container_of() usage
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvcs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hvcs.c~gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject-hvcs-fixup-container_of-usage drivers/char/hvcs.c
--- a/drivers/char/hvcs.c~gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject-hvcs-fixup-container_of-usage
+++ a/drivers/char/hvcs.c
@@ -304,7 +304,7 @@ struct hvcs_struct {
 };
 
 /* Required to back map a kref to its containing object */
-#define from_kref(kref) container_of(kref, struct hvcs_struct, kref)
+#define from_kref(k) container_of(k, struct hvcs_struct, kref)
 
 static struct list_head hvcs_structs = LIST_HEAD_INIT(hvcs_structs);
 static DEFINE_SPINLOCK(hvcs_structs_lock);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

git-cryptodev.patch
proc-remove-module_license.patch
proc-less-lock-operations-during-lookup.patch
proc-simplify-function-prototypes.patch
proc-remove-useless-check-on-symlink-removal.patch
proc-detect-duplicate-names-on-registration.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
fixup-container_of-usage.patch
single_open-seq_release-leak-diagnostics.patch
