From: akpm@linux-foundation.org
Subject: [merged] include-linux-crash_dumph-needs-elfh.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:30 -0800
Message-ID: <20120113203630.EC9FB10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63424 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: festevam@gmail.com, fabio.estevam@freescale.com, rmk@arm.linux.org.uk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/crash_dump.h needs elf.h
has been removed from the -mm tree.  Its filename was
     include-linux-crash_dumph-needs-elfh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Cc: <stable@vger.kernel.org>	[3.2.1]
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

Patches currently in -mm which might be from festevam@gmail.com are

origin.patch
linux-next.patch

