From: akpm@linux-foundation.org
Subject: + printk-check-con_enabled-in-have_callable_console.patch added
 to -mm tree
Date: Fri, 12 Feb 2016 15:10:36 -0800
Message-ID: <56be666c.+SFB7PcTU3sNUiOc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbcBLXKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Feb 2016 18:10:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, calvinowens@fb.com, davej@codemonkey.org.uk, jack@suse.com, kyle@kernel.org, pmladek@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: check CON_ENABLED in have_callable_console()
has been added to the -mm tree.  Its filename is
     printk-check-con_enabled-in-have_callable_console.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-check-con_enabled-in-have_callable_console.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-check-con_enabled-in-have_callable_console.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: printk: check CON_ENABLED in have_callable_console()

have_callable_console() must also test CON_ENABLED bit, not just
CON_ANYTIME.  We may have disabled CON_ANYTIME console so printk can
wrongly assume that it's safe to call_console_drivers().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Jan Kara <jack@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@kernel.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Calvin Owens <calvinowens@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-check-con_enabled-in-have_callable_console kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-check-con_enabled-in-have_callable_console
+++ a/kernel/printk/printk.c
@@ -2139,7 +2139,8 @@ static int have_callable_console(void)
 	struct console *con;
 
 	for_each_console(con)
-		if (con->flags & CON_ANYTIME)
+		if ((con->flags & CON_ENABLED) &&
+				(con->flags & CON_ANYTIME))
 			return 1;
 
 	return 0;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

mm-workingset-per-cgroup-cache-thrash-detection-fix.patch
zram-export-the-number-of-available-comp-streams.patch
printk-move-can_use_console-out-of-console_trylock_for_printk.patch
printk-set-may_schedule-for-some-of-console_trylock-callers.patch
printk-check-con_enabled-in-have_callable_console.patch

