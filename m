From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-epoll-add-procfs-fdinfo-helper.patch removed from -mm tree
Date: Tue, 13 Nov 2012 11:43:59 -0800
Message-ID: <20121113194400.497F65C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:60119 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2KMToD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:44:03 -0500
Received: by mail-wi0-f202.google.com with SMTP id hm14so59237wib.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:44:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, epoll: add procfs fdinfo helper
has been removed from the -mm tree.  Its filename was
     fs-epoll-add-procfs-fdinfo-helper.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, epoll: add procfs fdinfo helper

This allow us to print out eventpoll target file descriptor,
events and data, the /proc/pid/fdinfo/fd consists of

 | pos:	0
 | flags:	02
 | tfd:        5 events:       1d data: ffffffffffffffff enabled: 1

[avagin@: fix for unitialized ret variable]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN fs/eventpoll.c~fs-epoll-add-procfs-fdinfo-helper fs/eventpoll.c
--- a/fs/eventpoll.c~fs-epoll-add-procfs-fdinfo-helper
+++ a/fs/eventpoll.c
@@ -38,6 +38,8 @@
 #include <asm/io.h>
 #include <asm/mman.h>
 #include <linux/atomic.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 /*
  * LOCKING:
@@ -813,8 +815,35 @@ static unsigned int ep_eventpoll_poll(st
 	return pollflags != -1 ? pollflags : 0;
 }
 
+#ifdef CONFIG_PROC_FS
+static int ep_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct eventpoll *ep = f->private_data;
+	struct rb_node *rbp;
+	int ret = 0;
+
+	mutex_lock(&ep->mtx);
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
+
+		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx enabled: %d\n",
+				 epi->ffd.fd, epi->event.events,
+				 (long long)epi->event.data,
+				 ep_is_linked(&epi->rdllink));
+		if (ret)
+			break;
+	}
+	mutex_unlock(&ep->mtx);
+
+	return ret;
+}
+#endif
+
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= ep_show_fdinfo,
+#endif
 	.release	= ep_eventpoll_release,
 	.poll		= ep_eventpoll_poll,
 	.llseek		= noop_llseek,
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
proc-pid-status-add-seccomp-field.patch
fdinfo-show-sigmask-for-signalfd-fd.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

