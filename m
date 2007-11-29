From: akpm@linux-foundation.org
Subject: + smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:43:05 -0800
Message-ID: <200711292343.lATNh56H013371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759895AbXK2XnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:43:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: casey@schaufler-ca.com, serue@us.ibm.com


The patch titled
     Update CAP_LAST_CAP to reflect CAP_MAC_ADMIN
has been added to the -mm tree.  Its filename is
     smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update CAP_LAST_CAP to reflect CAP_MAC_ADMIN
From: Casey Schaufler <casey@schaufler-ca.com>

Bump the value of CAP_LAST_CAP to reflect the current last cap value.
It appears that the patch that introduced CAP_LAST_CAP and the patch
that introduced CAP_MAC_ADMIN came in more or less at the same time.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/capability.h~smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin include/linux/capability.h
--- a/include/linux/capability.h~smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin
+++ a/include/linux/capability.h
@@ -315,10 +315,6 @@ typedef struct kernel_cap_struct {
 
 #define CAP_SETFCAP	     31
 
-#define CAP_LAST_CAP         CAP_SETFCAP
-
-#define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
-
 /* Override MAC access.
    The base kernel enforces no MAC policy.
    An LSM may enforce a MAC policy, and if it does and it chooses
@@ -336,6 +332,10 @@ typedef struct kernel_cap_struct {
 
 #define CAP_MAC_ADMIN        33
 
+#define CAP_LAST_CAP         CAP_MAC_ADMIN
+
+#define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
+
 /*
  * Bit location of each capability (used by user-space library and kernel)
  */
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
64bit-capability-support-legacy-support-fix.patch
capabilities-introduce-per-process-capability-bounding-set.patch
netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch
smack-version-11c-simplified-mandatory-access-control-kernel.patch
smack-using-capabilities-32-and-33.patch
smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch
