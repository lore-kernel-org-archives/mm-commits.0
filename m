From: akpm@linux-foundation.org
Subject: [merged]
 uapi-move-forward-declarations-of-internal-structures.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 11:11:47 -0700
Message-ID: <57a233e3.V678jui5Gp3PeKDq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbcHCSN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uapi: move forward declarations of internal structures
has been removed from the -mm tree.  Its filename was
     uapi-move-forward-declarations-of-internal-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: uapi: move forward declarations of internal structures

Don't user forward declarations of internal kernel structures
in headers exported to userspace.

Move "struct completion;".
Move "struct task_struct;".

Link: http://lkml.kernel.org/r/20160713215808.GA22486@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h      |    1 +
 include/linux/sysctl.h          |    1 +
 include/uapi/linux/capability.h |    2 --
 include/uapi/linux/sysctl.h     |    2 --
 4 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/capability.h~uapi-move-forward-declarations-of-internal-structures include/linux/capability.h
--- a/include/linux/capability.h~uapi-move-forward-declarations-of-internal-structures
+++ a/include/linux/capability.h
@@ -38,6 +38,7 @@ struct cpu_vfs_cap_data {
 struct file;
 struct inode;
 struct dentry;
+struct task_struct;
 struct user_namespace;
 
 extern const kernel_cap_t __cap_empty_set;
diff -puN include/linux/sysctl.h~uapi-move-forward-declarations-of-internal-structures include/linux/sysctl.h
--- a/include/linux/sysctl.h~uapi-move-forward-declarations-of-internal-structures
+++ a/include/linux/sysctl.h
@@ -28,6 +28,7 @@
 #include <uapi/linux/sysctl.h>
 
 /* For the /proc/sys support */
+struct completion;
 struct ctl_table;
 struct nsproxy;
 struct ctl_table_root;
diff -puN include/uapi/linux/capability.h~uapi-move-forward-declarations-of-internal-structures include/uapi/linux/capability.h
--- a/include/uapi/linux/capability.h~uapi-move-forward-declarations-of-internal-structures
+++ a/include/uapi/linux/capability.h
@@ -15,8 +15,6 @@
 
 #include <linux/types.h>
 
-struct task_struct;
-
 /* User-level do most of the mapping between kernel and user
    capabilities based on the version tag given by the kernel. The
    kernel might be somewhat backwards compatible, but don't bet on
diff -puN include/uapi/linux/sysctl.h~uapi-move-forward-declarations-of-internal-structures include/uapi/linux/sysctl.h
--- a/include/uapi/linux/sysctl.h~uapi-move-forward-declarations-of-internal-structures
+++ a/include/uapi/linux/sysctl.h
@@ -26,8 +26,6 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-struct completion;
