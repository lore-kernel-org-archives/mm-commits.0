From: akpm@linux-foundation.org
Subject: + m32r-fix-build-failure.patch added to -mm tree
Date: Mon, 02 Oct 2017 14:01:12 -0700
Message-ID: <59d2a918.6j6jLxKBhYTluLJU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdJBVBN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 17:01:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix build failure
has been added to the -mm tree.  Its filename is
     m32r-fix-build-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-fix-build-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-fix-build-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

alpha-fix-build-failures.patch
m32r-define-cpu_big_endian.patch
m32r-fix-build-failure.patch

