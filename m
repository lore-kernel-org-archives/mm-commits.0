From: akpm@linux-foundation.org
Subject: + clocksource-pass-clocksource-to-read-callback-sparc64-fix.patch added to -mm tree
Date: Thu, 18 Dec 2008 23:47:30 -0800
Message-ID: <200812190747.mBJ7lUSK031410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbYLSHrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Dec 2008 02:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, akpm@linux-foundation.org, davem@davemloft.net


The patch titled
     clocksource: pass clocksource to read() callback (sparc64 fix)
has been added to the -mm tree.  Its filename is
     clocksource-pass-clocksource-to-read-callback-sparc64-fix.patch

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
Subject: clocksource: pass clocksource to read() callback (sparc64 fix)
From: "Magnus Damm" <magnus.damm@gmail.com>

On Thu, Dec 18, 2008 at 10:56 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 11 Dec 2008 20:48:02 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> Pass clocksource pointer to the read() callback for clocksources.
>> This allows us to share the callback between multiple instances.
>
> sparc64 allmodconfig:
>
>
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  SYMLINK include/asm -> include/asm-sparc
>  CC      arch/sparc/kernel/asm-offsets.s
> In file included from include/linux/ktime.h:25,
>                 from include/linux/timer.h:5,
>                 from include/linux/clocksource.h:16,
>                 from /usr/src/devel/arch/sparc/include/asm/timer_64.h:11,
>                 from /usr/src/devel/arch/sparc/include/asm/timer.h:4,
>                 from /usr/src/devel/arch/sparc/include/asm/timex_64.h:9,
>                 from /usr/src/devel/arch/sparc/include/asm/timex.h:4,
>                 from include/linux/timex.h:170,
>                 from include/linux/sched.h:54,
>                 from arch/sparc/kernel/asm-offsets.c:13:
> include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
[lot's of warning snipped]

How about the (unfortunately most likely mangled) patch below? Does it
help? If not then i'll setup a cross compiler.

Dave, do you want me to rework the patch somehow?

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/timex_64.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc/include/asm/timex_64.h~clocksource-pass-clocksource-to-read-callback-sparc64-fix arch/sparc/include/asm/timex_64.h
--- a/arch/sparc/include/asm/timex_64.h~clocksource-pass-clocksource-to-read-callback-sparc64-fix
+++ a/arch/sparc/include/asm/timex_64.h
@@ -6,10 +6,10 @@
 #ifndef _ASMsparc64_TIMEX_H
 #define _ASMsparc64_TIMEX_H
 
-#include <asm/timer.h>
