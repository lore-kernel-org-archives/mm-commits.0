From: akpm@linux-foundation.org
Subject: + panic-call-console_verbose-in-panic.patch added to -mm tree
Date: Wed, 12 May 2010 16:39:13 -0700
Message-ID: <201005122339.o4CNdDCV027813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147Ab0ELXj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 19:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, gregkh@suse.de, mingo@elte.hu


The patch titled
     panic: call console_verbose() in panic
has been added to the -mm tree.  Its filename is
     panic-call-console_verbose-in-panic.patch

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
Subject: panic: call console_verbose() in panic
From: Anton Blanchard <anton@samba.org>

Most distros turn the console verbosity down and that means a backtrace
after a panic never makes it to the console.  I assume we haven't seen
this because a panic is often preceeded by an oops which will have called
console_verbose.  There are however a lot of places we call panic
directly, and they are broken.

Use console_verbose like we do in the oops path to ensure a directly
called panic will print a backtrace.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/panic.c~panic-call-console_verbose-in-panic kernel/panic.c
--- a/kernel/panic.c~panic-call-console_verbose-in-panic
+++ a/kernel/panic.c
@@ -87,6 +87,7 @@ NORET_TYPE void panic(const char * fmt, 
 	 */
 	preempt_disable();
 
+	console_verbose();
 	bust_spinlocks(1);
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
_

Patches currently in -mm which might be from anton@samba.org are

linux-next.patch
panic-call-console_verbose-in-panic.patch

