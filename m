From: akpm@linux-foundation.org
Subject: [merged] ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:09 -0700
Message-ID: <20120326193209.73320A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:47661 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab2CZTcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:10 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so831635ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, jan.kratochvil@redhat.com, oleg@redhat.com, palves@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: renumber PTRACE_EVENT_STOP so that future new options and events can match
has been removed from the -mm tree.  Its filename was
     ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
linux-next.patch

