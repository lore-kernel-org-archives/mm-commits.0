From: akpm@linux-foundation.org
Subject: + include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch added to
 -mm tree
Date: Thu, 19 Nov 2015 16:25:56 -0800
Message-ID: <564e6894.Dh/8Q4kfUHDPPrAM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbbKTAZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 19:25:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, gang.chen.5i5j@gmail.com, xili_gchen_5257@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: include linux/pfn.h for PHYS_PFN definition
has been added to the -mm tree.  Its filename is
     include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch

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
Subject: mm: include linux/pfn.h for PHYS_PFN definition

A change to asm-generic/memory_model.h caused a new build error
in some configurations:

mach-clps711x/common.c:39:10: error: implicit declaration of function 'PHYS_PFN'
   .pfn  = __phys_to_pfn(CLPS711X_PHYS_BASE),

This includes the linux/pfn.h header from the same file to avoid the
error.

Fixes: bf1c6c9895de ("mm: add PHYS_PFN, use it in __phys_to_pfn()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chen Gang <xili_gchen_5257@hotmail.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-generic/memory_model.h~include-define-__phys_to_pfn-as-phys_pfn-fix-2 include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~include-define-__phys_to_pfn-as-phys_pfn-fix-2
+++ a/include/asm-generic/memory_model.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_MEMORY_MODEL_H
 #define __ASM_MEMORY_MODEL_H
 
+#include <linux/pfn.h>
+
 #ifndef __ASSEMBLY__
 
 #if defined(CONFIG_FLATMEM)
_

Patches currently in -mm which might be from arnd@arndb.de are

include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch

