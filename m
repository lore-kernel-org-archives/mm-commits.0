From: akpm@linux-foundation.org
Subject: [patch 033/119] mm: relax deferred struct page
 requirements
Date: Wed, 31 Jan 2018 16:16:02 -0800
Message-ID: <20180201001602.XbYZ2t8Lt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAQF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:16:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, benh@kernel.crashing.org, daniel.m.jordan@oracle.com, heiko.carstens@de.ibm.com, khalid.aziz@oracle.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, pasha.tatashin@oracle.com, paulus@samba.org, schwidefsky@de.ibm.com, steven.sistare@oracle.com, tglx@linutronix.de, torvalds@linux-foundation.org

From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: relax deferred struct page requirements

There is no need to have ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT, as all
the page initialization code is in common code.

Also, there is no need to depend on MEMORY_HOTPLUG, as initialization code
does not really use hotplug memory functionality.  So, we can remove this
requirement as well.

This patch allows to use deferred struct page initialization on all
platforms with memblock allocator.

Tested on x86, arm64, and sparc.  Also, verified that code compiles on PPC
with CONFIG_MEMORY_HOTPLUG disabled.

Link: http://lkml.kernel.org/r/20171117014601.31606-1-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>	[s390]
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 -
 arch/s390/Kconfig    |    1 -
 arch/x86/Kconfig     |    1 -
 mm/Kconfig           |    7 +------
 4 files changed, 1 insertion(+), 9 deletions(-)

diff -puN arch/powerpc/Kconfig~mm-relax-deferred-struct-page-requirements arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~mm-relax-deferred-struct-page-requirements
+++ a/arch/powerpc/Kconfig
@@ -151,7 +151,6 @@ config PPC
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_SUPPORTS_ATOMIC_RMW
-	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
 	select ARCH_WANT_IPC_PARSE_VERSION
diff -puN arch/s390/Kconfig~mm-relax-deferred-struct-page-requirements arch/s390/Kconfig
--- a/arch/s390/Kconfig~mm-relax-deferred-struct-page-requirements
+++ a/arch/s390/Kconfig
@@ -108,7 +108,6 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
 	select ARCH_SUPPORTS_ATOMIC_RMW
-	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
diff -puN arch/x86/Kconfig~mm-relax-deferred-struct-page-requirements arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-relax-deferred-struct-page-requirements
+++ a/arch/x86/Kconfig
@@ -69,7 +69,6 @@ config X86
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_SUPPORTS_ATOMIC_RMW
-	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_QUEUED_RWLOCKS
diff -puN mm/Kconfig~mm-relax-deferred-struct-page-requirements mm/Kconfig
--- a/mm/Kconfig~mm-relax-deferred-struct-page-requirements
+++ a/mm/Kconfig
@@ -639,15 +639,10 @@ config MAX_STACK_SIZE_MB
 
 	  A sane initial value is 80 MB.
 
-# For architectures that support deferred memory initialisation
-config ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
-	bool
