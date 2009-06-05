From: akpm@linux-foundation.org
Subject: [merged] doc-add-documentation-for-debugfs.patch removed from -mm tree
Date: Fri, 05 Jun 2009 11:55:23 -0700
Message-ID: <200906051855.n55ItN77020683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbZFESz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 14:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shen@cn.fujitsu.com, corbet@lwn.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     doc: add documentation for debugfs
has been removed from the -mm tree.  Its filename was
     doc-add-documentation-for-debugfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: add documentation for debugfs
From: Shen Feng <shen@cn.fujitsu.com>

debugfs is used as a virtual filesystem devoted to debugging information. 
But it's not documented in Documentation/filesystems.  Add one for it. 
The content is mainly from http://lwn.net/Articles/115405/

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/debugfs.txt |   51 ++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff -puN /dev/null Documentation/filesystems/debugfs.txt
--- /dev/null
+++ a/Documentation/filesystems/debugfs.txt
@@ -0,0 +1,51 @@
+        Debugfs - a virtual filesystem devoted to debugging information
+
+Debugfs is a virtual filesystem devoted to debugging information. Debugfs is
+intended to be a relatively easy and lightweight subsystem which gracefully
+disappears when configured out of the kernel.
+
+Traditionally debugfs is supposed to be mounted at /sys/kernel/debug with the
+following command:
+
+ # mount -t debugfs none /sys/kernel/debug/
+
+A developer wishing to use debugfs starts by creating a directory within the
+filesystem:
+
+    struct dentry *debugfs_create_dir(const char *name,
+                                      struct dentry *parent);
+
+The parent argument will usually be NULL, causing the directory to be created
+in the debugfs root. If debugfs is not configured into the system, the return
+value is -ENODEV; a NULL return, instead, indicates some other sort of error.
+
+The general-purpose function for creating a file in debugfs is:
+
+    struct dentry *debugfs_create_file(const char *name, mode_t mode,
+                                       struct dentry *parent, void *data,
+                                       struct file_operations *fops);
+
+The structure pointed to by fops should, of course, contain pointers to the
+functions which implement the actual operations on the file. In many cases,
+most of those functions can be the helpers provided by seq_file, making the
+task of exporting a file easy.
+
+Some additional helpers have been provided to make exporting a single value as
+easy as possible:
+
+    struct dentry *debugfs_create_u8(const char *name, mode_t mode,
+                                     struct dentry *parent, u8 *value);
+    struct dentry *debugfs_create_u16(const char *name, mode_t mode,
+                                      struct dentry *parent, u16 *value);
+    struct dentry *debugfs_create_u32(const char *name, mode_t mode,
+                                      struct dentry *parent, u32 *value);
+    struct dentry *debugfs_create_bool(const char *name, mode_t mode,
+                                       struct dentry *parent, u32 *value);
+
+Debugfs does not automatically clean up files when a module shuts down, so,
+for every file or directory created with the above functions, there must be a
+call to:
+
+    void debugfs_remove(struct dentry *dentry);
+
+See Documentation/DocBook/filesystems for more details.
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

linux-next.patch

