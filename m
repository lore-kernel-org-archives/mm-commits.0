From: akpm@linux-foundation.org
Subject: [merged] compiler-introduce-__aliassymbol-shortcut.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 12:17:45 -0800
Message-ID: <54e25069.osUZdfTFfmpWiR2X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbBPU1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:27:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler: introduce __alias(symbol) shortcut
has been removed from the -mm tree.  Its filename was
     compiler-introduce-__aliassymbol-shortcut.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: compiler: introduce __alias(symbol) shortcut

To be consistent with other compiler attributes introduce __alias(symbol)
macro expanding into __attribute__((alias(#symbol)))

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/compiler-gcc.h~compiler-introduce-__aliassymbol-shortcut include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-introduce-__aliassymbol-shortcut
+++ a/include/linux/compiler-gcc.h
@@ -66,6 +66,7 @@
 #define __deprecated			__attribute__((deprecated))
 #define __packed			__attribute__((packed))
 #define __weak				__attribute__((weak))
+#define __alias(symbol)		__attribute__((alias(#symbol)))
 
 /*
  * it doesn't make sense on ARM (currently the only user of __naked) to trace
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch

