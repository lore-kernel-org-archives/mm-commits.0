From: akpm@linux-foundation.org
Subject: [folded] namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:29:22 -0700
Message-ID: <200904062229.n36MTMU6015719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbZDFWc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, adobriyan@gmail.com, clg@fr.ibm.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix
has been removed from the -mm tree.  Its filename was
     namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch

This patch was dropped because it was folded into namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix
From: Serge E. Hallyn <serue@us.ibm.com>

get_sb_ns does not require CONFIG_BLOCK, so move it outside of the
CONFIG_BLOCK ifdef in fs/super.c.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff -puN fs/super.c~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix fs/super.c
--- a/fs/super.c~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix
+++ a/fs/super.c
@@ -764,19 +764,6 @@ void kill_litter_super(struct super_bloc
 
 EXPORT_SYMBOL(kill_litter_super);
 
-#ifdef CONFIG_BLOCK
-static int set_bdev_super(struct super_block *s, void *data)
-{
-	s->s_bdev = data;
-	s->s_dev = s->s_bdev->bd_dev;
-	return 0;
-}
-
-static int test_bdev_super(struct super_block *s, void *data)
-{
-	return (void *)s->s_bdev == data;
-}
-
 static int ns_test_super(struct super_block *sb, void *data)
 {
 	return sb->s_fs_info == data;
@@ -815,6 +802,21 @@ int get_sb_ns(struct file_system_type *f
 	return 0;
 }
 
+EXPORT_SYMBOL(get_sb_ns);
+
+#ifdef CONFIG_BLOCK
+static int set_bdev_super(struct super_block *s, void *data)
+{
+	s->s_bdev = data;
+	s->s_dev = s->s_bdev->bd_dev;
+	return 0;
+}
+
+static int test_bdev_super(struct super_block *s, void *data)
+{
+	return (void *)s->s_bdev == data;
+}
+
 int get_sb_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int),
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
reiser4.patch

