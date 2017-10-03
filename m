From: akpm@linux-foundation.org
Subject: [patch 49/51] m32r: fix build failure
Date: Tue, 03 Oct 2017 16:16:49 -0700
Message-ID: <59d41a61.Qn7Jvhjtm5hNvSrz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58940 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXQu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com

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
