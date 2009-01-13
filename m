From: akpm@linux-foundation.org
Subject: + ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch added to -mm tree
Date: Tue, 13 Jan 2009 15:19:02 -0800
Message-ID: <200901132319.n0DNJ2Ah010162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868AbZAMXTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 18:19:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jack@suse.cz, pavel@suse.cz


The patch titled
     ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix
has been added to the -mm tree.  Its filename is
     ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch

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
Subject: ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix
From: Andrew Morton <akpm@linux-foundation.org>

still sync the data page

Cc: Jan Kara <jack@suse.cz>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/ext2/dir.c~ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix
+++ a/fs/ext2/dir.c
@@ -94,10 +94,14 @@ static int ext2_commit_chunk(struct page
 		i_size_write(dir, pos+len);
 		mark_inode_dirty(dir);
 	}
-	unlock_page(page);
 
-	if (IS_DIRSYNC(dir))
-		err = ext2_sync_inode(dir);
+	if (IS_DIRSYNC(dir)) {
+		err = write_one_page(page, 1);
+		if (err == 0)
+			err = ext2_sync_inode(dir);
+	} else {
+		unlock_page(page);
+	}
 
 	return err;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-fix-vmalloc-breakage-fix.patch
hp_accel-do-not-call-acpi-from-invalid-context-fix.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
rtc-cumulative-style-fixes-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

