From: akpm@linux-foundation.org
Subject: + x86_64-support-poll-on-dev-mcelog-fix.patch added to -mm tree
Date: Wed, 23 May 2007 11:28:41 -0700
Message-ID: <200705231828.l4NISeo6029146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbXEWS2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:28:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wli@holomorphy.com, ak@suse.de, bill.irwin@oracle.com, thockin@google.com


The patch titled
     x86_64-support-poll-on-dev-mcelog fix
has been added to the -mm tree.  Its filename is
     x86_64-support-poll-on-dev-mcelog-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64-support-poll-on-dev-mcelog fix
From: William Lee Irwin III <wli@holomorphy.com>

The build fails with the following error when CONFIG_X86_MCE is not set:
arch/x86_64/kernel/built-in.o: In function `do_notify_resume':
/mnt/g/mm-2.6.22-rc2/arch/x86_64/kernel/signal.c:478: undefined reference to `mce_notify_user'
The following patch #ifdef's the offending call as a minimal fix.

Signed-off-by: William Irwin <bill.irwin@oracle.com>
Cc: Tim Hockin <thockin@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/signal.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86_64/kernel/signal.c~x86_64-support-poll-on-dev-mcelog-fix arch/x86_64/kernel/signal.c
--- a/arch/x86_64/kernel/signal.c~x86_64-support-poll-on-dev-mcelog-fix
+++ a/arch/x86_64/kernel/signal.c
@@ -473,9 +473,11 @@ do_notify_resume(struct pt_regs *regs, v
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
+#ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
 		mce_notify_user();
+#endif /* CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK))
_

Patches currently in -mm which might be from wli@holomorphy.com are

quicklist-support-for-x86_64.patch
x86_64-support-poll-on-dev-mcelog-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
