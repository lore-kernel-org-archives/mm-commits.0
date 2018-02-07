From: akpm@linux-foundation.org
Subject: [merged]
 locking-qrwlock-include-asm-byteorderh-as-needed.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 12:01:02 -0800
Message-ID: <20180207200102.XhBj8ziEI%akpm__25557.7094889761$1518033573$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754556AbeBGUBD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:01:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, arnd@arndb.de, babu.moger@amd.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, nico@linaro.org, peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de, will.deacon@arm.com, yamada.masahiro@socionext.com


The patch titled
     Subject: locking/qrwlock: include asm/byteorder.h as needed
has been removed from the -mm tree.  Its filename was
     locking-qrwlock-include-asm-byteorderh-as-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Babu Moger <babu.moger@amd.com>
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

kbuild-always-define-endianess-in-kconfigh.patch
bugh-work-around-gcc-pr82365-in-bug.patch

