From: akpm@linux-foundation.org
Subject: - allow-access-to-proc-pid-fd-after-setuid.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:58 -0700
Message-ID: <200705090243.l492hwA5008531@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968776AbXEICpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, chrisw@sous-sol.org, dev@openvz.org, drepper@redhat.com, ebiederm@xmission.com, hch@lst.de, jmorris@namei.org, oleg@tv-sign.ru, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Allow access to /proc/$PID/fd after setuid()
has been removed from the -mm tree.  Its filename was
     allow-access-to-proc-pid-fd-after-setuid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow access to /proc/$PID/fd after setuid()
From: Alexey Dobriyan <adobriyan@openvz.org>

/proc/$PID/fd has r-x------ permissions, so if process does setuid(), it
will not be able to access /proc/*/fd/. This breaks fstatat() emulation
in glibc.

open("foo", O_RDONLY|O_DIRECTORY)       = 4
setuid32(65534)                         = 0
stat64("/proc/self/fd/4/bar", 0xbfafb298) = -1 EACCES (Permission denied)

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Acked-By: Kirill Korotaev <dev@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid fs/proc/base.c
--- a/fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid
+++ a/fs/proc/base.c
@@ -1448,10 +1448,28 @@ static const struct file_operations proc
 };
 
 /*
+ * /proc/pid/fd needs a special permission handler so that a process can still
+ * access /proc/self/fd after it has executed a setuid().
+ */
+static int proc_fd_permission(struct inode *inode, int mask,
+				struct nameidata *nd)
+{
+	int rv;
+
+	rv = generic_permission(inode, mask, NULL);
+	if (rv == 0)
+		return 0;
+	if (task_pid(current) == proc_pid(inode))
+		rv = 0;
+	return rv;
+}
+
+/*
  * proc directories can do almost nothing..
  */
 static const struct inode_operations proc_fd_inode_operations = {
 	.lookup		= proc_lookupfd,
+	.permission	= proc_fd_permission,
 	.setattr	= proc_setattr,
 };
 
_

Patches currently in -mm which might be from adobriyan@openvz.org are

origin.patch
git-ia64.patch
git-parisc.patch
x86-msr-add-support-for-safe-variants.patch
