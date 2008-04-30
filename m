From: akpm@linux-foundation.org
Subject: - let-log_buf_shift-default-to-17.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:33 -0700
Message-ID: <200804300539.m3U5dXq6028858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199AbYD3FkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     let LOG_BUF_SHIFT default to 17
has been removed from the -mm tree.  Its filename was
     let-log_buf_shift-default-to-17.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: let LOG_BUF_SHIFT default to 17
From: Adrian Bunk <bunk@kernel.org>

16 kB is often no longer enough for a normal boot of an UP system.

And even less when people e.g. use suspend.

17 seems to be a more reasonable default for current kernels on current
hardware (it's just the default, anyone who is memory limited can still lower
it).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN init/Kconfig~let-log_buf_shift-default-to-17 init/Kconfig
--- a/init/Kconfig~let-log_buf_shift-default-to-17
+++ a/init/Kconfig
@@ -259,17 +259,14 @@ config IKCONFIG_PROC
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
 	range 12 21
-	default 17 if S390 || LOCKDEP
-	default 16 if X86_NUMAQ || IA64
-	default 15 if SMP
-	default 14
+	default 17
 	help
 	  Select kernel log buffer size as a power of 2.
-	  Defaults and Examples:
-	  	     17 => 128 KB for S/390
-		     16 => 64 KB for x86 NUMAQ or IA-64
-	             15 => 32 KB for SMP
-	             14 => 16 KB for uniprocessor
+	  Examples:
+	  	     17 => 128 KB
+		     16 => 64 KB
+	             15 => 32 KB
+	             14 => 16 KB
 		     13 =>  8 KB
 		     12 =>  4 KB
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

