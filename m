From: akpm@linux-foundation.org
Subject: + documentation-volatile-considered-harmfultxt-correct-cpu_relax-documentation.patch added to -mm tree
Date: Thu, 18 Mar 2010 14:41:42 -0700
Message-ID: <201003182141.o2ILfgB0017286__11646.0378667854$1268948549$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab0CRVmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 17:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk@arm.linux.org.uk, linux-arch@vger.kernel.org, rmk+kernel@arm.linux.org.uk, torvalds@linux-foundation.org


The patch titled
     Documentation/volatile-considered-harmful.txt: correct cpu_relax() documentation
has been added to the -mm tree.  Its filename is
     documentation-volatile-considered-harmfultxt-correct-cpu_relax-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/volatile-considered-harmful.txt: correct cpu_relax() documentation
From: Russell King <rmk@arm.linux.org.uk>

cpu_relax() is documented in volatile-considered-harmful.txt to be a
memory barrier.  However, everyone with the exception of Blackfin and
possibly ia64 defines cpu_relax() to be a compiler barrier.

Make the documentation reflect the general concensus.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: <linux-arch@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/volatile-considered-harmful.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/volatile-considered-harmful.txt~documentation-volatile-considered-harmfultxt-correct-cpu_relax-documentation Documentation/volatile-considered-harmful.txt
--- a/Documentation/volatile-considered-harmful.txt~documentation-volatile-considered-harmfultxt-correct-cpu_relax-documentation
+++ a/Documentation/volatile-considered-harmful.txt
@@ -63,9 +63,9 @@ way to perform a busy wait is:
         cpu_relax();
 
 The cpu_relax() call can lower CPU power consumption or yield to a
-hyperthreaded twin processor; it also happens to serve as a memory barrier,
-so, once again, volatile is unnecessary.  Of course, busy-waiting is
-generally an anti-social act to begin with.
+hyperthreaded twin processor; it also happens to serve as a compiler
+barrier, so, once again, volatile is unnecessary.  Of course, busy-
+waiting is generally an anti-social act to begin with.
 
 There are still a few rare situations where volatile makes sense in the
 kernel:
_

Patches currently in -mm which might be from rmk@arm.linux.org.uk are

origin.patch
documentation-volatile-considered-harmfultxt-correct-cpu_relax-documentation.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch

