From: akpm@linux-foundation.org
Subject: + namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:45:15 -0800
Message-ID: <200902262245.n1QMjF5u030477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbZBZWp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:45:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, adobriyan@gmail.com, clg@fr.ibm.com, randy.dunlap@oracle.com


The patch titled
     namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix
has been added to the -mm tree.  Its filename is
     namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch

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

fix-recursive-lock-in-free_uid-free_user_ns.patch
linux-next.patch
vfs-simple_set_mnt-should-return-void.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
reiser4.patch

