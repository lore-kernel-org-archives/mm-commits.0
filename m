From: akpm@linux-foundation.org
Subject: + floppy-add-an-extra-bound-check-on-ioctl-arguments.patch added to -mm tree
Date: Tue, 13 Oct 2009 13:55:12 -0700
Message-ID: <200910132055.n9DKtCEi008669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934205AbZJMU4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 16:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com, mingo@elte.hu


The patch titled
     floppy: Add an extra bound check on ioctl arguments
has been added to the -mm tree.  Its filename is
     floppy-add-an-extra-bound-check-on-ioctl-arguments.patch

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
Subject: floppy: Add an extra bound check on ioctl arguments
From: Arjan van de Ven <arjan@infradead.org>

gcc is not convinced that the floppy.c ioctl has sufficient bound checks:

In function `copy_from_user',
    inlined from `fd_copyin' at drivers/block/floppy.c:3080,
    inlined from `fd_ioctl' at drivers/block/floppy.c:3503:
/home/arjan/linux/arch/x86/include/asm/uaccess_32.h:211:
warning: call to `copy_from_user_overflow' declared with attribute
warning: copy_from_user buffer size is not provably correct

And frankly, as a human I have a hard time proving the same more or less
(the size comes from the ioctl argument.  humpf.  maybe.  the code isn't
very nice)

This patch adds an explicit check to make 100% sure it's safe, better than
finding out later that there indeed was a gap.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

linux-next.patch
capabilities-simplify-bound-checks-for-copy_from_user.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch

