From: akpm@linux-foundation.org
Subject: [merged] powerpc-mm-enable-page-parallel-initialisation.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:18 -0700
Message-ID: <56f04012.cZmeBhsR77Vulcij%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbcCUT4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhlcindy@linux.vnet.ibm.com, mgorman@techsingularity.net, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: enable page parallel initialisation
has been removed from the -mm tree.  Its filename was
     powerpc-mm-enable-page-parallel-initialisation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zhang <zhlcindy@linux.vnet.ibm.com>
Subject: powerpc/mm: enable page parallel initialisation

Parallel initialisation has been enabled for X86, boot time is
improved greatly. On Power8, it is improved greatly for small
memory. Here is the result from my test on Power8 platform:

For 4GB of memory, boot time is improved by 59%, from 24.5s to 10s.

For 50GB memory, boot time is improved by 22%, from 56.8s to 43.8s.

Signed-off-by: Li Zhang <zhlcindy@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/Kconfig~powerpc-mm-enable-page-parallel-initialisation arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-mm-enable-page-parallel-initialisation
+++ a/arch/powerpc/Kconfig
@@ -158,6 +158,7 @@ config PPC
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select HAVE_ARCH_SECCOMP_FILTER
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
_

Patches currently in -mm which might be from zhlcindy@linux.vnet.ibm.com are


