From: akpm@linux-foundation.org
Subject: + fs-clear-file-privilege-bits-when-mmap-writing.patch added to
 -mm tree
Date: Wed, 02 Dec 2015 16:19:00 -0800
Message-ID: <565f8a74.3XnIx/EJzdFYGkJD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914AbbLCATB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 19:19:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, aarcange@redhat.com, dave@stgolabs.net, ebiederm@xmission.com, gang.chen.5i5j@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, oleg@redhat.com, riel@redhat.com, stable@vger.kernel.org, viro@ftp.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: clear file privilege bits when mmap writing
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
Subject: mm/mmap.c: clear file privilege bits when mmap writing

Normally, when a user can modify a file that has setuid or setgid bits,
those bits are cleared when they are not the file owner or a member of the
group.  This is enforced when using write and truncate but not when
writing to a shared mmap on the file.  This could allow the file writer to
gain privileges by changing a binary without losing the setuid/setgid/caps
bits.

Changing the bits requires holding inode->i_mutex, so it cannot be done
during the page fault (due to mmap_sem being held during the fault). 
Instead, clear the bits if PROT_WRITE is being used at mmap time.

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/mmap.c~fs-clear-file-privilege-bits-when-mmap-writing mm/mmap.c
--- a/mm/mmap.c~fs-clear-file-privilege-bits-when-mmap-writing
+++ a/mm/mmap.c
@@ -1352,6 +1352,17 @@ unsigned long do_mmap(struct file *file,
 			if (locks_verify_locked(file))
 				return -EAGAIN;
 
+			/*
+			 * If we must remove privs, we do it here since
+			 * doing it during page COW is expensive and
+			 * cannot hold inode->i_mutex.
+			 */
+			if (prot & PROT_WRITE && !IS_NOSEC(inode)) {
+				mutex_lock(&inode->i_mutex);
+				file_remove_privs(file);
+				mutex_unlock(&inode->i_mutex);
+			}
+
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
_

Patches currently in -mm which might be from keescook@chromium.org are

fs-clear-file-privilege-bits-when-mmap-writing.patch
sysctl-enable-strict-writes.patch

