From: akpm@linux-foundation.org
Subject: [patch 17/17] arch: define weak abort()
Date: Thu, 14 Dec 2017 15:33:19 -0800
Message-ID: <5a330a3f.VVzwoFCnvpRqT+I4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754425AbdLNXdU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, Alexey.Brodkin@synopsys.com, Vineet.Gupta1@synopsys.com

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: arch: define weak abort()

gcc toggle -fisolate-erroneous-paths-dereference (default at -O2 onwards)
isolates faulty code paths such as null pointer access, divide by zero
etc.  If gcc port doesnt implement __builtin_trap, an abort() is generated
which causes kernel link error.

In this case, gcc is generating abort due to 'divide by zero' in
lib/mpi/mpih-div.c.

Currently 'frv' and 'arc' are failing.  Previously other arch was also
broken like m32r was fixed by d22e3d69ee1a ("m32r: fix build failure").

Let's define this weak function which is common for all arch and fix the
problem permanently.  We can even remove the arch specific 'abort' after
this is done.

Link: http://lkml.kernel.org/r/1513118956-8718-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/exit.c~arch-define-weak-abort kernel/exit.c
--- a/kernel/exit.c~arch-define-weak-abort
+++ a/kernel/exit.c
@@ -1755,3 +1755,11 @@ Efault:
 	return -EFAULT;
 }
 #endif
+
+__weak void abort(void)
+{
+	BUG();
+
+	/* if that doesn't kill us, halt */
+	panic("Oops failed to kill thread");
+}
_
