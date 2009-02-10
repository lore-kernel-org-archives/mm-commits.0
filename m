From: akpm@linux-foundation.org
Subject: + fasync-rename-struct-file-f_ep_lock.patch added to -mm tree
Date: Mon, 09 Feb 2009 16:33:46 -0800
Message-ID: <200902100033.n1A0Xk79005431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbZBJAeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 19:34:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corbet@lwn.net, davidel@xmailserver.org, hch@lst.de, mpm@selenic.com, viro@zeniv.linux.org.uk


The patch titled
     fasync: rename struct file->f_ep_lock
has been added to the -mm tree.  Its filename is
     fasync-rename-struct-file-f_ep_lock.patch

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
Subject: fasync: rename struct file->f_ep_lock
From: Jonathan Corbet <corbet@lwn.net>

Remvoe the BKL from the fasync() path and provide proper protection for
struct file->f_flags.  The series includes these patches:

1) Rename f_ep_lock to f_lock and move it out of CONFIG_EPOLL.  Epoll
   remains the only user, but the lock is now available for others.

2) Use f_lock to protect f_flags.  This provides better protection to
   the flags than we've had before and allows the removal of the BKL in
   places where its only purpose was protecting accesses to this field.

3) Move FASYNC bit handling into ->fasync(): this is how changes to
   that bit and calls to f_op->fasync() are kept atomic in the absence of
   the BKL.  Almost every FASYNC implementation uses fasync_helper(), so
   the actual bit manipulation is done there.  The one exception (for
   sockets) has been fixed up.  At this point, there is no more BKL in
   these paths.

4) Rationalize fasync_helper() return value handling.  Some drivers
   mapped positive return values from fasync_helper() onto zero, most
   others did not bother.  This optional cleanup patch moves that mapping
   into the VFS code, making things consistent and enabling the removal of
   some 50 lines of code.



This patch:

Rename struct file->f_ep_lock.  This lock moves out of the CONFIG_EPOLL
ifdef and becomes f_lock.  For now, epoll remains the only user, but a
future patch will use it to protect f_flags as well.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Acked-by: Matt Mackall <mpm@selenic.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c            |   12 +++++++-----
 fs/file_table.c           |    1 +
 include/linux/eventpoll.h |    1 -
 include/linux/fs.h        |    2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/eventpoll.c~fasync-rename-struct-file-f_ep_lock fs/eventpoll.c
--- a/fs/eventpoll.c~fasync-rename-struct-file-f_ep_lock
+++ a/fs/eventpoll.c
@@ -417,10 +417,10 @@ static int ep_remove(struct eventpoll *e
 	ep_unregister_pollwait(ep, epi);
 
 	/* Remove the current item from the list of epoll hooks */
-	spin_lock(&file->f_ep_lock);
+	spin_lock(&file->f_lock);
 	if (ep_is_linked(&epi->fllink))
 		list_del_init(&epi->fllink);
-	spin_unlock(&file->f_ep_lock);
+	spin_unlock(&file->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
 
@@ -538,7 +538,7 @@ void eventpoll_release_file(struct file 
 	struct epitem *epi;
 
 	/*
-	 * We don't want to get "file->f_ep_lock" because it is not
+	 * We don't want to get "file->f_lock" because it is not
 	 * necessary. It is not necessary because we're in the "struct file"
 	 * cleanup path, and this means that noone is using this file anymore.
 	 * So, for example, epoll_ctl() cannot hit here sicne if we reach this
@@ -547,6 +547,8 @@ void eventpoll_release_file(struct file 
 	 * will correctly serialize the operation. We do need to acquire
 	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
 	 * from anywhere but ep_free().
+	 *
+	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
 	 */
 	mutex_lock(&epmutex);
 
@@ -785,9 +787,9 @@ static int ep_insert(struct eventpoll *e
 		goto error_unregister;
 
 	/* Add the current item to the list of active epoll hook for this file */
-	spin_lock(&tfile->f_ep_lock);
+	spin_lock(&tfile->f_lock);
 	list_add_tail(&epi->fllink, &tfile->f_ep_links);
-	spin_unlock(&tfile->f_ep_lock);
+	spin_unlock(&tfile->f_lock);
 
 	/*
 	 * Add the current item to the RB tree. All RB tree operations are
diff -puN fs/file_table.c~fasync-rename-struct-file-f_ep_lock fs/file_table.c
--- a/fs/file_table.c~fasync-rename-struct-file-f_ep_lock
+++ a/fs/file_table.c
@@ -128,6 +128,7 @@ struct file *get_empty_filp(void)
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
 	f->f_cred = get_cred(cred);
+	spin_lock_init(&f->f_lock);
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff -puN include/linux/eventpoll.h~fasync-rename-struct-file-f_ep_lock include/linux/eventpoll.h
--- a/include/linux/eventpoll.h~fasync-rename-struct-file-f_ep_lock
+++ a/include/linux/eventpoll.h
@@ -61,7 +61,6 @@ struct file;
 static inline void eventpoll_init_file(struct file *file)
 {
 	INIT_LIST_HEAD(&file->f_ep_links);
-	spin_lock_init(&file->f_ep_lock);
 }
 
 
diff -puN include/linux/fs.h~fasync-rename-struct-file-f_ep_lock include/linux/fs.h
--- a/include/linux/fs.h~fasync-rename-struct-file-f_ep_lock
+++ a/include/linux/fs.h
@@ -853,6 +853,7 @@ struct file {
 #define f_dentry	f_path.dentry
 #define f_vfsmnt	f_path.mnt
 	const struct file_operations	*f_op;
+	spinlock_t		f_lock;  /* f_ep_links */
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
@@ -871,7 +872,6 @@ struct file {
 #ifdef CONFIG_EPOLL
 	/* Used by fs/eventpoll.c to link all the hooks to this file */
 	struct list_head	f_ep_links;
-	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
 #ifdef CONFIG_DEBUG_WRITECOUNT
_

Patches currently in -mm which might be from corbet@lwn.net are

linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage.patch
fasync-rename-struct-file-f_ep_lock.patch
fasync-use-f_lock-to-protect-f_flags.patch
fasync-move-bit-handling-to-f_op-fasync.patch
fasync-rationalize-return-values.patch

