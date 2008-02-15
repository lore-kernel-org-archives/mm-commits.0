From: akpm@linux-foundation.org
Subject: - fix-module_update_markers-compile-error.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:00 -0500
Message-ID: <200802150719.m1F7JM4Q025702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762607AbYBOHUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, lethal@linux-sh.org, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     fix module_update_markers() compile error
has been removed from the -mm tree.  Its filename was
     fix-module_update_markers-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix module_update_markers() compile error
From: Adrian Bunk <bunk@kernel.org>

This patch fixes the following compile error with CONFIG_MODULES=n
caused by commit fb40bd78b0f91b274879cf5db8facd1e04b6052e:

/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/marker.c: In function `marker_update_probes':
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/marker.c:627: error: too few arguments to function `module_update_markers'

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/module.h~fix-module_update_markers-compile-error include/linux/module.h
--- a/include/linux/module.h~fix-module_update_markers-compile-error
+++ a/include/linux/module.h
@@ -567,8 +567,7 @@ static inline void print_modules(void)
 {
 }
 
-static inline void module_update_markers(struct module *probe_module,
-		int *refcount)
+static inline void module_update_markers(void)
 {
 }
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-net.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
sparc-fix-build.patch
reiser4.patch
