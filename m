From: akpm@linux-foundation.org
Subject: + uml-fix-initrd-printk.patch added to -mm tree
Date: Tue, 12 Feb 2008 12:05:40 -0800
Message-ID: <200802122005.m1CK5eLv019795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbYBLUGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 15:06:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johfel@users.sourceforge.net, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: fix initrd printk
has been added to the -mm tree.  Its filename is
     uml-fix-initrd-printk.patch

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
Subject: uml: fix initrd printk
From: Johann Felix Soden <johfel@users.sourceforge.net>

If the initrd file has zero-length, the error message should contain
the filepath.

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/initrd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/initrd.c~uml-fix-initrd-printk arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~uml-fix-initrd-printk
+++ a/arch/um/kernel/initrd.c
@@ -32,7 +32,7 @@ static int __init read_initrd(void)
 	 * ask for no memory.
 	 */
 	if (size == 0) {
-		printk(KERN_ERR "\"%\" is a zero-size initrd\n");
+		printk(KERN_ERR "\"%s\" is a zero-size initrd\n", initrd);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from johfel@users.sourceforge.net are

origin.patch
rtc-remove-unused-var-in-drivers-rtc-rtc-r9701o.patch
uml-fix-initrd-printk.patch
uml-fix-helper_wait-calls-in-watchdog.patch
