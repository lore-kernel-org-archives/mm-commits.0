From: akpm@linux-foundation.org
Subject: - read_current_time-cleanups-build-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:15:49 -0800
Message-ID: <200802060715.m167FU6o031283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758688AbYBFHPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:15:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     init/calibrate.c compile error (MMOTM-2007-11-10-19-05)
has been removed from the -mm tree.  Its filename was
     read_current_time-cleanups-build-fix.patch

This patch was dropped because it was folded into read_current_time-cleanups.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix.patch
read_current_time-cleanups-build-fix-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch
