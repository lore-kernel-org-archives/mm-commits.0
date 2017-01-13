From: akpm@linux-foundation.org
Subject: + dax-enable-iostat-for-read-write-fix.patch added to -mm tree
Date: Fri, 13 Jan 2017 14:54:25 -0800
Message-ID: <58795aa1.96SOyQOqsq8e5vME%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48796 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdAMWyb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 17:54:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, david@fromorbit.com, joe@perches.com, ross.zwisler@linux.intel.com, toshi.kani@hpe.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-enable-iostat-for-read-write-fix
has been added to the -mm tree.  Its filename is
     dax-enable-iostat-for-read-write-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-enable-iostat-for-read-write-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-enable-iostat-for-read-write-fix.patch

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
Subject: dax-enable-iostat-for-read-write-fix

make do_acct a bool

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joe Perches <joe@perches.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-enable-iostat-for-read-write-fix fs/dax.c
--- a/fs/dax.c~dax-enable-iostat-for-read-write-fix
+++ a/fs/dax.c
@@ -1085,7 +1085,7 @@ dax_iomap_rw(struct kiocb *iocb, struct
 	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
 	unsigned flags = 0;
 	unsigned long start = 0;
-	int do_acct = blk_queue_io_stat(disk->queue);
+	bool do_acct = blk_queue_io_stat(disk->queue);
 
 	if (iov_iter_rw(iter) == WRITE)
 		flags |= IOMAP_WRITE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

