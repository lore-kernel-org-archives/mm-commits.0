From: akpm@linux-foundation.org
Subject: - add-better-resolution-to-initcall_debug-timings.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:23:30 -0700
Message-ID: <200810092223.m99MNUwQ005701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYJIWXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:23:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.bird@am.sony.com, mm-commits@vger.kernel.org


The patch titled
     Add better resolution to initcall_debug timings
has been removed from the -mm tree.  Its filename was
     add-better-resolution-to-initcall_debug-timings.patch

This patch was dropped because I dumped it on Ingo

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
@@ -733,9 +733,9 @@ int do_one_initcall(initcall_t fn)
 		t1 = ktime_get();
 		delta = ktime_sub(t1, t0);
 
-		printk("initcall %pF returned %d after %Ld msecs\n",
+		printk("initcall %pF returned %d after %Ld usecs\n",
 			fn, result,
-			(unsigned long long) delta.tv64 >> 20);
+			(unsigned long long) delta.tv64 >> 10);
 	}
 
 	msgbuf[0] = 0;
_

Patches currently in -mm which might be from tim.bird@am.sony.com are

git-tip.patch
add-better-resolution-to-initcall_debug-timings.patch

