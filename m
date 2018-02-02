From: akpm@linux-foundation.org
Subject: + locking-qrwlock-include-asm-byteorderh-as-needed.patch added to -mm tree
Date: Fri, 02 Feb 2018 11:48:56 -0800
Message-ID: <5a74c0a8.iSvPeUgt4chyTHhR%akpm__30798.5015715987$1517600854$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753065AbeBBTs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Feb 2018 14:48:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ak@linux.intel.com, babu.moger@oracle.com, gregkh@linuxfoundation.org, nico@linaro.org, peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de, will.deacon@arm.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: locking/qrwlock: include asm/byteorder.h as needed
has been added to the -mm tree.  Its filename is
     locking-qrwlock-include-asm-byteorderh-as-needed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/locking-qrwlock-include-asm-byteorderh-as-needed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/locking-qrwlock-include-asm-byteorderh-as-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: locking/qrwlock: include asm/byteorder.h as needed

Moving the qrwlock struct definition into a header file introduced a
subtle bug on all little-endian machines, where some files in some
configurations would see the fields in an incorrect order.  This was found
by building with an LTO enabled compiler that warns every time we try to
link together files with incompatible data structures.

A second patch changes linux/kconfig.h to always define the symbols, but
this seems to be the root cause of most of the issues, so I'd suggest we
do both.

On a current linux-next kernel, I verified that this header is responsible
for all type mismatches as a result from the endianess confusion.

Link: http://lkml.kernel.org/r/20180202154104.1522809-1-arnd@arndb.de
Fixes: e0d02285f16e ("locking/qrwlock: Use 'struct qrwlock' instead of 'struct __qrwlock'")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/qrwlock_types.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-generic/qrwlock_types.h~locking-qrwlock-include-asm-byteorderh-as-needed include/asm-generic/qrwlock_types.h
--- a/include/asm-generic/qrwlock_types.h~locking-qrwlock-include-asm-byteorderh-as-needed
+++ a/include/asm-generic/qrwlock_types.h
@@ -3,6 +3,7 @@
 #define __ASM_GENERIC_QRWLOCK_TYPES_H
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 #include <asm/spinlock_types.h>
 
 /*
_

Patches currently in -mm which might be from arnd@arndb.de are

locking-qrwlock-include-asm-byteorderh-as-needed.patch
kbuild-always-define-endianess-in-kconfigh.patch
kasan-added-functions-for-unpoisoning-stack-variables-fix-fix.patch
bugh-work-around-gcc-pr82365-in-bug.patch
bitmap-replace-bitmap_fromto_u32array-fix.patch
nilfs2-use-time64_t-internally.patch
pps-parport-use-timespec64-instead-of-timespec.patch
kasan-rework-kconfig-settings.patch

