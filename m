From: akpm@linux-foundation.org
Subject: [folded-merged]
 include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:19:20 -0800
Message-ID: <56981ee8.lSsoq2dI5GZKX/Rf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbcANWTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:19:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, gang.chen.5i5j@gmail.com, xili_gchen_5257@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: include linux/pfn.h for PHYS_PFN definition
has been removed from the -mm tree.  Its filename was
     include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch

This patch was dropped because it was folded into include-define-__phys_to_pfn-as-phys_pfn.patch

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

logfs-fix-logfs-build-errors-and-dependencies.patch
include-define-__phys_to_pfn-as-phys_pfn.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch

