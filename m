From: akpm@linux-foundation.org
Subject: + add-better-resolution-to-initcall_debug-timings.patch added to -mm tree
Date: Fri, 12 Sep 2008 16:37:52 -0700
Message-ID: <200809122337.m8CNbqIU010771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386AbYILXhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 19:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.bird@am.sony.com


The patch titled
     Add better resolution to initcall_debug timings
has been added to the -mm tree.  Its filename is
     add-better-resolution-to-initcall_debug-timings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add better resolution to initcall_debug timings
From: Tim Bird <tim.bird@am.sony.com>

Change the time resolution for initcall_debug to microseconds, from
milliseconds.  This is handy to determine which initcalls you want to work
on for faster booting.

One one of my test machines, over 90% of the initcalls are less than a
millisecond and (without this patch) these are all reported as 0 msecs. 
Working on the 900 us ones is more important than the 4 us ones.

With 'quiet' on the kernel command line, this adds no significant overhead
to kernel boot time.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/main.c~add-better-resolution-to-initcall_debug-timings init/main.c
--- a/init/main.c~add-better-resolution-to-initcall_debug-timings
+++ a/init/main.c
@@ -719,8 +719,8 @@ int do_one_initcall(initcall_t fn)
 		delta = ktime_sub(t1, t0);
 
 		print_fn_descriptor_symbol("initcall %s", fn);
-		printk(" returned %d after %Ld msecs\n", result,
-			(unsigned long long) delta.tv64 >> 20);
+		printk(" returned %d after %Ld usecs\n", result,
+			(unsigned long long) delta.tv64 >> 10);
 	}
 
 	msgbuf[0] = 0;
_

Patches currently in -mm which might be from tim.bird@am.sony.com are

linux-next.patch
add-better-resolution-to-initcall_debug-timings.patch

