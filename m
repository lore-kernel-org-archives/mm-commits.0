From: akpm@linux-foundation.org
Subject: + fs-clear-file-privilege-bits-when-mmap-writing.patch added to
 -mm tree
Date: Fri, 04 Dec 2015 15:50:31 -0800
Message-ID: <566226c7.c4+CgEMc4DUAPtkR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbbLDXuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:50:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, aarcange@redhat.com, dave@stgolabs.net, ebiederm@xmission.com, gang.chen.5i5j@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, oleg@redhat.com, riel@redhat.com, viro@ftp.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: clear file privilege bits when mmap writing
has been added to the -mm tree.  Its filename is
     fs-clear-file-privilege-bits-when-mmap-writing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-clear-file-privilege-bits-when-mmap-writing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-clear-file-privilege-bits-when-mmap-writing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs: clear file privilege bits when mmap writing

Normally, when a user can modify a file that has setuid or setgid bits,
those bits are cleared when they are not the file owner or a member of the
group.  This is enforced when using write and truncate but not when
writing to a shared mmap on the file.  This could allow the file writer to
gain privileges by changing a binary without losing the setuid/setgid/caps
bits.

Changing the bits requires holding inode->i_mutex, so it cannot be done
during the page fault (due to mmap_sem being held during the fault). 
Instead, clear the bits if PROT_WRITE is being used at mmap open time. 
But we can't do the check in the right place inside mmap, so we have to do
it before holding mmap_sem, which means duplicating some checks, which
have to be available to the non-MMU builds too.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Willy Tarreau <w@1wt.eu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alexander Viro <viro@ftp.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/mmap.c          |   19 +++-------------
 mm/util.c          |   50 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 15 deletions(-)

diff -puN include/linux/mm.h~fs-clear-file-privilege-bits-when-mmap-writing include/linux/mm.h
--- a/include/linux/mm.h~fs-clear-file-privilege-bits-when-mmap-writing
+++ a/include/linux/mm.h
@@ -1943,6 +1943,7 @@ extern unsigned long get_unmapped_area(s
 
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long len, vm_flags_t vm_flags, unsigned long pgoff);
+extern int do_mmap_shared_checks(struct file *file, unsigned long prot);
 extern unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
 	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate);
diff -puN mm/mmap.c~fs-clear-file-privilege-bits-when-mmap-writing mm/mmap.c
--- a/mm/mmap.c~fs-clear-file-privilege-bits-when-mmap-writing
+++ a/mm/mmap.c
@@ -1333,24 +1333,13 @@ unsigned long do_mmap(struct file *file,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		int err;
 
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
-			if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
-				return -EACCES;
-
-			/*
-			 * Make sure we don't allow writing to an append-only
-			 * file..
-			 */
-			if (IS_APPEND(inode) && (file->f_mode & FMODE_WRITE))
-				return -EACCES;
-
-			/*
-			 * Make sure there are no mandatory locks on the file.
-			 */
-			if (locks_verify_locked(file))
-				return -EAGAIN;
+			err = do_mmap_shared_checks(file, prot);
+			if (err)
+				return err;
 
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
diff -puN mm/util.c~fs-clear-file-privilege-bits-when-mmap-writing mm/util.c
--- a/mm/util.c~fs-clear-file-privilege-bits-when-mmap-writing
+++ a/mm/util.c
@@ -283,6 +283,29 @@ int __weak get_user_pages_fast(unsigned
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
+int do_mmap_shared_checks(struct file *file, unsigned long prot)
+{
+	struct inode *inode = file_inode(file);
+
+	if ((prot & PROT_WRITE) && !(file->f_mode & FMODE_WRITE))
+		return -EACCES;
+
+	/*
+	 * Make sure we don't allow writing to an append-only
+	 * file..
+	 */
+	if (IS_APPEND(inode) && (file->f_mode & FMODE_WRITE))
+		return -EACCES;
+
+	/*
+	 * Make sure there are no mandatory locks on the file.
+	 */
+	if (locks_verify_locked(file))
+		return -EAGAIN;
+
+	return 0;
+}
+
 unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long pgoff)
@@ -291,6 +314,33 @@ unsigned long vm_mmap_pgoff(struct file
 	struct mm_struct *mm = current->mm;
 	unsigned long populate;
 
+	/*
+	 * If we must remove privs, we do it here since doing it during
+	 * page fault may be expensive and cannot hold inode->i_mutex,
+	 * since mm->mmap_sem is already held.
+	 */
+	if (file && (flag & MAP_TYPE) == MAP_SHARED && (prot & PROT_WRITE)) {
+		struct inode *inode = file_inode(file);
+		int err;
+
+		if (!IS_NOSEC(inode)) {
+			/*
+			 * Make sure we can't strip privs from a file that
+			 * wouldn't otherwise be allowed to be mmapped.
+			 */
+			err = do_mmap_shared_checks(file, prot);
+			if (err)
+				return err;
+
+			mutex_lock(&inode->i_mutex);
+			err = file_remove_privs(file);
+			mutex_unlock(&inode->i_mutex);
+
+			if (err)
+				return err;
+		}
+	}
+
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
 		down_write(&mm->mmap_sem);
_

Patches currently in -mm which might be from keescook@chromium.org are

fs-clear-file-privilege-bits-when-mmap-writing.patch
sysctl-enable-strict-writes.patch

