From: akpm@linux-foundation.org
Subject: + missing-include-file-in-kallsymsh.patch added to -mm tree
Date: Thu, 01 Nov 2007 10:36:14 -0700
Message-ID: <200711011736.lA1HaEf2007614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229AbXKARg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 13:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com


The patch titled
     Missing include file in kallsyms.h
has been added to the -mm tree.  Its filename is
     missing-include-file-in-kallsymsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Missing include file in kallsyms.h
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

The Build with randconfig fails with following error with the
2.6.24-rc4-git9

include/linux/kallsyms.h:56: error: `NULL' undeclared (first use in this
function)
include/linux/kallsyms.h:56: error: (Each undeclared identifier is
reported only once
include/linux/kallsyms.h:56: error: for each function it appears in.)
make[2]: *** [arch/powerpc/platforms/cell/spu_callbacks.o] Error 1
make[1]: *** [arch/powerpc/platforms/cell] Error 2
make: *** [arch/powerpc/platforms] Error 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/kallsyms.h~missing-include-file-in-kallsymsh include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~missing-include-file-in-kallsymsh
+++ a/include/linux/kallsyms.h
@@ -6,6 +6,7 @@
 #define _LINUX_KALLSYMS_H
 
 #include <linux/errno.h>
+#include <linux/stddef.h>
 
 #define KSYM_NAME_LEN 128
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

missing-include-file-in-kallsymsh.patch
