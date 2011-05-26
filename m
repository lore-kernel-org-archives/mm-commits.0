From: akpm@linux-foundation.org
Subject: [folded] documentation-configfs-examples-crash-fix-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 26 May 2011 16:16:57 -0700
Message-ID: <201105262316.p4QNGwuq026338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1EZXR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:17:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     documentation-configfs-examples-crash-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     documentation-configfs-examples-crash-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into documentation-configfs-examples-crash-fix.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation-configfs-examples-crash-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: braces {} are not necessary for single statement blocks
#24: FILE: Documentation/filesystems/configfs/configfs_example_explicit.c:467:
+	for (i--; i >= 0; i--) {
 		configfs_unregister_subsystem(example_subsys[i]);
 	}

WARNING: braces {} are not necessary for single statement blocks
#36: FILE: Documentation/filesystems/configfs/configfs_example_macros.c:430:
+	for (i--; i >= 0; i--) {
 		configfs_unregister_subsystem(example_subsys[i]);
 	}

total: 0 errors, 2 warnings, 16 lines checked

./patches/documentation-configfs-examples-crash-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/configfs/configfs_example_explicit.c |    6 ++----
 Documentation/filesystems/configfs/configfs_example_macros.c   |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN Documentation/filesystems/configfs/configfs_example_explicit.c~documentation-configfs-examples-crash-fix-checkpatch-fixes Documentation/filesystems/configfs/configfs_example_explicit.c
--- a/Documentation/filesystems/configfs/configfs_example_explicit.c~documentation-configfs-examples-crash-fix-checkpatch-fixes
+++ a/Documentation/filesystems/configfs/configfs_example_explicit.c
@@ -464,9 +464,8 @@ static int __init configfs_example_init(
 	return 0;
 
 out_unregister:
-	for (i--; i >= 0; i--) {
+	for (i--; i >= 0; i--)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 
 	return ret;
 }
@@ -475,9 +474,8 @@ static void __exit configfs_example_exit
 {
 	int i;
 
-	for (i = 0; example_subsys[i]; i++) {
+	for (i = 0; example_subsys[i]; i++)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 }
 
 module_init(configfs_example_init);
diff -puN Documentation/filesystems/configfs/configfs_example_macros.c~documentation-configfs-examples-crash-fix-checkpatch-fixes Documentation/filesystems/configfs/configfs_example_macros.c
--- a/Documentation/filesystems/configfs/configfs_example_macros.c~documentation-configfs-examples-crash-fix-checkpatch-fixes
+++ a/Documentation/filesystems/configfs/configfs_example_macros.c
@@ -427,9 +427,8 @@ static int __init configfs_example_init(
 	return 0;
 
 out_unregister:
-	for (i--; i >= 0; i--) {
+	for (i--; i >= 0; i--)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 
 	return ret;
 }
@@ -438,9 +437,8 @@ static void __exit configfs_example_exit
 {
 	int i;
 
-	for (i = 0; example_subsys[i]; i++) {
+	for (i = 0; example_subsys[i]; i++)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 }
 
 module_init(configfs_example_init);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
include-linux-hugetlbh-needs-mm_typesh.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch
ufs-truncated-values-handling-64-bit-metadata.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch

