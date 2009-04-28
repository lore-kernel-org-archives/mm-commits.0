From: akpm@linux-foundation.org
Subject: + fsnotify-add-correlations-between-events.patch added to -mm tree
Date: Tue, 28 Apr 2009 13:28:15 -0700
Message-ID: <200904282028.n3SKSFoB021129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436AbZD1UcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 16:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     fsnotify: add correlations between events
has been added to the -mm tree.  Its filename is
     fsnotify-add-correlations-between-events.patch

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
Subject: fsnotify: add correlations between events
From: Eric Paris <eparis@redhat.com>

As part of the standard inotify events it includes a correlation cookie
between two dentry move operations.  This patch includes the same
behaviour in fsnotify events.  It is needed so that inotify userspace can
be implemented on top of fsnotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c             |    6 ++--
 fs/notify/notification.c         |   20 ++++++++++++++-
 include/linux/fsnotify.h         |   37 ++++++++++++++---------------
 include/linux/fsnotify_backend.h |   15 +++++++++--
 4 files changed, 52 insertions(+), 26 deletions(-)

diff -puN fs/notify/fsnotify.c~fsnotify-add-correlations-between-events fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-add-correlations-between-events
+++ a/fs/notify/fsnotify.c
@@ -115,7 +115,7 @@ void __fsnotify_parent(struct dentry *de
 		mask |= FS_EVENT_ON_CHILD;
 
 		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
-			 dentry->d_name.name);
+			 dentry->d_name.name, 0);
 		dput(parent);
 	}
 
@@ -132,7 +132,7 @@ EXPORT_SYMBOL_GPL(__fsnotify_parent);
  * out to all of the registered fsnotify_group.  Those groups can then use the
  * notification event in whatever means they feel necessary.
  */
-void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *file_name)
+void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *file_name, u32 cookie)
 {
 	struct fsnotify_group *group;
 	struct fsnotify_event *event = NULL;
@@ -157,7 +157,7 @@ void fsnotify(struct inode *to_tell, __u
 			if (!group->ops->should_send_event(group, to_tell, mask))
 				continue;
 			if (!event) {
-				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name);
+				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name, cookie);
 				/* shit, we OOM'd and now we can't tell, maybe
 				 * someday someone else will want to do something
 				 * here */
diff -puN fs/notify/notification.c~fsnotify-add-correlations-between-events fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-add-correlations-between-events
+++ a/fs/notify/notification.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/mutex.h>
 #include <linux/namei.h>
@@ -56,6 +57,17 @@ static struct kmem_cache *fsnotify_event
  * get set to 0 so it will never get 'freed'
  */
 static struct fsnotify_event q_overflow_event;
+static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
+
+/**
+ * fsnotify_get_cookie - return a unique cookie for use in synchronizing events.
+ * Called from fsnotify_move, which is inlined into filesystem modules.
+ */
+u32 fsnotify_get_cookie(void)
+{
+	return atomic_inc_return(&fsnotify_sync_cookie);
+}
+EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 
 /* return true if the notify queue is empty, false otherwise */
 bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
@@ -266,6 +278,8 @@ static void initialize_event(struct fsno
 
 	event->file_name = NULL;
 	event->name_len = 0;
+
+	event->sync_cookie = 0;
 }
 
 /*
@@ -280,8 +294,8 @@ static void initialize_event(struct fsno
  * @data_type flag indication if the data is a file, path, inode, nothing...
  * @name the filename, if available
  */
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
-					     void *data, int data_type, const char *name)
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data,
+					     int data_type, const char *name, u32 cookie)
 {
 	struct fsnotify_event *event;
 
@@ -299,6 +313,8 @@ struct fsnotify_event *fsnotify_create_e
 		}
 		event->name_len = strlen(event->file_name);
 	}
+
+	event->sync_cookie = cookie;
 	event->to_tell = to_tell;
 
 	switch (data_type) {
diff -puN include/linux/fsnotify.h~fsnotify-add-correlations-between-events include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~fsnotify-add-correlations-between-events
+++ a/include/linux/fsnotify.h
@@ -58,7 +58,7 @@ static inline void fsnotify_link_count(s
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
 
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -69,7 +69,7 @@ static inline void fsnotify_inode_remove
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	__fsnotify_inode_delete(inode);
 }
 
@@ -81,7 +81,8 @@ static inline void fsnotify_move(struct 
 				 int isdir, struct inode *target, struct dentry *moved)
 {
 	struct inode *source = moved->d_inode;
-	u32 cookie = inotify_get_cookie();
+	u32 in_cookie = inotify_get_cookie();
+	u32 fs_cookie = fsnotify_get_cookie();
 	__u32 old_dir_mask = 0;
 	__u32 new_dir_mask = 0;
 
@@ -98,13 +99,13 @@ static inline void fsnotify_move(struct 
 	old_dir_mask |= FS_MOVED_FROM;
 	new_dir_mask |= FS_MOVED_TO;
 
-	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie,old_name,
+	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir, in_cookie, old_name,
 				  source);
-	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
+	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, in_cookie, new_name,
 				  source);
 
-	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name);
-	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name);
+	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name, fs_cookie);
+	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name, fs_cookie);
 
 	if (target) {
 		inotify_inode_queue_event(target, IN_DELETE_SELF, 0, NULL, NULL);
@@ -116,7 +117,7 @@ static inline void fsnotify_move(struct 
 
 	if (source) {
 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
-		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -150,7 +151,7 @@ static inline void fsnotify_inoderemove(
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -162,7 +163,7 @@ static inline void fsnotify_create(struc
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -177,7 +178,7 @@ static inline void fsnotify_link(struct 
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
 }
 
 /*
@@ -191,7 +192,7 @@ static inline void fsnotify_mkdir(struct
 	inotify_inode_queue_event(inode, mask, 0, dentry->d_name.name, d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -208,7 +209,7 @@ static inline void fsnotify_access(struc
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -225,7 +226,7 @@ static inline void fsnotify_modify(struc
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -242,7 +243,7 @@ static inline void fsnotify_open(struct 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -261,7 +262,7 @@ static inline void fsnotify_close(struct
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
@@ -278,7 +279,7 @@ static inline void fsnotify_xattr(struct
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -314,7 +315,7 @@ static inline void fsnotify_change(struc
 		inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 		fsnotify_parent(dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 }
 
diff -puN include/linux/fsnotify_backend.h~fsnotify-add-correlations-between-events include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-add-correlations-between-events
+++ a/include/linux/fsnotify_backend.h
@@ -193,6 +193,7 @@ struct fsnotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	__u32 mask;		/* the type of access, bitwise OR for FS_* event types */
 
+	u32 sync_cookie;	/* used to corrolate events, namely inotify mv events */
 	char *file_name;
 	size_t name_len;
 };
@@ -227,9 +228,11 @@ struct fsnotify_mark_entry {
 /* called from the vfs helpers */
 
 /* main fsnotify call to send events */
-extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name);
+extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
+		     const char *name, u32 cookie);
 extern void __fsnotify_parent(struct dentry *dentry, __u32 mask);
 extern void __fsnotify_inode_delete(struct inode *inode);
+extern u32 fsnotify_get_cookie(void);
 
 static inline int fsnotify_inode_watches_children(struct inode *inode)
 {
@@ -322,12 +325,13 @@ extern void fsnotify_put_mark(struct fsn
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
-						    void *data, int data_is, const char *name);
+						    void *data, int data_is, const char *name,
+						    u32 cookie);
 
 #else
 
 static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
-			    const char *name);
+			    const char *name, u32 cookie)
 {}
 
 static inline void __fsnotify_parent(struct dentry *dentry, __u32 mask)
@@ -342,6 +346,11 @@ static inline void __fsnotify_update_dca
 static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
 {}
 
+static inline u32 fsnotify_get_cookie(void)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
mutex-add-atomic_dec_and_mutex_lock.patch
fsnotify-unified-filesystem-notification-backend.patch
fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes.patch
fsnotify-parent-event-notification.patch
dnotify-reimplement-dnotify-using-fsnotify.patch
fsnotify-generic-notification-queue-and-waitq.patch
fsnotify-include-pathnames-with-entries-when-possible.patch
fsnotify-add-correlations-between-events.patch
fsnotify-allow-groups-to-add-private-data-to-events.patch
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch

