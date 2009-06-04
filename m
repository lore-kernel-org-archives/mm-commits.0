From: akpm@linux-foundation.org
Subject: + drivers-char-memc-avoid-oom-lockup-during-large-reads-from-dev-zero.patch added to -mm tree
Date: Thu, 04 Jun 2009 13:53:04 -0700
Message-ID: <200906042053.n54Kr4sT025803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbZFDUxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 16:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sqazi@google.com, nickpiggin@yahoo.com.au, torvalds@linux-foundation.org


The patch titled
     drivers/char/mem.c: avoid OOM lockup during large reads from /dev/zero
has been added to the -mm tree.  Its filename is
     drivers-char-memc-avoid-oom-lockup-during-large-reads-from-dev-zero.patch

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
Subject: drivers/char/mem.c: avoid OOM lockup during large reads from /dev/zero
From: Salman Qazi <sqazi@google.com>

While running 20 parallel instances of dd as follows:

#!/bin/bash

for i in `seq 1 20`; do
         dd if=/dev/zero of=/export/hda3/dd_$i bs=1073741824 count=1 &
done
wait

on a 16G machine, we noticed that rather than just killing the processes,
the entire kernel went down.  Stracing dd reveals that it first does an
mmap2, which makes 1GB worth of zero page mappings.  Then it performs a
read on those pages from /dev/zero, and finally it performs a write.

The machine died during the reads.  Looking at the code, it was noticed
that /dev/zero's read operation had been changed by
557ed1fa2620dc119adb86b34c614e152a629a80 ("remove ZERO_PAGE") from giving
zero page mappings to actually zeroing the page.

The zeroing of the pages causes physical pages to be allocated to the
process.  But, when the process exhausts all the memory that it can, the
kernel cannot kill it, as it is still in the kernel mode allocating more
memory.  Consequently, the kernel eventually crashes.

To fix this, I propose that when a fatal signal is pending during
/dev/zero read operation, we simply return and let the user process die. 

Signed-off-by: Salman Qazi <sqazi@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/char/mem.c~drivers-char-memc-avoid-oom-lockup-during-large-reads-from-dev-zero drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-memc-avoid-oom-lockup-during-large-reads-from-dev-zero
+++ a/drivers/char/mem.c
@@ -696,6 +696,11 @@ static ssize_t read_zero(struct file * f
 			break;
 		buf += chunk;
 		count -= chunk;
+		/* The exit code here doesn't actually matter, as userland
+		 * will never see it.
+		 */
+		if (fatal_signal_pending(current))
+			return -ENOMEM;
 		cond_resched();
 	}
 	return written ? written : -EFAULT;
_

Patches currently in -mm which might be from sqazi@google.com are

drivers-char-memc-avoid-oom-lockup-during-large-reads-from-dev-zero.patch

