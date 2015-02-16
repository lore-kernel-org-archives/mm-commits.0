From: akpm@linux-foundation.org
Subject: [merged] kernel-add-support-for-init_array-constructors.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:18:34 -0800
Message-ID: <54e2509a.GqxsUa4Dmk5rEfIR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbBPUTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: add support for .init_array.* constructors
has been removed from the -mm tree.  Its filename was
     kernel-add-support-for-init_array-constructors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kernel: add support for .init_array.* constructors

KASan uses constructors for initializing redzones for global variables. 
Globals instrumentation in GCC 4.9.2 produces constructors with priority
(.init_array.00099)

Currently kernel ignores such constructors.  Only constructors with
default priority supported (.init_array)

This patch adds support for constructors with priorities.  For kernel
image we put pointers to constructors between __ctors_start/__ctors_end
and do_ctors() will call them on start up.  For modules we merge
.init_array.* sections into resulting .init_array.  Module code properly
handles constructors in .init_array section.

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

 include/asm-generic/vmlinux.lds.h |    1 +
 scripts/module-common.lds         |    3 +++
 2 files changed, 4 insertions(+)

diff -puN include/asm-generic/vmlinux.lds.h~kernel-add-support-for-init_array-constructors include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~kernel-add-support-for-init_array-constructors
+++ a/include/asm-generic/vmlinux.lds.h
@@ -478,6 +478,7 @@
 #define KERNEL_CTORS()	. = ALIGN(8);			   \
 			VMLINUX_SYMBOL(__ctors_start) = .; \
 			*(.ctors)			   \
+			*(SORT(.init_array.*))		   \
 			*(.init_array)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
diff -puN scripts/module-common.lds~kernel-add-support-for-init_array-constructors scripts/module-common.lds
--- a/scripts/module-common.lds~kernel-add-support-for-init_array-constructors
+++ a/scripts/module-common.lds
@@ -16,4 +16,7 @@ SECTIONS {
 	__kcrctab_unused	0 : { *(SORT(___kcrctab_unused+*)) }
 	__kcrctab_unused_gpl	0 : { *(SORT(___kcrctab_unused_gpl+*)) }
 	__kcrctab_gpl_future	0 : { *(SORT(___kcrctab_gpl_future+*)) }
+
+	. = ALIGN(8);
+	.init_array		0 : { *(SORT(.init_array.*)) *(.init_array) }
 }
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch

