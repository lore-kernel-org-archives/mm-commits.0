From: akpm@linux-foundation.org
Subject: + read_current_time-cleanups-build-fix.patch added to -mm tree
Date: Mon, 12 Nov 2007 17:14:27 -0800
Message-ID: <200711130114.lAD1ER2J019410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493AbXKMBPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 20:15:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ezk@cs.sunysb.edu


The patch titled
     init/calibrate.c compile error (MMOTM-2007-11-10-19-05)
has been added to the -mm tree.  Its filename is
     read_current_time-cleanups-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: init/calibrate.c compile error (MMOTM-2007-11-10-19-05)
From: Erez Zadok <ezk@cs.sunysb.edu>

I'm using -mm (MMOTM-2007-11-10-19-05) and getting

$ make
  CC      init/calibrate.o
In file included from include/linux/jiffies.h:8,
                 from init/calibrate.c:7:
include/linux/timex.h:246: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'read_current_timer'
init/calibrate.c: In function 'calibrate_delay_direct':
init/calibrate.c:41: error: implicit declaration of function 'read_current_timer'
make[1]: *** [init/calibrate.o] Error 1
make: *** [init] Error 2

That's because the definition of __devinit isn't known at that point.  The
following small patch appears to fix the compilation error.  Someone should
verify that it's the proper fix.

Cheers,
Erez.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/timex.h~read_current_time-cleanups-build-fix include/linux/timex.h
--- a/include/linux/timex.h~read_current_time-cleanups-build-fix
+++ a/include/linux/timex.h
@@ -55,6 +55,7 @@
 
 #include <linux/compiler.h>
 #include <linux/time.h>
+#include <linux/init.h>
 
 #include <asm/param.h>
 
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

hugetlb-follow_hugetlb_page-for-write-access-fix.patch
git-unionfs.patch
unionfs-clear-partial-read.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
read_current_time-cleanups-build-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch
