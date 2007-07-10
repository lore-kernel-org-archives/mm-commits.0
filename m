From: akpm@linux-foundation.org
Subject: - fallocate-on-ia64.patch removed from -mm tree
Date: Tue, 10 Jul 2007 02:14:40 -0700
Message-ID: <200707100914.l6A9EeSc021010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54086 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757278AbXGJJQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 05:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dgc@sgi.com, mark.fasheh@oracle.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     fallocate() on ia64
has been removed from the -mm tree.  Its filename was
     fallocate-on-ia64.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fallocate() on ia64
From: David Chinner <dgc@sgi.com>

ia64 fallocate syscall support.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/entry.S  |    1 +
 include/asm-ia64/unistd.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/ia64/kernel/entry.S~fallocate-on-ia64 arch/ia64/kernel/entry.S
--- a/arch/ia64/kernel/entry.S~fallocate-on-ia64
+++ a/arch/ia64/kernel/entry.S
@@ -1588,5 +1588,6 @@ sys_call_table:
 	data8 sys_signalfd
 	data8 sys_timerfd
 	data8 sys_eventfd
+	data8 sys_fallocate			// 1310
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
diff -puN include/asm-ia64/unistd.h~fallocate-on-ia64 include/asm-ia64/unistd.h
--- a/include/asm-ia64/unistd.h~fallocate-on-ia64
+++ a/include/asm-ia64/unistd.h
@@ -299,6 +299,7 @@
 #define __NR_signalfd			1307
 #define __NR_timerfd			1308
 #define __NR_eventfd			1309
+#define __NR_fallocate			1310
 
 #ifdef __KERNEL__
 
_

Patches currently in -mm which might be from dgc@sgi.com are

git-xfs.patch
fix-xfs_ioc_fsgeometry_v1-in-compat-mode.patch
fix-xfs_ioc__to_handle-and-xfs_ioc_openreadlink_by_handle-in-compat-mode.patch
fix-xfs_ioc_fsbulkstat_single-and-xfs_ioc_fsinumbers-in-compat-mode.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
introduce-i_sync.patch
fallocate-on-ia64.patch
fallocate-on-ia64-fix.patch
