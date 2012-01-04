From: akpm@linux-foundation.org
Subject: + include-linux-crash_dumph-needs-elfh.patch added to -mm tree
Date: Wed, 04 Jan 2012 12:31:24 -0800
Message-ID: <20120104203126.2F9A85C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:40632 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756827Ab2ADUb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2012 15:31:28 -0500
Received: by lagu2 with SMTP id u2so624804lag.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Jan 2012 12:31:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: festevam@gmail.com, fabio.estevam@freescale.com, rmk@arm.linux.org.uk


The patch titled
     Subject: include/linux/crash_dump.h needs elf.h
has been added to the -mm tree.  Its filename is
     include-linux-crash_dumph-needs-elfh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabio Estevam <festevam@gmail.com>
Subject: include/linux/crash_dump.h needs elf.h

Building an ARM target we get the following warnings:

CC      arch/arm/kernel/setup.o
In file included from arch/arm/kernel/setup.c:39:
arch/arm/include/asm/elf.h:102:1: warning: "vmcore_elf64_check_arch" redefined
In file included from arch/arm/kernel/setup.c:24:
include/linux/crash_dump.h:30:1: warning: this is the location of the previous definition

Quoting Russell King:

"linux/crash_dump.h makes no attempt to include asm/elf.h, but it depends
on stuff in asm/elf.h to determine how stuff inside this file is defined
at parse time.

So, if asm/elf.h is included after linux/crash_dump.h or not at all, you
get a different result from the situation where asm/elf.h is included
before."

So add elf.h header to crash_dump.h to avoid this problem.

The original discussion about this can be found at:
http://www.spinics.net/lists/arm-kernel/msg154113.html

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_dump.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/crash_dump.h~include-linux-crash_dumph-needs-elfh include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~include-linux-crash_dumph-needs-elfh
+++ a/include/linux/crash_dump.h
@@ -5,6 +5,7 @@
 #include <linux/kexec.h>
 #include <linux/device.h>
 #include <linux/proc_fs.h>
+#include <linux/elf.h>
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
_
Subject: Subject: include/linux/crash_dump.h needs elf.h

Patches currently in -mm which might be from festevam@gmail.com are

linux-next.patch
include-linux-crash_dumph-needs-elfh.patch

