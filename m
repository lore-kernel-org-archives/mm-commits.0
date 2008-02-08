From: akpm@linux-foundation.org
Subject: - kernel-cgroupc-make-2-functions-static.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:48 -0800
Message-ID: <200802080802.m1882TJX014043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40170 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761670AbYBHITr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     kernel/cgroup.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     kernel-cgroupc-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/cgroup.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

cgroup_is_releasable() and notify_on_release() should be static,
not global inline.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~kernel-cgroupc-make-2-functions-static kernel/cgroup.c
--- a/kernel/cgroup.c~kernel-cgroupc-make-2-functions-static
+++ a/kernel/cgroup.c
@@ -141,7 +141,7 @@ enum {
 	ROOT_NOPREFIX, /* mounted subsystems have no named prefix */
 };
 
-inline int cgroup_is_releasable(const struct cgroup *cgrp)
+static int cgroup_is_releasable(const struct cgroup *cgrp)
 {
 	const int bits =
 		(1 << CGRP_RELEASABLE) |
@@ -149,7 +149,7 @@ inline int cgroup_is_releasable(const st
 	return (cgrp->flags & bits) == bits;
 }
 
-inline int notify_on_release(const struct cgroup *cgrp)
+static int notify_on_release(const struct cgroup *cgrp)
 {
 	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 }
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
