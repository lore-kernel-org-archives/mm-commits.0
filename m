From: akpm@linux-foundation.org
Subject: [merged] tmpfs-fix-use-after-free-of-mempolicy-object.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:53 -0800
Message-ID: <20130225205554.013025A426D__16475.7985542112$1361825784$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:37539 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759370Ab3BYUzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:55 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so70872qea.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hughd@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: fix use-after-free of mempolicy object
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-use-after-free-of-mempolicy-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: tmpfs: fix use-after-free of mempolicy object

The tmpfs remount logic preserves filesystem mempolicy if the mpol=M
option is not specified in the remount request.  A new policy can be
specified if mpol=M is given.

Before this patch remounting an mpol bound tmpfs without specifying mpol=
mount option in the remount request would set the filesystem's mempolicy
object to a freed mempolicy object.

To reproduce the problem boot a DEBUG_PAGEALLOC kernel and run:
    # mkdir /tmp/x

    # mount -t tmpfs -o size=100M,mpol=interleave nodev /tmp/x

    # grep /tmp/x /proc/mounts
    nodev /tmp/x tmpfs rw,relatime,size=102400k,mpol=interleave:0-3 0 0

    # mount -o remount,size=200M nodev /tmp/x

    # grep /tmp/x /proc/mounts
    nodev /tmp/x tmpfs rw,relatime,size=204800k,mpol=??? 0 0
        # note ? garbage in mpol=... output above

    # dd if=/dev/zero of=/tmp/x/f count=1
        # panic here

Panic:
    BUG: unable to handle kernel NULL pointer dereference at           (null)
    IP: [<          (null)>]           (null)
    [...]
    Oops: 0010 [#1] SMP DEBUG_PAGEALLOC
    Call Trace:
     [<ffffffff81186ead>] ? mpol_set_nodemask+0x8d/0x100
     [<ffffffff811895ef>] ? mpol_shared_policy_init+0x8f/0x160
     [<ffffffff81189605>] mpol_shared_policy_init+0xa5/0x160
     [<ffffffff811580e1>] ? shmem_get_inode+0x1e1/0x270
     [<ffffffff811580e1>] ? shmem_get_inode+0x1e1/0x270
     [<ffffffff810db15d>] ? trace_hardirqs_on+0xd/0x10
     [<ffffffff81158109>] shmem_get_inode+0x209/0x270
     [<ffffffff811581ae>] shmem_mknod+0x3e/0xf0
     [<ffffffff811582b8>] shmem_create+0x18/0x20
     [<ffffffff811af5d5>] vfs_create+0xb5/0x130
     [<ffffffff811afff1>] do_last+0x9a1/0xea0
     [<ffffffff811ac77a>] ? link_path_walk+0x7a/0x930
     [<ffffffff811b05a3>] path_openat+0xb3/0x4d0
     [<ffffffff811be831>] ? __alloc_fd+0x31/0x160
     [<ffffffff811b0de2>] do_filp_open+0x42/0xa0
     [<ffffffff811be8e0>] ? __alloc_fd+0xe0/0x160
     [<ffffffff811a066e>] do_sys_open+0xfe/0x1e0
     [<ffffffff811f0aeb>] compat_sys_open+0x1b/0x20
     [<ffffffff815d6055>] cstar_dispatch+0x7/0x1f

Non-debug kernels will not crash immediately because referencing the
dangling mpol will not cause a fault.  Instead the filesystem will
reference a freed mempolicy object, which will cause unpredictable
behavior.

The problem boils down to a dropped mpol reference below if
shmem_parse_options() does not allocate a new mpol:
    config = *sbinfo
    shmem_parse_options(data, &config, true)
    mpol_put(sbinfo->mpol)
    sbinfo->mpol = config.mpol  /* BUG: saves unreferenced mpol */

This patch avoids the crash by not releasing the mempolicy if
shmem_parse_options() doesn't create a new mpol.

How far back does this issue go?  I see it in both 2.6.36 and 3.3.  I did
not look back further.

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-use-after-free-of-mempolicy-object mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-use-after-free-of-mempolicy-object
+++ a/mm/shmem.c
@@ -2486,6 +2486,7 @@ static int shmem_remount_fs(struct super
 	unsigned long inodes;
 	int error = -EINVAL;
 
+	config.mpol = NULL;
 	if (shmem_parse_options(data, &config, true))
 		return error;
 
@@ -2510,8 +2511,13 @@ static int shmem_remount_fs(struct super
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
 
-	mpol_put(sbinfo->mpol);
-	sbinfo->mpol        = config.mpol;	/* transfers initial ref */
+	/*
+	 * Preserve previous mempolicy unless mpol remount option was specified.
+	 */
+	if (config.mpol) {
+		mpol_put(sbinfo->mpol);
+		sbinfo->mpol = config.mpol;	/* transfers initial ref */
+	}
 out:
 	spin_unlock(&sbinfo->stat_lock);
 	return error;
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch

