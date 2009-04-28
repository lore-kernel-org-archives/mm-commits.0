From: akpm@linux-foundation.org
Subject: + fsnotify-include-pathnames-with-entries-when-possible.patch added to -mm tree
Date: Tue, 28 Apr 2009 13:28:13 -0700
Message-ID: <200904282028.n3SKSDwO021126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875AbZD1Ucp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 16:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     fsnotify: include pathnames with entries when possible
has been added to the -mm tree.  Its filename is
     fsnotify-include-pathnames-with-entries-when-possible.patch

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
Subject: fsnotify: include pathnames with entries when possible
From: Eric Paris <eparis@redhat.com>

When inotify wants to send events to a directory about a child it includes
the name of the original file.  This patch collects that filename and
makes it available for notification.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c             |    7 ++---
 fs/notify/notification.c         |   16 ++++++++++-
 include/linux/fsnotify.h         |   40 ++++++++++++++++++-----------
 include/linux/fsnotify_backend.h |   11 +++++--
 4 files changed, 53 insertions(+), 21 deletions(-)

diff -puN fs/notify/fsnotify.c~fsnotify-include-pathnames-with-entries-when-possible fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-include-pathnames-with-entries-when-possible
+++ a/fs/notify/fsnotify.c
@@ -114,7 +114,8 @@ void __fsnotify_parent(struct dentry *de
 		 * specifies these are events which came from a child. */
 		mask |= FS_EVENT_ON_CHILD;
 
-		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
+			 dentry->d_name.name);
 		dput(parent);
 	}
 
@@ -131,7 +132,7 @@ EXPORT_SYMBOL_GPL(__fsnotify_parent);
  * out to all of the registered fsnotify_group.  Those groups can then use the
  * notification event in whatever means they feel necessary.
  */
-void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
+void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *file_name)
 {
 	struct fsnotify_group *group;
 	struct fsnotify_event *event = NULL;
@@ -156,7 +157,7 @@ void fsnotify(struct inode *to_tell, __u
 			if (!group->ops->should_send_event(group, to_tell, mask))
 				continue;
 			if (!event) {
-				event = fsnotify_create_event(to_tell, mask, data, data_is);
+				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name);
 				/* shit, we OOM'd and now we can't tell, maybe
 				 * someday someone else will want to do something
 				 * here */
diff -puN fs/notify/notification.c~fsnotify-include-pathnames-with-entries-when-possible fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-include-pathnames-with-entries-when-possible
+++ a/fs/notify/notification.c
@@ -78,6 +78,7 @@ void fsnotify_put_event(struct fsnotify_
 		if (event->data_type == FSNOTIFY_EVENT_PATH)
 			path_put(&event->path);
 
+		kfree(event->file_name);
 		kmem_cache_free(fsnotify_event_cachep, event);
 	}
 }
@@ -262,6 +263,9 @@ static void initialize_event(struct fsno
 	event->data_type = FSNOTIFY_EVENT_NONE;
 
 	event->to_tell = NULL;
+
+	event->file_name = NULL;
+	event->name_len = 0;
 }
 
 /*
@@ -274,9 +278,10 @@ static void initialize_event(struct fsno
  * @mask what actually happened.
  * @data pointer to the object which was actually affected
  * @data_type flag indication if the data is a file, path, inode, nothing...
+ * @name the filename, if available
  */
 struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
-					     void *data, int data_type)
+					     void *data, int data_type, const char *name)
 {
 	struct fsnotify_event *event;
 
@@ -285,6 +290,15 @@ struct fsnotify_event *fsnotify_create_e
 		return NULL;
 
 	initialize_event(event);
+
+	if (name) {
+		event->file_name = kstrdup(name, GFP_KERNEL);
+		if (!event->file_name) {
+			kmem_cache_free(fsnotify_event_cachep, event);
+			return NULL;
+		}
+		event->name_len = strlen(event->file_name);
+	}
 	event->to_tell = to_tell;
 
 	switch (data_type) {
diff -puN include/linux/fsnotify.h~fsnotify-include-pathnames-with-entries-when-possible include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~fsnotify-include-pathnames-with-entries-when-possible
+++ a/include/linux/fsnotify.h
@@ -58,7 +58,19 @@ static inline void fsnotify_link_count(s
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
 
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL);
+}
+
+/*
+ * fsnotify_inode_remove - an inode is going away
+ */
+static inline void fsnotify_inode_remove(struct inode *inode)
+{
+	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
+	inotify_inode_is_dead(inode);
+
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
+	__fsnotify_inode_delete(inode);
 }
 
 /*
@@ -91,8 +103,8 @@ static inline void fsnotify_move(struct 
 	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
 				  source);
 
-	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE);
-	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE);
+	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name);
+	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name);
 
 	if (target) {
 		inotify_inode_queue_event(target, IN_DELETE_SELF, 0, NULL, NULL);
@@ -104,7 +116,7 @@ static inline void fsnotify_move(struct 
 
 	if (source) {
 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
-		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -138,7 +150,7 @@ static inline void fsnotify_inoderemove(
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -150,7 +162,7 @@ static inline void fsnotify_create(struc
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 }
 
 /*
@@ -165,7 +177,7 @@ static inline void fsnotify_link(struct 
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name);
 }
 
 /*
@@ -179,7 +191,7 @@ static inline void fsnotify_mkdir(struct
 	inotify_inode_queue_event(inode, mask, 0, dentry->d_name.name, d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 }
 
 /*
@@ -196,7 +208,7 @@ static inline void fsnotify_access(struc
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -213,7 +225,7 @@ static inline void fsnotify_modify(struc
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -230,7 +242,7 @@ static inline void fsnotify_open(struct 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -249,7 +261,7 @@ static inline void fsnotify_close(struct
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
 }
 
 /*
@@ -266,7 +278,7 @@ static inline void fsnotify_xattr(struct
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -302,7 +314,7 @@ static inline void fsnotify_change(struc
 		inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 		fsnotify_parent(dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 	}
 }
 
diff -puN include/linux/fsnotify_backend.h~fsnotify-include-pathnames-with-entries-when-possible include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-include-pathnames-with-entries-when-possible
+++ a/include/linux/fsnotify_backend.h
@@ -192,6 +192,9 @@ struct fsnotify_event {
 	int data_type;		/* which of the above union we have */
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	__u32 mask;		/* the type of access, bitwise OR for FS_* event types */
+
+	char *file_name;
+	size_t name_len;
 };
 
 /*
@@ -224,7 +227,7 @@ struct fsnotify_mark_entry {
 /* called from the vfs helpers */
 
 /* main fsnotify call to send events */
-extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
+extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name);
 extern void __fsnotify_parent(struct dentry *dentry, __u32 mask);
 extern void __fsnotify_inode_delete(struct inode *inode);
 
@@ -319,10 +322,12 @@ extern void fsnotify_put_mark(struct fsn
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
-						    void *data, int data_is);
+						    void *data, int data_is, const char *name);
+
 #else
 
-static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
+static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
+			    const char *name);
 {}
 
 static inline void __fsnotify_parent(struct dentry *dentry, __u32 mask)
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

