From: akpm@linux-foundation.org
Subject: + fs-epoll-add-procfs-fdinfo-helper-v2.patch added to -mm tree
Date: Fri, 16 Nov 2012 15:56:41 -0800
Message-ID: <20121116235641.DB32220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58379 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab2KPX4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 18:56:46 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so71608bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 15:56:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: fs, epoll: add procfs fdinfo helper
has been added to the -mm tree.  Its filename is
     fs-epoll-add-procfs-fdinfo-helper-v2.patch

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
Subject: fs, epoll: add procfs fdinfo helper

This allows us to print out eventpoll target file descriptor, events and
data, the /proc/pid/fdinfo/fd consists of

 | pos:	0
 | flags:	02
 | tfd:        5 events:       1d data: ffffffffffffffff enabled: 1

[avagin@: fix for unitialized ret variable]

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

 fs/eventpoll.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN fs/eventpoll.c~fs-epoll-add-procfs-fdinfo-helper-v2 fs/eventpoll.c
--- a/fs/eventpoll.c~fs-epoll-add-procfs-fdinfo-helper-v2
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
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v6.patch
fs-notify-add-procfs-fdinfo-helper-v6-fix.patch

