From: akpm@linux-foundation.org
Subject: + arch-um-kernel-initrdc-fix-a-missed-conversion-specifier.patch added to -mm tree
Date: Thu, 14 Feb 2008 22:37:13 -0800
Message-ID: <200802150637.m1F6bDnR024022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755571AbYBOGh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 01:37:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@karaya.com


The patch titled
     arch/um/kernel/initrd.c: fix a missed conversion specifier
has been added to the -mm tree.  Its filename is
     arch-um-kernel-initrdc-fix-a-missed-conversion-specifier.patch

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
Subject: arch/um/kernel/initrd.c: fix a missed conversion specifier
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix a missed conversion specifier of a printk in arch/um/kernel/initrd.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Jeff Dike <jdike@karaya.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/initrd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/initrd.c~arch-um-kernel-initrdc-fix-a-missed-conversion-specifier arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~arch-um-kernel-initrdc-fix-a-missed-conversion-specifier
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

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

arch-um-kernel-initrdc-fix-a-missed-conversion-specifier.patch
uml-fix-initrd-printk.patch
