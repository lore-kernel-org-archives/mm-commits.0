From: akpm@linux-foundation.org
Subject: + ptrace-remove-ptrace_seize_devel-bit.patch added to -mm tree
Date: Wed, 15 Feb 2012 15:03:01 -0800
Message-ID: <20120215230301.8BA2FA016A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43779 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab2BOXDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 18:03:04 -0500
Received: by bkcjk13 with SMTP id jk13so67455bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 15:03:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com, oleg@redhat.com, palves@redhat.com, tj@kernel.org


The patch titled
     Subject: ptrace: remove PTRACE_SEIZE_DEVEL bit
has been added to the -mm tree.  Its filename is
     ptrace-remove-ptrace_seize_devel-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: ptrace: remove PTRACE_SEIZE_DEVEL bit

Patches currently in -mm which might be from vda.linux@googlemail.com are

linux-next.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
ptrace-the-killed-tracee-should-not-enter-the-syscall.patch
ptrace-dont-send-sigtrap-on-exec-if-seized.patch
ptrace-dont-modify-flags-on-ptrace_setoptions-failure.patch
ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code.patch
ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter.patch
ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match.patch
ptrace-remove-ptrace_seize_devel-bit.patch

