From: akpm@linux-foundation.org
Subject: + includecheck-fix-drivers-char-vtc.patch added to -mm tree
Date: Thu, 13 Aug 2009 15:03:45 -0700
Message-ID: <200908132203.n7DM3jhG005455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbZHMWFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 18:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com


The patch titled
     includecheck fix: drivers/char/vt.c
has been added to the -mm tree.  Its filename is
     includecheck-fix-drivers-char-vtc.patch

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
Subject: includecheck fix: drivers/char/vt.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following 'make includecheck' warning:

  drivers/char/vt.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/vt.c~includecheck-fix-drivers-char-vtc drivers/char/vt.c
--- a/drivers/char/vt.c~includecheck-fix-drivers-char-vtc
+++ a/drivers/char/vt.c
@@ -2957,7 +2957,6 @@ int __init vty_init(const struct file_op
 }
 
 #ifndef VT_SINGLE_DRIVER
-#include <linux/device.h>
 
 static struct class *vtconsole_class;
 
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch
net-cs89x0-includecheck-fix-for-cs89x0c.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-includecheck-fix-for-mm-nommuc.patch
includecheck-fix-drivers-char-vtc.patch

