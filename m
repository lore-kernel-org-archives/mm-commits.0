From: akpm@linux-foundation.org
Subject: [alternative-merged] fanotify-fix-fmode_nonotify-bit-number.patch removed from -mm tree
Date: Tue, 09 Feb 2010 11:04:50 -0800
Message-ID: <201002091904.o19J4o1b028194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065Ab0BITF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 14:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, eparis@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fanotify: fix FMODE_NONOTIFY bit number
has been removed from the -mm tree.  Its filename was
     fanotify-fix-fmode_nonotify-bit-number.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fanotify: fix FMODE_NONOTIFY bit number
From: Wu Fengguang <fengguang.wu@intel.com>

FMODE_NONOTIFY=0x800000 collides with __O_SYNC in sparc, so change it to
0x1000000.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fcntl.h |    2 +-
 include/linux/fs.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/fcntl.h~fanotify-fix-fmode_nonotify-bit-number include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~fanotify-fix-fmode_nonotify-bit-number
+++ a/include/asm-generic/fcntl.h
@@ -5,7 +5,7 @@
 
 /*
  * FMODE_EXEC is 0x20
- * FMODE_NONOTIFY is 0x800000
+ * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open
  * flags are split.
  * -Eric Paris
diff -puN include/linux/fs.h~fanotify-fix-fmode_nonotify-bit-number include/linux/fs.h
--- a/include/linux/fs.h~fanotify-fix-fmode_nonotify-bit-number
+++ a/include/linux/fs.h
@@ -88,7 +88,7 @@ struct inodes_stat_t {
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
-#define FMODE_NONOTIFY		((__force fmode_t)8388608)
+#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
 /*
  * The below are the various read and write types that we support. Some of
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
fanotify-fix-fmode_nonotify-bit-number.patch
vfs-improve-writeback_inodes_wb.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch
readahead-introduce-fmode_random-for-posix_fadv_random.patch
readahead-introduce-fmode_random-for-posix_fadv_random-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
vfs-add-super-operation-writeback_inodes.patch

