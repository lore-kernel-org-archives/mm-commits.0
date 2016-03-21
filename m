From: akpm@linux-foundation.org
Subject: [merged]
 lib-bug-make-panic_on_warn-available-for-all-architectures.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:41:28 -0700
Message-ID: <56f04058.19mElFRGp2fcreWM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbcCUTlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, deller@gmx.de, jejb@parisc-linux.org, mpe@ellerman.id.au, paulus@samba.org, prarit@redhat.com, schwidefsky@de.ibm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bug.c: make panic_on_warn available for all architectures
has been removed from the -mm tree.  Its filename was
     lib-bug-make-panic_on_warn-available-for-all-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: lib/bug.c: make panic_on_warn available for all architectures

Christian Borntraeger reported that panic_on_warn doesn't have any effect
on s390.

The panic_on_warn feature was introduced with 9e3961a09798 ("kernel: add
panic_on_warn").  However it did care only for the case when
WANT_WARN_ON_SLOWPATH is defined.  This is turn is only the case for
architectures which do not have an own __WARN_TAINT defined.

Other architectures which do have __WARN_TAINT defined call report_bug()
for warnings within lib/bug.c which does not call panic() in case
panic_on_warn is set.

Let's simply enable the panic_on_warn feature by adding the same code like
it was added to warn_slowpath_common() in panic.c.

This enables panic_on_warn also for arm64, parisc, powerpc, s390 and sh.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Tested-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN lib/bug.c~lib-bug-make-panic_on_warn-available-for-all-architectures lib/bug.c
--- a/lib/bug.c~lib-bug-make-panic_on_warn-available-for-all-architectures
+++ a/lib/bug.c
@@ -175,6 +175,17 @@ enum bug_trap_type report_bug(unsigned l
 			pr_warn("WARNING: at %p [verbose debug info unavailable]\n",
 				(void *)bugaddr);
 
+		if (panic_on_warn) {
+			/*
+			 * This thread may hit another WARN() in the panic path.
+			 * Resetting this prevents additional WARN() from
+			 * panicking the system on this thread.  Other threads
+			 * are blocked by the panic_mutex in panic().
+			 */
+			panic_on_warn = 0;
+			panic("panic_on_warn set ...\n");
+		}
+
 		print_modules();
 		show_regs(regs);
 		print_oops_end_marker();
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are


