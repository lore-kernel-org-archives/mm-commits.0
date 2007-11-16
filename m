From: akpm@linux-foundation.org
Subject: + proc-remove-module_license.patch added to -mm tree
Date: Fri, 16 Nov 2007 13:49:43 -0800
Message-ID: <200711162149.lAGLnh6P005285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756315AbXKPVuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 16:50:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     proc: remove MODULE_LICENSE
has been added to the -mm tree.  Its filename is
     proc-remove-module_license.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: remove MODULE_LICENSE
From: Alexey Dobriyan <adobriyan@sw.ru>

proc is not modular, so MODULE_LICENSE just expands to empty space.  proc
without doubts remains GPLed.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/inode.c~proc-remove-module_license fs/proc/inode.c
--- a/fs/proc/inode.c~proc-remove-module_license
+++ a/fs/proc/inode.c
@@ -472,4 +472,3 @@ out_no_root:
 	de_put(&proc_root);
 	return -ENOMEM;
 }
-MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
proc-remove-module_license.patch
proc-less-lock-operations-during-lookup.patch
proc-prototypes-redux.patch
proc-remove-useless-check-on-symlink-removal.patch
proc-remove-useless-checks-in-proc_register.patch
single_open-seq_release-leak-diagnostics.patch
