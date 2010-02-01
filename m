From: akpm@linux-foundation.org
Subject: + fanotify-fix-fmode_nonotify-bit-number.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:45:04 -0800
Message-ID: <201002012045.o11Kj4QQ011368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224Ab0BAUpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:45:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, eparis@redhat.com


The patch titled
     fanotify: fix FMODE_NONOTIFY bit number
has been added to the -mm tree.  Its filename is
     fanotify-fix-fmode_nonotify-bit-number.patch

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
devmem-check-vmalloc-address-on-kmem-read-write.patch
devmem-fix-kmem-write-bug-on-memory-holes.patch
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
resources-introduce-generic-page_is_ram.patch
resources-introduce-generic-page_is_ram-fix.patch
resources-introduce-generic-page_is_ram-fix-2.patch
x86-remove-bios-data-range-from-e820.patch
x86-use-the-generic-page_is_ram.patch

