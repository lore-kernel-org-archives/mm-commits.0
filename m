From: akpm@linux-foundation.org
Subject: [merged] xtensa-prevent-arbitrary-read-in-ptrace.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:07 -0700
Message-ID: <201107260751.p6Q7pA2n002928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab1GZHvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drosenberg@vsecurity.com, chris@zankel.net, oleg@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     xtensa: prevent arbitrary read in ptrace
has been removed from the -mm tree.  Its filename was
     xtensa-prevent-arbitrary-read-in-ptrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: prevent arbitrary read in ptrace
From: Dan Rosenberg <drosenberg@vsecurity.com>

Prevent an arbitrary kernel read.  Check the user pointer with access_ok()
before copying data in.

[akpm@linux-foundation.org: s/EIO/EFAULT/]
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
+		return -EFAULT;
+
 #if XTENSA_HAVE_COPROCESSORS
 	/* Flush all coprocessors before we overwrite them. */
 	coprocessor_flush_all(ti);
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

origin.patch
drivers-scsi-pmcraid-reject-negative-request-size.patch

