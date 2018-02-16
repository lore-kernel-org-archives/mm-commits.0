From: akpm@linux-foundation.org
Subject: + proc-faster-open-close-of-files-without-release-hook.patch
 added to -mm tree
Date: Fri, 16 Feb 2018 15:07:27 -0800
Message-ID: <5a87642f.Zrh4hrezI2UoZs4z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbeBPXH3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 18:07:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, keescook@chromium.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: faster open/close of files without ->release hook
has been added to the -mm tree.  Its filename is
     proc-faster-open-close-of-files-without-release-hook.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-faster-open-close-of-files-without-release-hook.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-faster-open-close-of-files-without-release-hook.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: faster open/close of files without ->release hook

The whole point of code in fs/proc/inode.c is to make sure ->release hook
is called either at close() or at rmmod time.

All if it is unnecessary if there is no ->release hook.

Save allocation+list manipulations under spinlock in that case.

Link: http://lkml.kernel.org/r/20180214063033.GA15579@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff -puN fs/proc/inode.c~proc-faster-open-close-of-files-without-release-hook fs/proc/inode.c
--- a/fs/proc/inode.c~proc-faster-open-close-of-files-without-release-hook
+++ a/fs/proc/inode.c
@@ -342,31 +342,36 @@ static int proc_reg_open(struct inode *i
 	 *
 	 * Save every "struct file" with custom ->release hook.
 	 */
-	pdeo = kmalloc(sizeof(struct pde_opener), GFP_KERNEL);
-	if (!pdeo)
-		return -ENOMEM;
-
-	if (!use_pde(pde)) {
-		kfree(pdeo);
+	if (!use_pde(pde))
 		return -ENOENT;
-	}
-	open = pde->proc_fops->open;
+
 	release = pde->proc_fops->release;
+	if (release) {
+		pdeo = kmalloc(sizeof(struct pde_opener), GFP_KERNEL);
+		if (!pdeo) {
+			rv = -ENOMEM;
+			goto out_unuse;
+		}
+	}
 
+	open = pde->proc_fops->open;
 	if (open)
 		rv = open(inode, file);
 
-	if (rv == 0 && release) {
-		/* To know what to release. */
-		pdeo->file = file;
-		pdeo->closing = false;
-		pdeo->c = NULL;
-		spin_lock(&pde->pde_unload_lock);
-		list_add(&pdeo->lh, &pde->pde_openers);
-		spin_unlock(&pde->pde_unload_lock);
-	} else
-		kfree(pdeo);
+	if (release) {
+		if (rv == 0) {
+			/* To know what to release. */
+			pdeo->file = file;
+			pdeo->closing = false;
+			pdeo->c = NULL;
+			spin_lock(&pde->pde_unload_lock);
+			list_add(&pdeo->lh, &pde->pde_openers);
+			spin_unlock(&pde->pde_unload_lock);
+		} else
+			kfree(pdeo);
+	}
 
+out_unuse:
 	unuse_pde(pde);
 	return rv;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-do-less-stuff-under-pde_unload_lock.patch
proc-move-proc-sysvipc-creation-to-where-it-belongs.patch
proc-faster-open-close-of-files-without-release-hook.patch
proc-randomize-struct-pde_opener.patch
proc-move-struct-pde_opener-to-kmem-cache.patch
proc-account-struct-pde_opener.patch
seq_file-delete-small-value-optimization.patch

