From: akpm@linux-foundation.org
Subject: + ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match.patch added to -mm tree
Date: Wed, 15 Feb 2012 15:02:58 -0800
Message-ID: <20120215230258.EE281A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63863 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2BOXDA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 18:03:00 -0500
Received: by mail-ey0-f202.google.com with SMTP id f13so51688eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 15:02:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com, oleg@redhat.com, palves@redhat.com, tj@kernel.org


The patch titled
     Subject: ptrace: renumber PTRACE_EVENT_STOP so that future new options and events can match
has been added to the -mm tree.  Its filename is
     ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match.patch

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
Subject: ptrace: renumber PTRACE_EVENT_STOP so that future new options and events can match

PTRACE_EVENT_foo and PTRACE_O_TRACEfoo used to match.

New PTRACE_EVENT_STOP is the first event which has no corresponding
PTRACE_O_TRACE option.  If we will ever want to add another such option,
its PTRACE_EVENT's value will collide with PTRACE_EVENT_STOP's value.

This patch changes PTRACE_EVENT_STOP value to prevent this.

While at it, added a comment - the one atop PTRACE_EVENT block, saying
"Wait extended result codes for the above trace options", is not true for
PTRACE_EVENT_STOP.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/ptrace.h~ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match
+++ a/include/linux/ptrace.h
@@ -61,7 +61,8 @@
 #define PTRACE_EVENT_EXEC	4
 #define PTRACE_EVENT_VFORK_DONE	5
 #define PTRACE_EVENT_EXIT	6
-#define PTRACE_EVENT_STOP	7
+/* Extended result codes which enabled by means other than options.  */
+#define PTRACE_EVENT_STOP	128
 
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD	1
_
Subject: Subject: ptrace: renumber PTRACE_EVENT_STOP so that future new options and events can match

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

