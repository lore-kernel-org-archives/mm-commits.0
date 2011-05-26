From: akpm@linux-foundation.org
Subject: [folded] ufs-truncated-values-handling-64-bit-metadata-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:16:27 -0700
Message-ID: <201105262316.p4QNGSwl026324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757352Ab1EZXRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:17:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dushistov@mail.ru, error27@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ufs-truncated-values-handling-64-bit-metadata-fix
has been removed from the -mm tree.  Its filename was
     ufs-truncated-values-handling-64-bit-metadata-fix.patch

This patch was dropped because it was folded into ufs-truncated-values-handling-64-bit-metadata.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs-truncated-values-handling-64-bit-metadata-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove now-unneeded min_t/max_t casting

Cc: Dan Carpenter <error27@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-truncated-values-handling-64-bit-metadata-fix fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-truncated-values-handling-64-bit-metadata-fix
+++ a/fs/ufs/balloc.c
@@ -424,8 +424,7 @@ u64 ufs_new_fragments(struct inode *inod
 			ufs_cpu_to_data_ptr(sb, p, result);
 			*err = 0;
 			UFS_I(inode)->i_lastfrag =
-				max_t(u64, UFS_I(inode)->i_lastfrag,
-				      fragment + count);
+				max(UFS_I(inode)->i_lastfrag, fragment + count);
 			ufs_clear_frags(inode, result + oldcount,
 					newcount - oldcount, locked_page != NULL);
 		}
@@ -440,7 +439,8 @@ u64 ufs_new_fragments(struct inode *inod
 	result = ufs_add_fragments (inode, tmp, oldcount, newcount, err);
 	if (result) {
 		*err = 0;
-		UFS_I(inode)->i_lastfrag = max_t(u64, UFS_I(inode)->i_lastfrag, fragment + count);
+		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
+						fragment + count);
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
 		unlock_super(sb);
@@ -479,7 +479,8 @@ u64 ufs_new_fragments(struct inode *inod
 				   uspi->s_sbbase + result, locked_page);
 		ufs_cpu_to_data_ptr(sb, p, result);
 		*err = 0;
-		UFS_I(inode)->i_lastfrag = max_t(u64, UFS_I(inode)->i_lastfrag, fragment + count);
+		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
+						fragment + count);
 		unlock_super(sb);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
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
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch

