From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-fix-very-long-mount-time-issue.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:05 -0800
Message-ID: <20130205202007.6CABF31C107__15269.057689193$1360095644$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:50231 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab3BEUUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:10 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so65235yen.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, konishi.ryusuke@lab.ntt.co.jp, splavgm@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix fix very long mount time issue
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-fix-very-long-mount-time-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: fix fix very long mount time issue

There exists a situation when GC can work in background alone without any
other filesystem activity during significant time.  The
nilfs_clean_segments() method calls nilfs_segctor_construct() that updates
superblocks in the case of NILFS_SC_SUPER_ROOT and THE_NILFS_DISCONTINUED
flags are set.  But when GC is working alone the nilfs_clean_segments() is
called with unset THE_NILFS_DISCONTINUED flag.  As a result, the update of
superblocks doesn't occurred all this time and in the case of SPOR
superblocks keep very old values of last super root placement.

SYMPTOMS:

Trying to mount a NILFS2 volume after SPOR in such environment ends with
very long mounting time (it can achieve about several hours in some
cases).

REPRODUCING PATH:

1. It needs to use external USB HDD, disable automount and doesn't
   make any additional filesystem activity on the NILFS2 volume.

2. Generate temporary file with size about 100 - 500 GB (for example,
   dd if=/dev/zero of=<file_name> bs=1073741824 count=200).  The size of
   file defines duration of GC working.

3. Then it needs to delete file.

4. Start GC manually by means of command "nilfs-clean -p 0".  When you
   start GC by means of such way then, at the end, superblocks is updated
   by once.  So, for simulation of SPOR, it needs to wait sometime (15 -
   40 minutes) and simply switch off USB HDD manually.

5. Switch on USB HDD again and try to mount NILFS2 volume.  As a
   result, NILFS2 volume will mount during very long time.

REPRODUCIBILITY: 100%

FIX:

This patch adds checking that superblocks need to update and set
THE_NILFS_DISCONTINUED flag before nilfs_clean_segments() call.

Reported-by: Sergey Alexandrov <splavgm@gmail.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/ioctl.c~nilfs2-fix-fix-very-long-mount-time-issue fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-fix-fix-very-long-mount-time-issue
+++ a/fs/nilfs2/ioctl.c
@@ -664,8 +664,11 @@ static int nilfs_ioctl_clean_segments(st
 	if (ret < 0)
 		printk(KERN_ERR "NILFS: GC failed during preparation: "
 			"cannot read source blocks: err=%d\n", ret);
-	else
+	else {
+		if (nilfs_sb_need_update(nilfs))
+			set_nilfs_discontinued(nilfs);
 		ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
+	}
 
 	nilfs_remove_all_gcinodes(nilfs);
 	clear_nilfs_gc_running(nilfs);
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

