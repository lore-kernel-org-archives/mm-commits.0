From: akpm@linux-foundation.org
Subject: + inotify-update-documentation-to-reflect-code-changes.patch
 added to -mm tree
Date: Mon, 09 Feb 2015 13:51:31 -0800
Message-ID: <54d92be3.mc3ni4es4tuvnk7F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760747AbbBIVvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2015 16:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, eparis@parisplace.org, jack@suse.cz, john@johnmccutchan.com, morgan.wang@huawei.com, robert.w.love@intel.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify: update documentation to reflect code changes
has been added to the -mm tree.  Its filename is
     inotify-update-documentation-to-reflect-code-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/inotify-update-documentation-to-reflect-code-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/inotify-update-documentation-to-reflect-code-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: inotify: update documentation to reflect code changes

The inotify interface has changed a lot.  The user interface was too old,
and the kernel interface was removed by Eric Paris in commit: 2dfc1ca
inotify: remove inotify in kernel interface.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Wang Kai <morgan.wang@huawei.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Robert Love <robert.w.love@intel.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/inotify.txt |  197 ------------------------
 1 file changed, 3 insertions(+), 194 deletions(-)

diff -puN Documentation/filesystems/inotify.txt~inotify-update-documentation-to-reflect-code-changes Documentation/filesystems/inotify.txt
--- a/Documentation/filesystems/inotify.txt~inotify-update-documentation-to-reflect-code-changes
+++ a/Documentation/filesystems/inotify.txt
@@ -4,201 +4,10 @@
 
 
 Document started 15 Mar 2005 by Robert Love <rml@novell.com>
+Document updated 4 Jan 2015 by Zhang Zhen <zhenzhang.zhang@huawei.com>
+	--Deleted obsoleted interface, just refer to manpages for user interface.
 
-
-(i) User Interface
-
-Inotify is controlled by a set of three system calls and normal file I/O on a
-returned file descriptor.
-
-First step in using inotify is to initialise an inotify instance:
-
-	int fd = inotify_init ();
-
-Each instance is associated with a unique, ordered queue.
-
-Change events are managed by "watches".  A watch is an (object,mask) pair where
-the object is a file or directory and the mask is a bit mask of one or more
-inotify events that the application wishes to receive.  See <linux/inotify.h>
-for valid events.  A watch is referenced by a watch descriptor, or wd.
-
-Watches are added via a path to the file.
-
-Watches on a directory will return events on any files inside of the directory.
-
-Adding a watch is simple:
-
-	int wd = inotify_add_watch (fd, path, mask);
-
-Where "fd" is the return value from inotify_init(), path is the path to the
-object to watch, and mask is the watch mask (see <linux/inotify.h>).
-
-You can update an existing watch in the same manner, by passing in a new mask.
-
-An existing watch is removed via
-
-	int ret = inotify_rm_watch (fd, wd);
-
-Events are provided in the form of an inotify_event structure that is read(2)
-from a given inotify instance.  The filename is of dynamic length and follows
-the struct. It is of size len.  The filename is padded with null bytes to
-ensure proper alignment.  This padding is reflected in len.
-
-You can slurp multiple events by passing a large buffer, for example
-
-	size_t len = read (fd, buf, BUF_LEN);
-
-Where "buf" is a pointer to an array of "inotify_event" structures at least
-BUF_LEN bytes in size.  The above example will return as many events as are
-available and fit in BUF_LEN.
-
-Each inotify instance fd is also select()- and poll()-able.
-
-You can find the size of the current event queue via the standard FIONREAD
-ioctl on the fd returned by inotify_init().
-
-All watches are destroyed and cleaned up on close.
-
-
-(ii)
-
-Prototypes:
-
-	int inotify_init (void);
-	int inotify_add_watch (int fd, const char *path, __u32 mask);
-	int inotify_rm_watch (int fd, __u32 mask);
-
-
-(iii) Kernel Interface
-
-Inotify's kernel API consists a set of functions for managing watches and an
-event callback.
-
-To use the kernel API, you must first initialize an inotify instance with a set
-of inotify_operations.  You are given an opaque inotify_handle, which you use
-for any further calls to inotify.
-
-    struct inotify_handle *ih = inotify_init(my_event_handler);
-
-You must provide a function for processing events and a function for destroying
-the inotify watch.
-
-    void handle_event(struct inotify_watch *watch, u32 wd, u32 mask,
-    	              u32 cookie, const char *name, struct inode *inode)
-
-	watch - the pointer to the inotify_watch that triggered this call
-	wd - the watch descriptor
-	mask - describes the event that occurred
-	cookie - an identifier for synchronizing events
-	name - the dentry name for affected files in a directory-based event
-	inode - the affected inode in a directory-based event
-
-    void destroy_watch(struct inotify_watch *watch)
-
-You may add watches by providing a pre-allocated and initialized inotify_watch
-structure and specifying the inode to watch along with an inotify event mask.
-You must pin the inode during the call.  You will likely wish to embed the
-inotify_watch structure in a structure of your own which contains other
-information about the watch.  Once you add an inotify watch, it is immediately
-subject to removal depending on filesystem events.  You must grab a reference if
-you depend on the watch hanging around after the call.
-
-    inotify_init_watch(&my_watch->iwatch);
-    inotify_get_watch(&my_watch->iwatch);	// optional
-    s32 wd = inotify_add_watch(ih, &my_watch->iwatch, inode, mask);
-    inotify_put_watch(&my_watch->iwatch);	// optional
-
-You may use the watch descriptor (wd) or the address of the inotify_watch for
-other inotify operations.  You must not directly read or manipulate data in the
-inotify_watch.  Additionally, you must not call inotify_add_watch() more than
-once for a given inotify_watch structure, unless you have first called either
-inotify_rm_watch() or inotify_rm_wd().
-
-To determine if you have already registered a watch for a given inode, you may
-call inotify_find_watch(), which gives you both the wd and the watch pointer for
-the inotify_watch, or an error if the watch does not exist.
-
-    wd = inotify_find_watch(ih, inode, &watchp);
-
-You may use container_of() on the watch pointer to access your own data
-associated with a given watch.  When an existing watch is found,
-inotify_find_watch() bumps the refcount before releasing its locks.  You must
-put that reference with:
-
-    put_inotify_watch(watchp);
-
-Call inotify_find_update_watch() to update the event mask for an existing watch.
-inotify_find_update_watch() returns the wd of the updated watch, or an error if
-the watch does not exist.
-
-    wd = inotify_find_update_watch(ih, inode, mask);
-
-An existing watch may be removed by calling either inotify_rm_watch() or
-inotify_rm_wd().
-
-    int ret = inotify_rm_watch(ih, &my_watch->iwatch);
-    int ret = inotify_rm_wd(ih, wd);
-
-A watch may be removed while executing your event handler with the following:
-
-    inotify_remove_watch_locked(ih, iwatch);
-
-Call inotify_destroy() to remove all watches from your inotify instance and
-release it.  If there are no outstanding references, inotify_destroy() will call
-your destroy_watch op for each watch.
-
-    inotify_destroy(ih);
-
-When inotify removes a watch, it sends an IN_IGNORED event to your callback.
-You may use this event as an indication to free the watch memory.  Note that
-inotify may remove a watch due to filesystem events, as well as by your request.
-If you use IN_ONESHOT, inotify will remove the watch after the first event, at
-which point you may call the final inotify_put_watch.
-
-(iv) Kernel Interface Prototypes
-
-	struct inotify_handle *inotify_init(struct inotify_operations *ops);
-
-	inotify_init_watch(struct inotify_watch *watch);
-
-	s32 inotify_add_watch(struct inotify_handle *ih,
-		              struct inotify_watch *watch,
-			      struct inode *inode, u32 mask);
-
-	s32 inotify_find_watch(struct inotify_handle *ih, struct inode *inode,
-			       struct inotify_watch **watchp);
-
-	s32 inotify_find_update_watch(struct inotify_handle *ih,
-				      struct inode *inode, u32 mask);
-
-	int inotify_rm_wd(struct inotify_handle *ih, u32 wd);
-
-	int inotify_rm_watch(struct inotify_handle *ih,
-			     struct inotify_watch *watch);
-
-	void inotify_remove_watch_locked(struct inotify_handle *ih,
-					 struct inotify_watch *watch);
-
-	void inotify_destroy(struct inotify_handle *ih);
-
-	void get_inotify_watch(struct inotify_watch *watch);
-	void put_inotify_watch(struct inotify_watch *watch);
-
-
-(v) Internal Kernel Implementation
-
-Each inotify instance is represented by an inotify_handle structure.
-Inotify's userspace consumers also have an inotify_device which is
-associated with the inotify_handle, and on which events are queued.
-
-Each watch is associated with an inotify_watch structure.  Watches are chained
-off of each associated inotify_handle and each associated inode.
-
-See fs/notify/inotify/inotify_fsnotify.c and fs/notify/inotify/inotify_user.c
-for the locking and lifetime rules.
-
