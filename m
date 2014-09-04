From: akpm@linux-foundation.org
Subject: + kern-sys-compat-sysinfo-syscall-fix-undefined-behavior.patch
 added to -mm tree
Date: Thu, 04 Sep 2014 13:14:45 -0700
Message-ID: <5408c835.MWm76hvPzVVO+Bu9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaIDUOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2014 16:14:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sbauer@eng.utah.edu, clemens@ladisch.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: compat sysinfo syscall: fix undefined behavior
has been added to the -mm tree.  Its filename is
     kern-sys-compat-sysinfo-syscall-fix-undefined-behavior.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kern-sys-compat-sysinfo-syscall-fix-undefined-behavior.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kern-sys-compat-sysinfo-syscall-fix-undefined-behavior.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Scotty Bauer <sbauer@eng.utah.edu>
Subject: kernel/sys.c: compat sysinfo syscall: fix undefined behavior

Fix undefined behavior and compiler warning by replacing right shift 32
with upper_32_bits macro

Signed-off-by: Scotty Bauer <sbauer@eng.utah.edu>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~kern-sys-compat-sysinfo-syscall-fix-undefined-behavior kernel/sys.c
--- a/kernel/sys.c~kern-sys-compat-sysinfo-syscall-fix-undefined-behavior
+++ a/kernel/sys.c
@@ -2330,7 +2330,7 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct c
 	/* Check to see if any memory value is too large for 32-bit and scale
 	 *  down if needed
 	 */
-	if ((s.totalram >> 32) || (s.totalswap >> 32)) {
+	if (upper_32_bits(s.totalram) || upper_32_bits(s.totalswap)) {
 		int bitcount = 0;
 
 		while (s.mem_unit < PAGE_SIZE) {
_

Patches currently in -mm which might be from sbauer@eng.utah.edu are

kern-sys-compat-sysinfo-syscall-fix-undefined-behavior.patch

