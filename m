From: akpm@linux-foundation.org
Subject: + vfs-improve-comment-describing-fget_light.patch added to -mm tree
Date: Tue, 24 Feb 2009 13:41:34 -0800
Message-ID: <200902242141.n1OLfZSb013331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753639AbZBXVmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 16:42:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tonyb@cybernetics.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: improve comment describing fget_light()
has been added to the -mm tree.  Its filename is
     vfs-improve-comment-describing-fget_light.patch

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
Subject: vfs: improve comment describing fget_light()
From: Tony Battersby <tonyb@cybernetics.com>

Improve the description of fget_light(), which is currently incorrect
about needing a prior refcnt (judging by the way it is actually used).

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN fs/file_table.c~vfs-improve-comment-describing-fget_light fs/file_table.c
--- a/fs/file_table.c~vfs-improve-comment-describing-fget_light
+++ a/fs/file_table.c
@@ -318,11 +318,20 @@ struct file *fget(unsigned int fd)
 EXPORT_SYMBOL(fget);
 
 /*
- * Lightweight file lookup - no refcnt increment if fd table isn't shared. 
- * You can use this only if it is guranteed that the current task already 
- * holds a refcnt to that file. That check has to be done at fget() only
- * and a flag is returned to be passed to the corresponding fput_light().
- * There must not be a cloning between an fget_light/fput_light pair.
+ * Lightweight file lookup - no refcnt increment if fd table isn't shared.
+ *
+ * You can use this instead of fget if you satisfy all of the following
+ * conditions:
+ * 1) You must call fput_light before exiting the syscall and returning control
+ *    to userspace (i.e. you cannot remember the returned struct file * after
+ *    returning to userspace).
+ * 2) You must not call filp_close on the returned struct file * in between
+ *    calls to fget_light and fput_light.
+ * 3) You must not clone the current task in between the calls to fget_light
+ *    and fput_light.
+ *
+ * The fput_needed flag returned by fget_light should be passed to the
+ * corresponding fput_light.
  */
 struct file *fget_light(unsigned int fd, int *fput_needed)
 {
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

linux-next.patch
vfs-improve-comment-describing-fget_light.patch
make-shm_get_stat-more-robust.patch

