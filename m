From: akpm@linux-foundation.org
Subject: + brk-check-lower-bound-properly.patch added to -mm tree
Date: Sun, 01 Jun 2008 00:55:47 -0700
Message-ID: <200806010755.m517tl2F017404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYFAH4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 1 Jun 2008 03:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, geert@linux-m68k.org, stable@kernel.org


The patch titled
     brk: check lower bound properly
has been added to the -mm tree.  Its filename is
     brk-check-lower-bound-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: brk: check lower bound properly
From: Jiri Kosina <jkosina@suse.cz>

Fix a regression introduced by

commit 4cc6028d4040f95cdb590a87db478b42b8be0508
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Wed Feb 6 22:39:44 2008 +0100

    brk: check the lower bound properly

The check in sys_brk() on minimum value the brk might have must take
CONFIG_COMPAT_BRK setting into account.  When this option is turned on
(i.e.  we support ancient legacy binaries, e.g.  libc5-linked stuff), the
lower bound on brk value is mm->end_code, otherwise the brk start is
allowed to be arbitrarily shifted.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~brk-check-lower-bound-properly mm/mmap.c
--- a/mm/mmap.c~brk-check-lower-bound-properly
+++ a/mm/mmap.c
@@ -245,10 +245,16 @@ asmlinkage unsigned long sys_brk(unsigne
 	unsigned long rlim, retval;
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
+	unsigned long min_brk;
 
 	down_write(&mm->mmap_sem);
 
-	if (brk < mm->start_brk)
+#ifdef CONFIG_COMPAT_BRK
+	min_brk = mm->end_code;
+#else
+	min_brk = mm->start_brk;
+#endif
+	if (brk < min_brk)
 		goto out;
 
 	/*
_

Patches currently in -mm which might be from jkosina@suse.cz are

brk-check-lower-bound-properly.patch
linux-next.patch
usbhid-fix-fn-key-on-macbook-pro-41-and-macbook-air.patch
elantech-touchpad-driver.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch

