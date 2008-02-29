From: akpm@linux-foundation.org
Subject: + fix-malformed-early-option-loglevel.patch added to -mm tree
Date: Thu, 28 Feb 2008 17:22:05 -0800
Message-ID: <200802290122.m1T1M5Db031122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYB2BW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raa.lkml@gmail.com, kmannth@gmail.com, rusty@rustcorp.com.au, yhlu.kernel@gmai.com


The patch titled
     Fix "Malformed early option 'loglevel'"
has been added to the -mm tree.  Its filename is
     fix-malformed-early-option-loglevel.patch

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
Subject: Fix "Malformed early option 'loglevel'"
From: Alex Riesen <raa.lkml@gmail.com>

Keith Mannthey said:

  The parameter hotadd_percent is setup right but there is a "Malformed
  early option 'numa'" message.

Rusty Russell said:

  This happens when the function registered with early_param() returns
  non-zero.  __setup() functions return 1 if OK, module_param() and
  early_param() return 0 or a -ve error code.

For instance:

Linux version 2.6.25-rc3-t (raa@steel) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #22 SMP PREEMPT Tue Feb 26
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Malformed early option 'loglevel'
127MB HIGHMEM available.
896MB LOWMEM available.

Command line:

BOOT_IMAGE=2.6.25-t ro root=809 ro console=ttyS0,57600n8 console=tty0 loglevel=5

Acked-by: Yinghai Lu <yhlu.kernel@gmai.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Keith Mannthey <kmannth@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~fix-malformed-early-option-loglevel init/main.c
--- a/init/main.c~fix-malformed-early-option-loglevel
+++ a/init/main.c
@@ -254,7 +254,7 @@ early_param("quiet", quiet_kernel);
 static int __init loglevel(char *str)
 {
 	get_option(&str, &console_loglevel);
-	return 1;
+	return 0;
 }
 
 early_param("loglevel", loglevel);
_

Patches currently in -mm which might be from raa.lkml@gmail.com are

fix-malformed-early-option-loglevel.patch

