From: akpm@linux-foundation.org
Subject: + fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch added to
 -mm tree
Date: Mon, 10 Apr 2017 15:34:28 -0700
Message-ID: <58ec0874.PNn0TVjvgSPMEbS5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752369AbdDJWe3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, arnd@arndb.de, clm@fb.com, dsterba@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: btrfs: use ktime_get_real_ts for root ctime
has been added to the -mm tree.  Its filename is
     fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: fs: btrfs: use ktime_get_real_ts for root ctime

btrfs_root_item maintains the ctime for root updates.  This is not part of
vfs_inode.

Since current_time() uses struct inode* as an argument as Linus suggested,
this cannot be used to update root times unless, we modify the signature
to use inode.

Since btrfs uses nanosecond time granularity, it can also use
ktime_get_real_ts directly to obtain timestamp for the root.  It is
necessary to use the timespec time api here because the same
btrfs_set_stack_timespec_*() apis are used for vfs inode times as well. 
These can be transitioned to using timespec64 when btrfs internally
changes to use timespec64 as well.

Link: http://lkml.kernel.org/r/1491613030-11599-8-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/root-tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/btrfs/root-tree.c~fs-btrfs-use-ktime_get_real_ts-for-root-ctime fs/btrfs/root-tree.c
--- a/fs/btrfs/root-tree.c~fs-btrfs-use-ktime_get_real_ts-for-root-ctime
+++ a/fs/btrfs/root-tree.c
@@ -501,8 +501,9 @@ void btrfs_update_root_times(struct btrf
 			     struct btrfs_root *root)
 {
 	struct btrfs_root_item *item = &root->root_item;
-	struct timespec ct = current_fs_time(root->fs_info->sb);
+	struct timespec ct;
 
+	ktime_get_real_ts(&ct);
 	spin_lock(&root->root_item_lock);
 	btrfs_set_root_ctransid(item, trans->transid);
 	btrfs_set_stack_timespec_sec(&item->ctime, ct.tv_sec);
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are

fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch
trace-make-trace_hwlat-timestamp-y2038-safe.patch
fs-cifs-replace-current_time-by-other-appropriate-apis.patch
fs-ceph-current_time-with-ktime_get_real_ts.patch
fs-ufs-use-ktime_get_real_ts64-for-birthtime.patch
audit-use-timespec64-to-represent-audit-timestamps.patch
fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch
fs-ubifs-replace-current_time_sec-with-current_time.patch
lustre-replace-current_time-macro.patch
apparmorfs-replace-current_time-with-current_time.patch
time-delete-current_time_sec-and-current_time.patch
time-delete-current_fs_time-function.patch

