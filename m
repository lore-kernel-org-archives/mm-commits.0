From: akpm@linux-foundation.org
Subject: - alpha-fix-epoll-syscall-enumerations.patch removed from -mm tree
Date: Mon, 05 Feb 2007 01:25:21 -0800
Message-ID: <200702050925.l159PL7L016438@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37338 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXBEJZe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 04:25:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix epoll syscall enumerations
has been removed from the -mm tree.  Its filename was
     alpha-fix-epoll-syscall-enumerations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alpha: fix epoll syscall enumerations
From: Mike Frysinger <vapier@gentoo.org>

We went and named them __NR_sys_foo instead of __NR_foo.

It may be too late to change this, but we can at least add the proper names
now.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/unistd.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN include/asm-alpha/unistd.h~alpha-fix-epoll-syscall-enumerations include/asm-alpha/unistd.h
--- a/include/asm-alpha/unistd.h~alpha-fix-epoll-syscall-enumerations
+++ a/include/asm-alpha/unistd.h
@@ -342,9 +342,14 @@
 #define __NR_io_cancel			402
 #define __NR_exit_group			405
 #define __NR_lookup_dcookie		406
-#define __NR_sys_epoll_create		407
-#define __NR_sys_epoll_ctl		408
-#define __NR_sys_epoll_wait		409
+#define __NR_epoll_create		407
+#define __NR_epoll_ctl			408
+#define __NR_epoll_wait			409
+/* Feb 2007: These three sys_epoll defines shouldn't be here but culling
+ * them would break userspace apps ... we'll kill them off in 2010 :) */
+#define __NR_sys_epoll_create		__NR_epoll_create
+#define __NR_sys_epoll_ctl		__NR_epoll_ctl
+#define __NR_sys_epoll_wait		__NR_epoll_wait
 #define __NR_remap_file_pages		410
 #define __NR_set_tid_address		411
 #define __NR_restart_syscall		412
_

Patches currently in -mm which might be from vapier@gentoo.org are

search-a-little-harder-for-mkimage.patch
new-toplevel-target-headers_check_all.patch
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
use-__u32-in-asm-x86_64-msrh.patch
some-rtc-documentation-updates.patch
