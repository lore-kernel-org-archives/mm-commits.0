From: akpm@linux-foundation.org
Subject: + powerpc-mm-enable-page-parallel-initialisation.patch added to
 -mm tree
Date: Wed, 09 Mar 2016 13:42:10 -0800
Message-ID: <56e098b2./p3aDaPxRhdZQnxh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbcCIVmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 16:42:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhlcindy@linux.vnet.ibm.com, mgorman@techsingularity.net, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: Enable page parallel initialisation
has been added to the -mm tree.  Its filename is
     powerpc-mm-enable-page-parallel-initialisation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-enable-page-parallel-initialisation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-enable-page-parallel-initialisation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zhang <zhlcindy@linux.vnet.ibm.com>
Subject: powerpc/mm: Enable page parallel initialisation

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

mm-meminit-initialise-more-memory-for-inode-dentry-hash-tables-in-early-boot.patch
powerpc-mm-enable-page-parallel-initialisation.patch

