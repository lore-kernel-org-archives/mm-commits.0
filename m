From: akpm@linux-foundation.org
Subject: [folded] readahead-introduce-fmode_random-for-posix_fadv_random-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:19:07 -0800
Message-ID: <201003052119.o25LJ7fj028179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab0CEVTJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:19:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, qbarnes+nfs@yahoo-inc.com, mm-commits@vger.kernel.org


The patch titled
     readahead-introduce-fmode_random-for-posix_fadv_random-fix
has been removed from the -mm tree.  Its filename was
     readahead-introduce-fmode_random-for-posix_fadv_random-fix.patch

This patch was dropped because it was folded into readahead-introduce-fmode_random-for-posix_fadv_random.patch

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

origin.patch
vmscan-check-high-watermark-after-shrink-zone.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch
readahead-introduce-fmode_random-for-posix_fadv_random.patch
readahead-introduce-fmode_random-for-posix_fadv_random-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch

