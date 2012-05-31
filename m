From: akpm@linux-foundation.org
Subject: [merged] kbuild-install-kernel-page-flagsh.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:52 -0700
Message-ID: <20120531191452.595FBA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60314 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab2EaTOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:53 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so136095qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@akkadia.org, drepper@gmail.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: install kernel-page-flags.h
has been removed from the -mm tree.  Its filename was
     kbuild-install-kernel-page-flagsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ulrich Drepper <drepper@akkadia.org>
Subject: kbuild: install kernel-page-flags.h

Programs using /proc/kpageflags need to know about the various flags.  The
<linux/kernel-page-flags.h> provides them and the comments in the file
indicate that it is supposed to be used by user-level code.  But the file
is not installed.

Install the headers and mark the unstable flags as out-of-bounds.  The
page-type tool is also adjusted to not duplicate the definitions

Signed-off-by: Ulrich Drepper <drepper@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild              |    1 +
 include/linux/kernel-page-flags.h |    4 ++++
 tools/vm/page-types.c             |   28 +---------------------------
 3 files changed, 6 insertions(+), 27 deletions(-)

diff -puN include/linux/Kbuild~kbuild-install-kernel-page-flagsh include/linux/Kbuild
--- a/include/linux/Kbuild~kbuild-install-kernel-page-flagsh
+++ a/include/linux/Kbuild
@@ -225,6 +225,7 @@ header-y += kd.h
 header-y += kdev_t.h
 header-y += kernel.h
 header-y += kernelcapi.h
+header-y += kernel-page-flags.h
 header-y += keyboard.h
 header-y += keyctl.h
 header-y += l2tp.h
diff -puN include/linux/kernel-page-flags.h~kbuild-install-kernel-page-flagsh include/linux/kernel-page-flags.h
--- a/include/linux/kernel-page-flags.h~kbuild-install-kernel-page-flagsh
+++ a/include/linux/kernel-page-flags.h
@@ -32,6 +32,8 @@
 #define KPF_KSM			21
 #define KPF_THP			22
 
+#ifdef __KERNEL__
+
 /* kernel hacking assistances
  * WARNING: subject to change, never rely on them!
  */
@@ -44,4 +46,6 @@
 #define KPF_ARCH		38
 #define KPF_UNCACHED		39
 
+#endif /* __KERNEL__ */
+
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
diff -puN tools/vm/page-types.c~kbuild-install-kernel-page-flagsh tools/vm/page-types.c
--- a/tools/vm/page-types.c~kbuild-install-kernel-page-flagsh
+++ a/tools/vm/page-types.c
@@ -35,6 +35,7 @@
 #include <sys/mount.h>
 #include <sys/statfs.h>
 #include "../../include/linux/magic.h"
+#include "../../include/linux/kernel-page-flags.h"
 
 
 #ifndef MAX_PATH
@@ -73,33 +74,6 @@
 #define KPF_BYTES		8
 #define PROC_KPAGEFLAGS		"/proc/kpageflags"
 
-/* copied from kpageflags_read() */
-#define KPF_LOCKED		0
-#define KPF_ERROR		1
-#define KPF_REFERENCED		2
-#define KPF_UPTODATE		3
-#define KPF_DIRTY		4
-#define KPF_LRU			5
-#define KPF_ACTIVE		6
-#define KPF_SLAB		7
-#define KPF_WRITEBACK		8
-#define KPF_RECLAIM		9
-#define KPF_BUDDY		10
-
-/* [11-20] new additions in 2.6.31 */
-#define KPF_MMAP		11
-#define KPF_ANON		12
-#define KPF_SWAPCACHE		13
-#define KPF_SWAPBACKED		14
-#define KPF_COMPOUND_HEAD	15
-#define KPF_COMPOUND_TAIL	16
-#define KPF_HUGE		17
-#define KPF_UNEVICTABLE		18
-#define KPF_HWPOISON		19
-#define KPF_NOPAGE		20
-#define KPF_KSM			21
-#define KPF_THP			22
