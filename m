From: akpm@linux-foundation.org
Subject: [merged] floppy-add-an-extra-bound-check-on-ioctl-arguments.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:55 -0700
Message-ID: <200910092205.n99M5t6E022414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934706AbZJIWGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@infradead.org, arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     floppy: Add an extra bound check on ioctl arguments
has been removed from the -mm tree.  Its filename was
     floppy-add-an-extra-bound-check-on-ioctl-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: floppy: Add an extra bound check on ioctl arguments
From: Arjan van de Ven <arjan@infradead.org>

gcc is not convinced that the floppy.c ioctl has sufficient bound checks,
and frankly, as a human I have a hard time proving the same more or less
(the size comes from the ioctl argument.  humpf.  maybe.  the code isn't
very nice)

This patch adds an explicit check to make 100% sure it's safe, better than
finding out later that there indeed was a gap.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/block/floppy.c~floppy-add-an-extra-bound-check-on-ioctl-arguments drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-add-an-extra-bound-check-on-ioctl-arguments
+++ a/drivers/block/floppy.c
@@ -3497,6 +3497,9 @@ static int fd_ioctl(struct block_device 
 	    ((cmd & 0x80) && !capable(CAP_SYS_ADMIN)))
 		return -EPERM;
 
+	if (size < 0 || size > sizeof(inparam))
+		return -EINVAL;
+
 	/* copyin */
 	CLEARSTRUCT(&inparam);
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
_

Patches currently in -mm which might be from arjan@infradead.org are

origin.patch
linux-next.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch

