From: akpm@linux-foundation.org
Subject: + git-x86-uml-fix-a-building-error.patch added to -mm tree
Date: Thu, 17 Jan 2008 10:57:30 -0800
Message-ID: <200801171857.m0HIvAl8007491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbYAQS5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 13:57:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com


The patch titled
     git-x86: uml: fix a building error
has been added to the -mm tree.  Its filename is
     git-x86-uml-fix-a-building-error.patch

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
Subject: git-x86: uml: fix a building error
From: WANG Cong <xiyou.wangcong@gmail.com>

This patch fixes this building error:
...
drivers/char/mem.c: In function `read_mem':
drivers/char/mem.c:136: error: implicit declaration of function `unxlate_dev_mem_ptr'
...

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/io.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-um/io.h~git-x86-uml-fix-a-building-error include/asm-um/io.h
--- a/include/asm-um/io.h~git-x86-uml-fix-a-building-error
+++ a/include/asm-um/io.h
@@ -27,6 +27,7 @@ static inline void * phys_to_virt(unsign
  * access
  */
 #define xlate_dev_mem_ptr(p)	__va(p)
+#define unxlate_dev_mem_ptr(p, ptr)
 
 /*
  * Convert a virtual cached pointer to an uncached pointer
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-kbuild.patch
git-net.patch
git-s390.patch
git-x86-unbreak-uml.patch
git-x86-uml-fix-a-building-error.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-const-and-other-tidying.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
