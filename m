From: akpm@linux-foundation.org
Subject: + readahead-introduce-fmode_random-for-posix_fadv_random-fix.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:13:59 -0800
Message-ID: <201002012013.o11KDxBr009710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756063Ab0BAUOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:14:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, qbarnes+nfs@yahoo-inc.com


The patch titled
     readahead-introduce-fmode_random-for-posix_fadv_random-fix
has been added to the -mm tree.  Its filename is
     readahead-introduce-fmode_random-for-posix_fadv_random-fix.patch

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
Subject: readahead-introduce-fmode_random-for-posix_fadv_random-fix
From: Wu Fengguang <fengguang.wu@intel.com>

This fixes a nasty bug of the patch, reported by Quentin Barnes.

Cc: <qbarnes+nfs@yahoo-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/fadvise.c~readahead-introduce-fmode_random-for-posix_fadv_random-fix mm/fadvise.c
--- a/mm/fadvise.c~readahead-introduce-fmode_random-for-posix_fadv_random-fix
+++ a/mm/fadvise.c
@@ -78,18 +78,18 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
 		spin_lock(&file->f_lock);
-		file->f_flags &= ~FMODE_RANDOM;
+		file->f_mode &= ~FMODE_RANDOM;
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
 		spin_lock(&file->f_lock);
-		file->f_flags |= FMODE_RANDOM;
+		file->f_mode |= FMODE_RANDOM;
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_SEQUENTIAL:
 		file->f_ra.ra_pages = bdi->ra_pages * 2;
 		spin_lock(&file->f_lock);
-		file->f_flags &= ~FMODE_RANDOM;
+		file->f_mode &= ~FMODE_RANDOM;
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
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

