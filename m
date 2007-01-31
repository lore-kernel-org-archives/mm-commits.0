From: akpm@osdl.org
Subject: + tty-cleanup-release_mem.patch added to -mm tree
Date: Wed, 31 Jan 2007 15:59:22 -0800
Message-ID: <200701312359.l0VNxMYL030569@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933368AbXAaX7m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 18:59:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, alan@redhat.com, penberg@cs.helsinki.fi


The patch titled
     tty: cleanup release_mem
has been added to the -mm tree.  Its filename is
     tty-cleanup-release_mem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: cleanup release_mem
From: Christoph Hellwig <hch@lst.de>

release_mem contains two copies of exactly the same code.  Refactor these
into a new helper, release_tty.  The only change in behaviour is that the
driver reference count is now decremented after the master tty has been
freed instead of before.

[penberg@cs.helsinki.fi: fix use-after-free in release_tty.]
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c |   73 ++++++++++++++++++++--------------------
 1 files changed, 37 insertions(+), 36 deletions(-)

diff -puN drivers/char/tty_io.c~tty-cleanup-release_mem drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-cleanup-release_mem
+++ a/drivers/char/tty_io.c
@@ -154,7 +154,7 @@ static int tty_release(struct inode *, s
 int tty_ioctl(struct inode * inode, struct file * file,
 	      unsigned int cmd, unsigned long arg);
 static int tty_fasync(int fd, struct file * filp, int on);
-static void release_mem(struct tty_struct *tty, int idx);
+static void release_tty(struct tty_struct *tty, int idx);
 
 /**
  *	alloc_tty_struct	-	allocate a tty object
@@ -2002,7 +2002,7 @@ static int init_dev(struct tty_driver *d
 
 	/* 
 	 * All structures have been allocated, so now we install them.
-	 * Failures after this point use release_mem to clean up, so 
+	 * Failures after this point use release_tty to clean up, so
 	 * there's no need to null out the local pointers.
 	 */
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
@@ -2023,8 +2023,8 @@ static int init_dev(struct tty_driver *d
 
 	/* 
 	 * Structures all installed ... call the ldisc open routines.
-	 * If we fail here just call release_mem to clean up.  No need
-	 * to decrement the use counts, as release_mem doesn't care.
+	 * If we fail here just call release_tty to clean up.  No need
+	 * to decrement the use counts, as release_tty doesn't care.
 	 */
 
 	if (tty->ldisc.open) {
@@ -2094,17 +2094,17 @@ fail_no_mem:
 	retval = -ENOMEM;
 	goto end_init;
 
-	/* call the tty release_mem routine to clean out this slot */
+	/* call the tty release_tty routine to clean out this slot */
 release_mem_out:
 	if (printk_ratelimit())
 		printk(KERN_INFO "init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
-	release_mem(tty, idx);
+	release_tty(tty, idx);
 	goto end_init;
 }
 
 /**
- *	release_mem		-	release tty structure memory
+ *	release_one_tty		-	release tty structure memory
  *
  *	Releases memory associated with a tty structure, and clears out the
  *	driver table slots. This function is called when a device is no longer
@@ -2116,37 +2116,14 @@ release_mem_out:
  *	of ttys that the driver keeps.
  *		FIXME: should we require tty_mutex is held here ??
  */
-
-static void release_mem(struct tty_struct *tty, int idx)
+static void release_one_tty(struct tty_struct *tty, int idx)
 {
-	struct tty_struct *o_tty;
-	struct ktermios *tp;
 	int devpts = tty->driver->flags & TTY_DRIVER_DEVPTS_MEM;
-
-	if ((o_tty = tty->link) != NULL) {
-		if (!devpts)
-			o_tty->driver->ttys[idx] = NULL;
-		if (o_tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
-			tp = o_tty->termios;
-			if (!devpts)
-				o_tty->driver->termios[idx] = NULL;
-			kfree(tp);
-
-			tp = o_tty->termios_locked;
-			if (!devpts)
-				o_tty->driver->termios_locked[idx] = NULL;
-			kfree(tp);
-		}
-		o_tty->magic = 0;
-		o_tty->driver->refcount--;
-		file_list_lock();
-		list_del_init(&o_tty->tty_files);
-		file_list_unlock();
-		free_tty_struct(o_tty);
-	}
+	struct ktermios *tp;
 
 	if (!devpts)
 		tty->driver->ttys[idx] = NULL;
+
 	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
 		tp = tty->termios;
 		if (!devpts)
@@ -2159,15 +2136,39 @@ static void release_mem(struct tty_struc
 		kfree(tp);
 	}
 
+
 	tty->magic = 0;
 	tty->driver->refcount--;
+
 	file_list_lock();
 	list_del_init(&tty->tty_files);
 	file_list_unlock();
-	module_put(tty->driver->owner);
+
 	free_tty_struct(tty);
 }
 
+/**
+ *	release_tty		-	release tty structure memory
+ *
+ *	Release both @tty and a possible linked partner (think pty pair),
+ *	and decrement the refcount of the backing module.
+ *
+ *	Locking:
+ *		tty_mutex - sometimes only
+ *		takes the file list lock internally when working on the list
+ *	of ttys that the driver keeps.
+ *		FIXME: should we require tty_mutex is held here ??
+ */
+static void release_tty(struct tty_struct *tty, int idx)
+{
+	struct tty_driver *driver = tty->driver;
+
+	if (tty->link)
+		release_one_tty(tty->link, idx);
+	release_one_tty(tty, idx);
+	module_put(driver->owner);
+}
+
 /*
  * Even releasing the tty structures is a tricky business.. We have
  * to be very careful that the structures are all released at the
@@ -2435,10 +2436,10 @@ static void release_dev(struct file * fi
 		tty_set_termios_ldisc(o_tty,N_TTY); 
 	}
 	/*
-	 * The release_mem function takes care of the details of clearing
+	 * The release_tty function takes care of the details of clearing
 	 * the slots and preserving the termios structure.
 	 */
-	release_mem(tty, idx);
+	release_tty(tty, idx);
 
 #ifdef CONFIG_UNIX98_PTYS
 	/* Make this pty number available for reallocation */
_

Patches currently in -mm which might be from hch@lst.de are

git-drm.patch
git-scsi-misc.patch
slab-cache-alloc-cleanups.patch
simplify-the-stacktrace-code.patch
make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
tty-cleanup-release_mem.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
