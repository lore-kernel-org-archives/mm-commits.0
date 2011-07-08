From: akpm@linux-foundation.org
Subject: + xtensa-prevent-arbitrary-read-in-ptrace.patch added to -mm tree
Date: Fri, 08 Jul 2011 11:28:12 -0700
Message-ID: <201107081828.p68ISED4006304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896Ab1GHS2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2011 14:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, chris@zankel.net, oleg@redhat.com, stable@kernel.org


The patch titled
     xtensa: prevent arbitrary read in ptrace
has been added to the -mm tree.  Its filename is
     xtensa-prevent-arbitrary-read-in-ptrace.patch

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
Subject: xtensa: prevent arbitrary read in ptrace
From: Dan Rosenberg <drosenberg@vsecurity.com>

Prevent an arbitrary kernel read.  Check the user pointer with access_ok()
before copying data in.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/ptrace.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/xtensa/kernel/ptrace.c~xtensa-prevent-arbitrary-read-in-ptrace arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~xtensa-prevent-arbitrary-read-in-ptrace
+++ a/arch/xtensa/kernel/ptrace.c
@@ -147,6 +147,9 @@ int ptrace_setxregs(struct task_struct *
 	elf_xtregs_t *xtregs = uregs;
 	int ret = 0;
 
+	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
+		return -EIO;
+
 #if XTENSA_HAVE_COPROCESSORS
 	/* Flush all coprocessors before we overwrite them. */
 	coprocessor_flush_all(ti);
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

xtensa-prevent-arbitrary-read-in-ptrace.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
drivers-scsi-pmcraid-reject-negative-request-size.patch

