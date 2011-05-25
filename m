From: akpm@linux-foundation.org
Subject: + ufs-truncated-values-handling-64-bit-metadata-fix.patch added to -mm tree
Date: Wed, 25 May 2011 16:24:58 -0700
Message-ID: <201105260001.p4Q01hed026018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741Ab1EZACR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 20:02:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dushistov@mail.ru, error27@gmail.com


The patch titled
     ufs-truncated-values-handling-64-bit-metadata-fix
has been added to the -mm tree.  Its filename is
     ufs-truncated-values-handling-64-bit-metadata-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-video-mb862xx-mb862xx-i2cc-needs-delayh.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
ufs-truncated-values-handling-64-bit-metadata-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

