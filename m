From: akpm@linux-foundation.org
Subject: [patch 031/111] uapi: move forward declarations of internal
 structures
Date: Tue, 02 Aug 2016 14:03:36 -0700
Message-ID: <57a10aa8.Uc1KwE1n7gOF/n09%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbcHBVRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

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
