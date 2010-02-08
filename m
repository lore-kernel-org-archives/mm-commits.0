From: akpm@linux-foundation.org
Subject: + vfs-o_-bit-numbers-uniqueness-check.patch added to -mm tree
Date: Mon, 08 Feb 2010 14:56:07 -0800
Message-ID: <201002082256.o18Mu7UX008247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341Ab0BHW5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 17:57:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, davem@davemloft.net, eparis@redhat.com, hch@infradead.org, jamie@shareable.org, rdreier@cisco.com, schwab@linux-m68k.org, sfr@canb.auug.org.au, viro@zeniv.linux.org.uk


The patch titled
     vfs: O_* bit numbers uniqueness check
has been added to the -mm tree.  Its filename is
     vfs-o_-bit-numbers-uniqueness-check.patch

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
Subject: vfs: O_* bit numbers uniqueness check
From: Wu Fengguang <fengguang.wu@intel.com>

The O_* bit numbers are defined in 20+ arch/*, and can silently overlap. 
Add a compile time check to ensure the uniqueness as suggested by David
Miller.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c                  |   14 ++++++++++++--
 include/asm-generic/fcntl.h |    2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/fcntl.c~vfs-o_-bit-numbers-uniqueness-check fs/fcntl.c
--- a/fs/fcntl.c~vfs-o_-bit-numbers-uniqueness-check
+++ a/fs/fcntl.c
@@ -739,11 +739,21 @@ void kill_fasync(struct fasync_struct **
 }
 EXPORT_SYMBOL(kill_fasync);
 
-static int __init fasync_init(void)
+static int __init fcntl_init(void)
 {
+	/* please add new bits here to ensure allocation uniqueness */
+	BUILD_BUG_ON(17 != HWEIGHT32(
+		O_RDONLY	| O_WRONLY	| O_RDWR	|
+		O_CREAT		| O_EXCL	| O_NOCTTY	|
+		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
+		__O_SYNC	| O_DSYNC	| FASYNC	|
+		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
+		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC
+		));
+
 	fasync_cache = kmem_cache_create("fasync_cache",
 		sizeof(struct fasync_struct), 0, SLAB_PANIC, NULL);
 	return 0;
 }
 
-module_init(fasync_init)
+module_init(fcntl_init)
diff -puN include/asm-generic/fcntl.h~vfs-o_-bit-numbers-uniqueness-check include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~vfs-o_-bit-numbers-uniqueness-check
+++ a/include/asm-generic/fcntl.h
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 
 /*
+ * When introducing new O_* bits, please check its uniqueness in fcntl_init().
+ *
  * FMODE_EXEC is 0x20
  * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open
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
vfs-add-super-operation-writeback_inodes.patch
devmem-dont-allow-seek-to-last-page.patch

