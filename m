From: akpm@linux-foundation.org
Subject: + proc-remove-useless-check-on-symlink-removal.patch added to -mm tree
Date: Fri, 16 Nov 2007 13:50:44 -0800
Message-ID: <200711162150.lAGLoiHc005306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757334AbXKPVv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 16:51:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     proc: remove useless check on symlink removal
has been added to the -mm tree.  Its filename is
     proc-remove-useless-check-on-symlink-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: remove useless check on symlink removal
From: Alexey Dobriyan <adobriyan@sw.ru>

proc symlinks always have valid ->data containing destination of symlink.  No
need to check it on removal -- proc_symlink() already done it.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/generic.c~proc-remove-useless-check-on-symlink-removal fs/proc/generic.c
--- a/fs/proc/generic.c~proc-remove-useless-check-on-symlink-removal
+++ a/fs/proc/generic.c
@@ -716,7 +716,7 @@ void free_proc_entry(struct proc_dir_ent
 
 	release_inode_number(ino);
 
-	if (S_ISLNK(de->mode) && de->data)
+	if (S_ISLNK(de->mode))
 		kfree(de->data);
 	kfree(de);
 }
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
proc-remove-module_license.patch
proc-less-lock-operations-during-lookup.patch
proc-simplify-function-prototypes.patch
proc-remove-useless-check-on-symlink-removal.patch
proc-remove-useless-checks-in-proc_register.patch
single_open-seq_release-leak-diagnostics.patch
