From: akpm@linux-foundation.org
Subject: + vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch added to -mm tree
Date: Tue, 04 May 2010 15:27:50 -0700
Message-ID: <201005042227.o44MRoLX022638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934399Ab0EDW2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 18:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaosuo@gmail.com, adobriyan@gmail.com, avi@redhat.com, jslaby@suse.cz, mingo@elte.hu, paulmck@linux.vnet.ibm.com, penguin-kernel@i-love.sakura.ne.jp, peterz@infradead.org, viro@zeniv.linux.org.uk


The patch titled
     vfs: use kmalloc() to allocate fdmem if possible
has been added to the -mm tree.  Its filename is
     vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch

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
Subject: vfs: use kmalloc() to allocate fdmem if possible
From: Changli Gao <xiaosuo@gmail.com>

Use kmalloc() to allocate fdmem if possible.

vmalloc() is used as a fallback solution for fdmem allocation.  A new
helper function __free_fdtable() is introduced to reduce the lines of
code.

A potential bug, vfree() a memory allocated by kmalloc(), is fixed.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file.c |   55 ++++++++++++++++++++--------------------------------
 1 file changed, 22 insertions(+), 33 deletions(-)

diff -puN fs/file.c~vfs-use-kmalloc-to-allocate-fdmem-if-possible fs/file.c
--- a/fs/file.c~vfs-use-kmalloc-to-allocate-fdmem-if-possible
+++ a/fs/file.c
@@ -39,28 +39,27 @@ int sysctl_nr_open_max = 1024 * 1024; /*
  */
 static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 
-static inline void * alloc_fdmem(unsigned int size)
+static inline void *alloc_fdmem(unsigned int size)
 {
-	if (size <= PAGE_SIZE)
-		return kmalloc(size, GFP_KERNEL);
-	else
-		return vmalloc(size);
+	void *data;
+
+	data = kmalloc(size, GFP_KERNEL);
+	if (data != NULL)
+		return data;
+
+	return vmalloc(size);
 }
 
-static inline void free_fdarr(struct fdtable *fdt)
+static inline void free_fdmem(void *ptr)
 {
-	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *)))
-		kfree(fdt->fd);
-	else
-		vfree(fdt->fd);
+	is_vmalloc_addr(ptr) ? vfree(ptr) : kfree(ptr);
 }
 
-static inline void free_fdset(struct fdtable *fdt)
+static inline void __free_fdtable(struct fdtable *fdt)
 {
-	if (fdt->max_fds <= (PAGE_SIZE * BITS_PER_BYTE / 2))
-		kfree(fdt->open_fds);
-	else
-		vfree(fdt->open_fds);
+	free_fdmem(fdt->fd);
+	free_fdmem(fdt->open_fds);
+	kfree(fdt);
 }
 
 static void free_fdtable_work(struct work_struct *work)
@@ -75,9 +74,8 @@ static void free_fdtable_work(struct wor
 	spin_unlock_bh(&f->lock);
 	while(fdt) {
 		struct fdtable *next = fdt->next;
-		vfree(fdt->fd);
-		free_fdset(fdt);
-		kfree(fdt);
+
+		__free_fdtable(fdt);
 		fdt = next;
 	}
 }
@@ -183,7 +181,7 @@ static struct fdtable * alloc_fdtable(un
 	return fdt;
 
 out_arr:
-	free_fdarr(fdt);
+	free_fdmem(fdt->fd);
 out_fdt:
 	kfree(fdt);
 out:
@@ -213,9 +211,7 @@ static int expand_fdtable(struct files_s
 	 * caller and alloc_fdtable().  Cheaper to catch it here...
 	 */
 	if (unlikely(new_fdt->max_fds <= nr)) {
-		free_fdarr(new_fdt);
-		free_fdset(new_fdt);
-		kfree(new_fdt);
+		__free_fdtable(new_fdt);
 		return -EMFILE;
 	}
 	/*
@@ -231,9 +227,7 @@ static int expand_fdtable(struct files_s
 			free_fdtable(cur_fdt);
 	} else {
 		/* Somebody else expanded, so undo our attempt */
-		free_fdarr(new_fdt);
-		free_fdset(new_fdt);
-		kfree(new_fdt);
+		__free_fdtable(new_fdt);
 	}
 	return 1;
 }
@@ -323,11 +317,8 @@ struct files_struct *dup_fd(struct files
 	while (unlikely(open_files > new_fdt->max_fds)) {
 		spin_unlock(&oldf->file_lock);
 
-		if (new_fdt != &newf->fdtab) {
-			free_fdarr(new_fdt);
-			free_fdset(new_fdt);
-			kfree(new_fdt);
-		}
+		if (new_fdt != &newf->fdtab)
+			__free_fdtable(new_fdt);
 
 		new_fdt = alloc_fdtable(open_files - 1);
 		if (!new_fdt) {
@@ -337,9 +328,7 @@ struct files_struct *dup_fd(struct files
 
 		/* beyond sysctl_nr_open; nothing to do */
 		if (unlikely(new_fdt->max_fds < open_files)) {
-			free_fdarr(new_fdt);
-			free_fdset(new_fdt);
-			kfree(new_fdt);
+			__free_fdtable(new_fdt);
 			*errorp = -EMFILE;
 			goto out_release;
 		}
_

Patches currently in -mm which might be from xiaosuo@gmail.com are

linux-next.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix.patch

