From: akpm@linux-foundation.org
Subject: + mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch added to -mm tree
Date: Mon, 20 Dec 2010 22:43:45 -0800
Message-ID: <201012210647.oBL6lBPF023547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956Ab0LUGrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 01:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, Valdis.Kletnieks@vt.edu


The patch titled
     mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix
has been added to the -mm tree.  Its filename is
     mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix
From: Michel Lespinasse <walken@google.com>

On Sat, Dec 18, 2010 at 05:10:59AM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 16 Dec 2010 14:56:39 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-12-16-14-56 has been uploaded to
> >
> >    http://userweb.kernel.org/~akpm/mmotm/
>
> The patch mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
> causes this chunk of code from cryptsetup-luks to fail during the initramfs:
>
> 	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
>                         log_err(ctx, _("WARNING!!! Possibly insecure memory. Are you root?\n"));
>                         _memlock_count--;
>                         return 0;
>                 }
>
> Bisection fingered this patch, which was added after -rc4-mmotm1202, which
> boots without tripping this log_err() call.  I haven't tried building a
> -rc6-mmotm1216 with this patch reverted, because reverting it causes apply
> errors for subsequent patches.
>
> Ideas?

So I traced this down using valdis's initramfs image. This is actually
an interesting corner case:

Some VMA has the VM_MAY_(READ/WRITE/EXEC) flags, but is currently protected
with PROT_NONE permissions (VM_READ/WRITE_EXEC flags are all cleared).

When mlockall() is called, the old code would see mlock_fixup() return
an error for that VMA, which would be ignored by do_mlockall(). The new
code did not ignore errors from do_mlock_pages(), which broke backwards
compatibility.

So the trivial fix to make mlockall behave identically as before could be
as follows:

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN mm/mlock.c~mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix mm/mlock.c
--- a/mm/mlock.c~mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix
+++ a/mm/mlock.c
@@ -476,7 +476,7 @@ static int do_mlock(unsigned long start,
 	return error;
 }
 
-static int do_mlock_pages(unsigned long start, size_t len)
+static int do_mlock_pages(unsigned long start, size_t len, int ignore_errors)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long end, nstart, nend;
@@ -513,6 +513,10 @@ static int do_mlock_pages(unsigned long 
 		 */
 		if (vma->vm_flags & VM_LOCKED) {
 			ret = __mlock_vma_pages_range(vma, nstart, nend);
+			if (ret < 0 && ignore_errors) {
+				ret = 0;
+				continue;	/* continue at next VMA */
+			}
 			if (ret) {
 				ret = __mlock_posix_error_return(ret);
 				break;
@@ -550,7 +554,7 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 		error = do_mlock(start, len, 1);
 	up_write(&current->mm->mmap_sem);
 	if (!error)
-		error = do_mlock_pages(start, len);
+		error = do_mlock_pages(start, len, 0);
 	return error;
 }
 
@@ -615,8 +619,10 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	    capable(CAP_IPC_LOCK))
 		ret = do_mlockall(flags);
 	up_write(&current->mm->mmap_sem);
-	if (!ret && (flags & MCL_CURRENT))
-		ret = do_mlock_pages(0, TASK_SIZE);
+	if (!ret && (flags & MCL_CURRENT)) {
+		/* Ignore errors */
+		do_mlock_pages(0, TASK_SIZE, 1);
+	}
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from walken@google.com are

do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch

