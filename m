From: akpm@linux-foundation.org
Subject: - kernel-explicitly-include-required-header-files-under-kernel.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:41 -0700
Message-ID: <200804300540.m3U5ef3K028990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754942AbYD3FlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     kernel: explicitly include required header files under kernel/
has been removed from the -mm tree.  Its filename was
     kernel-explicitly-include-required-header-files-under-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: explicitly include required header files under kernel/
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Following an experimental deletion of the unnecessary directive

 #include <linux/slab.h>

from the header file <linux/percpu.h>, these files under kernel/ were exposed
as needing to include one of <linux/slab.h> or <linux/gfp.h>, so explicit
includes were added where necessary.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/devres.c     |    1 +
 kernel/irq/manage.c     |    1 +
 kernel/marker.c         |    1 +
 kernel/ns_cgroup.c      |    1 +
 kernel/rcutorture.c     |    1 +
 kernel/res_counter.c    |    1 +
 kernel/time.c           |    1 +
 kernel/user_namespace.c |    1 +
 kernel/utsname.c        |    1 +
 9 files changed, 9 insertions(+)

diff -puN kernel/irq/devres.c~kernel-explicitly-include-required-header-files-under-kernel kernel/irq/devres.c
--- a/kernel/irq/devres.c~kernel-explicitly-include-required-header-files-under-kernel
+++ a/kernel/irq/devres.c
@@ -1,6 +1,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
+#include <linux/gfp.h>
 
 /*
  * Device resource management aware IRQ request/free implementation.
diff -puN kernel/irq/manage.c~kernel-explicitly-include-required-header-files-under-kernel kernel/irq/manage.c
--- a/kernel/irq/manage.c~kernel-explicitly-include-required-header-files-under-kernel
+++ a/kernel/irq/manage.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 
 #include "internals.h"
 
diff -puN kernel/marker.c~kernel-explicitly-include-required-header-files-under-kernel kernel/marker.c
--- a/kernel/marker.c~kernel-explicitly-include-required-header-files-under-kernel
+++ a/kernel/marker.c
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/marker.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 
 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
diff -puN kernel/ns_cgroup.c~kernel-explicitly-include-required-header-files-under-kernel kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~kernel-explicitly-include-required-header-files-under-kernel
+++ a/kernel/ns_cgroup.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/cgroup.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 
 struct ns_cgroup {
 	struct cgroup_subsys_state css;
diff -puN kernel/rcutorture.c~kernel-explicitly-include-required-header-files-under-kernel kernel/rcutorture.c
--- a/kernel/rcutorture.c~kernel-explicitly-include-required-header-files-under-kernel
+++ a/kernel/rcutorture.c
@@ -45,6 +45,7 @@
 #include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
+#include <linux/slab.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
diff -puN kernel/res_counter.c~kernel-explicitly-include-required-header-files-under-kernel kernel/res_counter.c
--- a/kernel/res_counter.c~kernel-explicitly-include-required-header-files-under-kernel
+++ a/kernel/res_counter.c
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/parser.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 #include <linux/res_counter.h>
 #include <linux/uaccess.h>
 
diff -puN kernel/time.c~kernel-explicitly-include-required-header-files-under-kernel kernel/time.c
--- a/kernel/time.c~kernel-explicitly-include-required-header-files-under-kernel
+++ a/kernel/time.c
@@ -35,6 +35,7 @@
 #include <linux/syscalls.h>
 #include <linux/security.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff -puN kernel/user_namespace.c~kernel-explicitly-include-required-header-files-under-kernel kernel/user_namespace.c
--- a/kernel/user_namespace.c~kernel-explicitly-include-required-header-files-under-kernel
+++ a/kernel/user_namespace.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/nsproxy.h>
+#include <linux/slab.h>
 #include <linux/user_namespace.h>
 
 /*
diff -puN kernel/utsname.c~kernel-explicitly-include-required-header-files-under-kernel kernel/utsname.c
--- a/kernel/utsname.c~kernel-explicitly-include-required-header-files-under-kernel
+++ a/kernel/utsname.c
@@ -14,6 +14,7 @@
 #include <linux/utsname.h>
 #include <linux/version.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 
 /*
  * Clone a new ns copying an original utsname, setting refcount to 1
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

