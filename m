From: akpm@linux-foundation.org
Subject: + x86_64-fix-misplaced-continue-in-mcec.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:47:08 -0700
Message-ID: <200706231647.l5NGl5i9019469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518AbXFWQrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:47:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jwise@google.com, ak@suse.de, thockin@google.com


The patch titled
     x86_64: fix misplaced `continue' in mce.c
has been added to the -mm tree.  Its filename is
     x86_64-fix-misplaced-continue-in-mcec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: fix misplaced `continue' in mce.c
From: Joshua Wise <jwise@google.com>

Background:
  When a userspace application wants to know about machine check events, it
  opens /dev/mcelog and does a read(). Usually, we found that this interface
  works well, but in some cases, when the system was taking large numbers of
  machine check exceptions, the read() would hang. The system would output a
  soft-lockup warning, and the daemon reading from /dev/mcelog would suck up
  as much of a single CPU as it could spinning in system space.

Description:
  This patch fixes this bug. In particular, there was a "continue" inside a
  timeout loop that presumably was intended to break out of the outer loop,
  but instead caused the inner loop to continue. This patch also makes the
  condition for the break-out a little more evident by changing a
  !time_before to a time_after_eq.

Result:
  The read() no longer hangs in this test case.

Testing:
  On my system, I could replicate the bug with the following command:
    # for i in `seq 15000`; do ./inject_sbe.sh; done
  where inject_sbe.sh contains commands to inject a single-bit error into the
  next memory write transaction.

Patch:
  This patch is against git f1518a088bde6aea49e7c472ed6ab96178fcba3e.

Signed-off-by: Joshua Wise <jwise@google.com>
Signed-off-by: Tim Hockin <thockin@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/mce.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/mce.c~x86_64-fix-misplaced-continue-in-mcec arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~x86_64-fix-misplaced-continue-in-mcec
+++ a/arch/x86_64/kernel/mce.c
@@ -497,15 +497,17 @@ static ssize_t mce_read(struct file *fil
 	for (i = 0; i < next; i++) {		
 		unsigned long start = jiffies;
 		while (!mcelog.entry[i].finished) {
-			if (!time_before(jiffies, start + 2)) {
+			if (time_after_eq(jiffies, start + 2)) {
 				memset(mcelog.entry + i,0, sizeof(struct mce));
-				continue;
+				goto timeout;
 			}
 			cpu_relax();
 		}
 		smp_rmb();
 		err |= copy_to_user(buf, mcelog.entry + i, sizeof(struct mce));
 		buf += sizeof(struct mce); 
+	 timeout:
+	 	;
 	} 
 
 	memset(mcelog.entry, 0, next * sizeof(struct mce));
_

Patches currently in -mm which might be from jwise@google.com are

x86_64-fix-misplaced-continue-in-mcec.patch
x86_64-fix-misplaced-continue-in-mcec-tidy.patch
