From: akpm@linux-foundation.org
Subject: + proc-fix-type-of-struct-pde_opener-closing-field.patch added to -mm tree
Date: Tue, 08 Nov 2016 15:06:03 -0800
Message-ID: <58225a5b.9IzRPyEnHPplKENG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50468 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbcKHXGE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 18:06:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix type of struct pde_opener::closing field
has been added to the -mm tree.  Its filename is
     proc-fix-type-of-struct-pde_opener-closing-field.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fix-type-of-struct-pde_opener-closing-field.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-type-of-struct-pde_opener-closing-field.patch

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
Subject: proc: fix type of struct pde_opener::closing field

struct pde_opener::closing is boolean.

Link: http://lkml.kernel.org/r/20161029155439.GB1246@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c    |    2 +-
 fs/proc/internal.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/inode.c~proc-fix-type-of-struct-pde_opener-closing-field fs/proc/inode.c
--- a/fs/proc/inode.c~proc-fix-type-of-struct-pde_opener-closing-field
+++ a/fs/proc/inode.c
@@ -147,7 +147,7 @@ static void close_pdeo(struct proc_dir_e
 		spin_lock(&pde->pde_unload_lock);
 	} else {
 		struct file *file;
-		pdeo->closing = 1;
+		pdeo->closing = true;
 		spin_unlock(&pde->pde_unload_lock);
 		file = pdeo->file;
 		pde->proc_fops->release(file_inode(file), file);
diff -puN fs/proc/internal.h~proc-fix-type-of-struct-pde_opener-closing-field fs/proc/internal.h
--- a/fs/proc/internal.h~proc-fix-type-of-struct-pde_opener-closing-field
+++ a/fs/proc/internal.h
@@ -203,7 +203,7 @@ struct proc_dir_entry *proc_create_mount
 struct pde_opener {
 	struct file *file;
 	struct list_head lh;
-	int closing;
+	bool closing;
 	struct completion *c;
 };
 extern const struct inode_operations proc_link_inode_operations;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

scripts-bloat-o-meter-fix-sigpipe.patch
kbuild-simpler-generation-of-assembly-constants.patch
proc-make-struct-pid_entry-len-unsigned.patch
proc-make-struct-struct-map_files_info-len-unsigned-int.patch
proc-just-list_del-struct-pde_opener.patch
proc-fix-type-of-struct-pde_opener-closing-field.patch
proc-kmalloc-struct-pde_opener.patch
proc-tweak-comments-about-2-stage-open-and-everything.patch

