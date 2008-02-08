From: akpm@linux-foundation.org
Subject: - kernel-cgroupc-remove-dead-code.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:40 -0800
Message-ID: <200802080802.m1882LO4014031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761670AbYBHIUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     kernel/cgroup.c: remove dead code
has been removed from the -mm tree.  Its filename was
     kernel-cgroupc-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/cgroup.c: remove dead code
From: Adrian Bunk <bunk@kernel.org>

This patch removes dead code spotted by the Coverity checker
(look at the "(nbytes >= PATH_MAX)" check).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN kernel/cgroup.c~kernel-cgroupc-remove-dead-code kernel/cgroup.c
--- a/kernel/cgroup.c~kernel-cgroupc-remove-dead-code
+++ a/kernel/cgroup.c
@@ -1355,16 +1355,14 @@ static ssize_t cgroup_common_file_write(
 		if (nbytes && (buffer[nbytes-1] == '\n')) {
 			buffer[nbytes-1] = 0;
 		}
-		if (nbytes < sizeof(root->release_agent_path)) {
-			/* We never write anything other than '\0'
-			 * into the last char of release_agent_path,
-			 * so it always remains a NUL-terminated
-			 * string */
-			strncpy(root->release_agent_path, buffer, nbytes);
-			root->release_agent_path[nbytes] = 0;
-		} else {
-			retval = -ENOSPC;
-		}
+
+		/* We never write anything other than '\0'
+		 * into the last char of release_agent_path,
+		 * so it always remains a NUL-terminated
+		 * string */
+		strncpy(root->release_agent_path, buffer, nbytes);
+		root->release_agent_path[nbytes] = 0;
+
 		break;
 	}
 	default:
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
