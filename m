From: akpm@linux-foundation.org
Subject: [merged] documentation-volatile-considered-harmfultxt-correct-cpu_relax-documentation.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:35:58 -0400
Message-ID: <201003261936.o2QJav55016565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab0CZTh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk@arm.linux.org.uk, linux-arch@vger.kernel.org, rmk+kernel@arm.linux.org.uk, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Documentation/volatile-considered-harmful.txt: correct cpu_relax() documentation
has been removed from the -mm tree.  Its filename was
     documentation-volatile-considered-harmfultxt-correct-cpu_relax-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/volatile-considered-harmful.txt: correct cpu_relax() documentation
From: Russell King <rmk@arm.linux.org.uk>

cpu_relax() is documented in volatile-considered-harmful.txt to be a
memory barrier.  However, everyone with the exception of Blackfin and
possibly ia64 defines cpu_relax() to be a compiler barrier.

Make the documentation reflect the general concensus.

Linus sayeth:

: I don't think it was ever the intention that it would be seen as anything
: but a compiler barrier, although it is obviously implied that it might
: well perform some per-architecture actions that have "memory barrier-like"
: semantics.
: 
: After all, the whole and only point of the "cpu_relax()" thing is to tell
: the CPU that we're busy-looping on some event.
: 
: And that "event" might be (and often is) about reading the same memory
: location over and over until it changes to what we want it to be.  So it's
: quite possible that on various architectures the "cpu_relax()" could be
: about making sure that such a tight loop on loads doesn't starve cache
: transactions, for example - and as such look a bit like a memory barrier
: from a CPU standpoint.
: 
: But it's not meant to have any kind of architectural memory ordering
: semantics as far as the kernel is concerned - those must come from other
: sources.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: <linux-arch@vger.kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
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
arm-convert-proc-cpu-aligment-to-seq_file.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch

