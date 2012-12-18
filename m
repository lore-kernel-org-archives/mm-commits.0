From: akpm@linux-foundation.org
Subject: [merged] procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:26 -0800
Message-ID: <20121218201227.4BB81200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:41745 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2LRUMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:31 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so69820lbo.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: add ability to plug in auxiliary fdinfo providers
has been removed from the -mm tree.  Its filename was
     procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: add ability to plug in auxiliary fdinfo providers

This patch brings ability to print out auxiliary data associated
with file in procfs interface /proc/pid/fdinfo/fd.

In particular further patches make eventfd, evenpoll, signalfd
and fsnotify to print additional information complete enough
to restore these objects after checkpoint.

To simplify the code we add show_fdinfo callback inside
struct file_operations (as Al and Pavel are proposing).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c       |    2 ++
 include/linux/fs.h |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/proc/fd.c~procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers fs/proc/fd.c
--- a/fs/proc/fd.c~procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers
+++ a/fs/proc/fd.c
@@ -50,6 +50,8 @@ static int seq_show(struct seq_file *m, 
 	if (!ret) {
                 seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
 			   (long long)file->f_pos, f_flags);
+		if (file->f_op->show_fdinfo)
+			ret = file->f_op->show_fdinfo(m, file);
 		fput(file);
 	}
 
diff -puN include/linux/fs.h~procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers include/linux/fs.h
--- a/include/linux/fs.h~procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers
+++ a/include/linux/fs.h
@@ -44,6 +44,7 @@ struct vm_area_struct;
 struct vfsmount;
 struct cred;
 struct swap_info_struct;
+struct seq_file;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1543,6 +1544,7 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
+	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 struct inode_operations {
@@ -1578,8 +1580,6 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 } ____cacheline_aligned;
 
-struct seq_file;
