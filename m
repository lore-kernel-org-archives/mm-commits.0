From: akpm@linux-foundation.org
Subject: + fs-btrfs-inode-mapc-fix-warnings.patch added to -mm tree
Date: Fri, 20 Jan 2012 13:42:22 -0800
Message-ID: <20120120222450.085435C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:43314 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2ATWYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 17:24:52 -0500
Received: by wibhm11 with SMTP id hm11so49868wib.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 14:24:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, chris.mason@oracle.com, josef@redhat.com


The patch titled
     Subject: fs/btrfs/inode-map.c: fix warnings
has been added to the -mm tree.  Its filename is
     fs-btrfs-inode-mapc-fix-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/btrfs/inode-map.c: fix warnings

i386:

fs/btrfs/inode-map.c: In function 'btrfs_save_ino_cache':
fs/btrfs/inode-map.c:441: warning: cast from pointer to integer of different size
fs/btrfs/inode-map.c:503: warning: cast from pointer to integer of different size

Cc: Chris Mason <chris.mason@oracle.com>
Cc: Josef Bacik <josef@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/inode-map.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/btrfs/inode-map.c~fs-btrfs-inode-mapc-fix-warnings fs/btrfs/inode-map.c
--- a/fs/btrfs/inode-map.c~fs-btrfs-inode-mapc-fix-warnings
+++ a/fs/btrfs/inode-map.c
@@ -438,7 +438,7 @@ int btrfs_save_ino_cache(struct btrfs_ro
 					  trans->bytes_reserved);
 	if (ret)
 		goto out;
-	trace_btrfs_space_reservation(root->fs_info, "ino_cache", (u64)trans,
+	trace_btrfs_space_reservation(root->fs_info, "ino_cache", (long)trans,
 				      trans->bytes_reserved, 1);
 again:
 	inode = lookup_free_ino_inode(root, path);
@@ -500,7 +500,7 @@ again:
 out_put:
 	iput(inode);
 out_release:
-	trace_btrfs_space_reservation(root->fs_info, "ino_cache", (u64)trans,
+	trace_btrfs_space_reservation(root->fs_info, "ino_cache", (long)trans,
 				      trans->bytes_reserved, 0);
 	btrfs_block_rsv_release(root, trans->block_rsv, trans->bytes_reserved);
 out:
_
Subject: Subject: fs/btrfs/inode-map.c: fix warnings

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-warnings-regarding-enum-migrate_mode.patch
leds-add-led-driver-for-bachmanns-ot200-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

