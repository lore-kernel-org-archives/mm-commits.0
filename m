From: akpm@linux-foundation.org
Subject: [folded-merged]
 arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4.patch removed from -mm tree
Date: Fri, 15 Jan 2016 16:30:26 -0800
Message-ID: <56998f22.ua/Oak3YNLBwrxLT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbcAPAa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:30:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, gang.chen.5i5j@gmail.com, minchan@kernel.org, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/*/include/uapi/asm/mman.h: correct uniform value of MADV_FREE
has been removed from the -mm tree.  Its filename was
     arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4.patch

This patch was dropped because it was folded into arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: arch/*/include/uapi/asm/mman.h: correct uniform value of MADV_FREE

commit d53d95838c7d introduced uniform values for all architecture but
missed removing the old value.

As a result we are having build failure with mips defconfig, alpha
defconfig.

Fixes: d53d95838c7d ("arch/*/include/uapi/asm/mman.h: : let MADV_FREE have same value for all architectures")
Cc: Minchan Kim <minchan@kernel.org>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/uapi/asm/mman.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/parisc/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4 arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -43,7 +43,6 @@
 #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
 #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
 #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
-#define MADV_FREE	8		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_FREE	8		/* free pages only if memory pressure */
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch

