From: akpm@linux-foundation.org
Subject: [merged] m32r-fix-build-failure.patch removed from -mm
 tree
Date: Wed, 04 Oct 2017 12:42:17 -0700
Message-ID: <20171004194217.dolPFvsyu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTmS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sudipm.mukherjee@gmail.com


The patch titled
     Subject: m32r: fix build failure
has been removed from the -mm tree.  Its filename was
     m32r-fix-build-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: fix build failure

The allmodconfig build of m32r is failing with the error:
lib/mpi/mpih-div.o: In function 'mpihelp_divrem':
mpih-div.c:(.text+0x40): undefined reference to 'abort'
mpih-div.c:(.text+0x40): relocation truncated to fit:
	R_M32R_26_PCREL_RELA against undefined symbol 'abort'

The function 'abort' was never defined for the m32r architecture.

Create 'abort' as is done in other arch like 'arm' and 'unicore32'.

Link: http://lkml.kernel.org/r/1506727220-6108-1-git-send-email-sudip.mukherjee@codethink.co.uk
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/traps.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN arch/m32r/kernel/traps.c~m32r-fix-build-failure arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~m32r-fix-build-failure
+++ a/arch/m32r/kernel/traps.c
@@ -114,6 +114,15 @@ static void set_eit_vector_entries(void)
 	_flush_cache_copyback_all();
 }
 
+void abort(void)
+{
+	BUG();
+
+	/* if that doesn't kill us, halt */
+	panic("Oops failed to kill thread");
+}
+EXPORT_SYMBOL(abort);
+
 void __init trap_init(void)
 {
 	set_eit_vector_entries();
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are


