From: akpm@linux-foundation.org
Subject: [merged] ptrace-remove-ptrace_seize_devel-bit.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:11 -0700
Message-ID: <20120326193211.743C2A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61185 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab2CZTcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:16 -0400
Received: by eekc41 with SMTP id c41so293986eek.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, jan.kratochvil@redhat.com, oleg@redhat.com, palves@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: remove PTRACE_SEIZE_DEVEL bit
has been removed from the -mm tree.  Its filename was
     ptrace-remove-ptrace_seize_devel-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: ptrace: remove PTRACE_SEIZE_DEVEL bit

PTRACE_SEIZE code is tested and ready for production use, remove the code
which requires special bit in data argument to make PTRACE_SEIZE work.

Strace team prepares for a new release of strace, and we would like to
ship the code which uses PTRACE_SEIZE, preferably after this change goes
into released kernel.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    5 +----
 kernel/ptrace.c        |   15 ---------------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-remove-ptrace_seize_devel-bit include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-remove-ptrace_seize_devel-bit
+++ a/include/linux/ptrace.h
@@ -51,9 +51,6 @@
 #define PTRACE_INTERRUPT	0x4207
 #define PTRACE_LISTEN		0x4208
 
-/* flags in @data for PTRACE_SEIZE */
-#define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
-
 /* Wait extended result codes for the above trace options.  */
 #define PTRACE_EVENT_FORK	1
 #define PTRACE_EVENT_VFORK	2
@@ -64,7 +61,7 @@
 /* Extended result codes which enabled by means other than options.  */
 #define PTRACE_EVENT_STOP	128
 
-/* options set using PTRACE_SETOPTIONS */
+/* Options set using PTRACE_SETOPTIONS or using PTRACE_SEIZE @data param */
 #define PTRACE_O_TRACESYSGOOD	1
 #define PTRACE_O_TRACEFORK	(1 << PTRACE_EVENT_FORK)
 #define PTRACE_O_TRACEVFORK	(1 << PTRACE_EVENT_VFORK)
diff -puN kernel/ptrace.c~ptrace-remove-ptrace_seize_devel-bit kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-remove-ptrace_seize_devel-bit
+++ a/kernel/ptrace.c
@@ -237,25 +237,10 @@ static int ptrace_attach(struct task_str
 	bool seize = (request == PTRACE_SEIZE);
 	int retval;
 
-	/*
-	 * SEIZE will enable new ptrace behaviors which will be implemented
-	 * gradually.  SEIZE_DEVEL bit is used to prevent applications
-	 * expecting full SEIZE behaviors trapping on kernel commits which
-	 * are still in the process of implementing them.
-	 *
-	 * Only test programs for new ptrace behaviors being implemented
-	 * should set SEIZE_DEVEL.  If unset, SEIZE will fail with -EIO.
-	 *
-	 * Once SEIZE behaviors are completely implemented, this flag
-	 * will be removed.
-	 */
 	retval = -EIO;
 	if (seize) {
 		if (addr != 0)
 			goto out;
-		if (!(flags & PTRACE_SEIZE_DEVEL))
-			goto out;
-		flags &= ~(unsigned long)PTRACE_SEIZE_DEVEL;
 		if (flags & ~(unsigned long)PTRACE_O_MASK)
 			goto out;
 		flags = PT_PTRACED | PT_SEIZED | (flags << PT_OPT_FLAG_SHIFT);
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
linux-next.patch

