From: akpm@linux-foundation.org
Subject: [alternative-merged] frv-fix-build-failure.patch removed from -mm tree
Date: Thu, 14 Dec 2017 14:56:28 -0800
Message-ID: <5a33019c.lUvr8k3hjwd34BgN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46670 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754069AbdLNW4a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 17:56:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: fix build failure
has been removed from the -mm tree.  Its filename was
     frv-fix-build-failure.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: frv: fix build failure

The frv defconfig build is failing with the error: lib/mpi/mpih-div.o: In
function `mpihelp_divrem': mpih-div.c:(.text+0x30c): undefined reference
to `abort'

The function 'abort' was never defined for the frv architecture.  Create
'abort' as is done in other arch like 'arm' and 'unicore32'.

Link: http://lkml.kernel.org/r/1511302233-5008-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/traps.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN arch/frv/kernel/traps.c~frv-fix-build-failure arch/frv/kernel/traps.c
--- a/arch/frv/kernel/traps.c~frv-fix-build-failure
+++ a/arch/frv/kernel/traps.c
@@ -633,6 +633,15 @@ void show_backtrace(struct pt_regs *fram
 
 } /* end show_backtrace() */
 
+void abort(void)
+{
+	BUG();
+
+	/* if that doesn't kill us, halt */
+	panic("Oops failed to kill thread");
+}
+EXPORT_SYMBOL(abort);
+
 /*****************************************************************************/
 /*
  * initialise traps
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

arch-define-weak-abort.patch

