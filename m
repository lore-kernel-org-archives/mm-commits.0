From: akpm@linux-foundation.org
Subject: + gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject-hvcs-fixup-container_of-usage.patch added to -mm tree
Date: Tue, 08 Jan 2008 17:02:29 -0800
Message-ID: <200801090102.m0912Tef008986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758266AbYAIBDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 20:03:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     hvcs: fixup container_of() usage
has been added to the -mm tree.  Its filename is
     gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject-hvcs-fixup-container_of-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 
 static LIST_HEAD(hvcs_structs);
 static DEFINE_SPINLOCK(hvcs_structs_lock);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

proc-remove-module_license.patch
proc-less-lock-operations-during-lookup.patch
proc-simplify-function-prototypes.patch
proc-remove-useless-check-on-symlink-removal.patch
proc-remove-useless-checks-in-proc_register.patch
proc-detect-duplicate-names-on-registration.patch
proc-detect-duplicate-names-on-registration-fix.patch
gregkh-driver-block-device-genhd-fixup-kobj_to_dev-macro.patch
gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject-hvcs-fixup-container_of-usage.patch
fixup-container_of-usage.patch
single_open-seq_release-leak-diagnostics.patch
