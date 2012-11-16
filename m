From: akpm@linux-foundation.org
Subject: + procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch added to -mm tree
Date: Fri, 16 Nov 2012 15:56:33 -0800
Message-ID: <20121116235634.60D93100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:63410 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2KPX4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 18:56:36 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so364523ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 15:56:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: procfs: add ability to plug in auxiliary fdinfo providers
has been added to the -mm tree.  Its filename is
     procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1545,6 +1546,7 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
+	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 struct inode_operations {
@@ -1580,8 +1582,6 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 } ____cacheline_aligned;
 
-struct seq_file;
