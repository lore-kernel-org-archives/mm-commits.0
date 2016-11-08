From: akpm@linux-foundation.org
Subject: + proc-tweak-comments-about-2-stage-open-and-everything.patch
 added to -mm tree
Date: Tue, 08 Nov 2016 15:06:07 -0800
Message-ID: <58225a5f.GusnZX/T6nSfpo0I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbcKHXGI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 18:06:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: tweak comments about 2 stage open and everything
has been added to the -mm tree.  Its filename is
     proc-tweak-comments-about-2-stage-open-and-everything.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-tweak-comments-about-2-stage-open-and-everything.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-tweak-comments-about-2-stage-open-and-everything.patch

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
Subject: proc: tweak comments about 2 stage open and everything

Some comments were obsoleted since 05c0ae21c034a6f ("try a saner locking
for pde_opener...").

Some new comments added.

Some confusing comments replaced with equally confusing ones.

Link: http://lkml.kernel.org/r/20161029160231.GD1246@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff -puN fs/proc/inode.c~proc-tweak-comments-about-2-stage-open-and-everything fs/proc/inode.c
--- a/fs/proc/inode.c~proc-tweak-comments-about-2-stage-open-and-everything
+++ a/fs/proc/inode.c
@@ -138,6 +138,16 @@ static void unuse_pde(struct proc_dir_en
 /* pde is locked */
 static void close_pdeo(struct proc_dir_entry *pde, struct pde_opener *pdeo)
 {
+	/*
+	 * close() (proc_reg_release()) can't delete an entry and proceed:
+	 * ->release hook needs to be available at the right moment.
+	 *
+	 * rmmod (remove_proc_entry() et al) can't delete an entry and proceed:
+	 * "struct file" needs to be available at the right moment.
+	 *
+	 * Therefore, first process to enter this function does ->release() and
+	 * signals its completion to the other process which does nothing.
+	 */
 	if (pdeo->closing) {
 		/* somebody else is doing that, just wait */
 		DECLARE_COMPLETION_ONSTACK(c);
@@ -152,6 +162,7 @@ static void close_pdeo(struct proc_dir_e
 		file = pdeo->file;
 		pde->proc_fops->release(file_inode(file), file);
 		spin_lock(&pde->pde_unload_lock);
+		/* After ->release. */
 		list_del(&pdeo->lh);
 		if (pdeo->c)
 			complete(pdeo->c);
@@ -167,6 +178,8 @@ void proc_entry_rundown(struct proc_dir_
 	if (atomic_add_return(BIAS, &de->in_use) != BIAS)
 		wait_for_completion(&c);
 
+	/* ->pde_openers list can't grow from now on. */
+
 	spin_lock(&de->pde_unload_lock);
 	while (!list_empty(&de->pde_openers)) {
 		struct pde_opener *pdeo;
@@ -312,14 +325,15 @@ static int proc_reg_open(struct inode *i
 	struct pde_opener *pdeo;
 
 	/*
-	 * What for, you ask? Well, we can have open, rmmod, remove_proc_entry
-	 * sequence. ->release won't be called because ->proc_fops will be
-	 * cleared. Depending on complexity of ->release, consequences vary.
+	 * Ensure that
+	 * 1) PDE's ->release hook will be called no matter what
+	 *    either normally by close()/->release, or forcefully by
+	 *    rmmod/remove_proc_entry.
+	 *
+	 * 2) rmmod isn't blocked by opening file in /proc and sitting on
+	 *    the descriptor (including "rmmod foo </proc/foo" scenario).
 	 *
-	 * We can't wait for mercy when close will be done for real, it's
-	 * deadlockable: rmmod foo </proc/foo . So, we're going to do ->release
-	 * by hand in remove_proc_entry(). For this, save opener's credentials
-	 * for later.
+	 * Save every "struct file" with custom ->release hook.
 	 */
 	pdeo = kmalloc(sizeof(struct pde_opener), GFP_KERNEL);
 	if (!pdeo)
@@ -340,7 +354,6 @@ static int proc_reg_open(struct inode *i
 		pdeo->file = file;
 		pdeo->closing = false;
 		pdeo->c = NULL;
-		/* Strictly for "too late" ->release in proc_reg_release(). */
 		spin_lock(&pde->pde_unload_lock);
 		list_add(&pdeo->lh, &pde->pde_openers);
 		spin_unlock(&pde->pde_unload_lock);
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

