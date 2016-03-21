From: akpm@linux-foundation.org
Subject: [merged] printk-check-con_enabled-in-have_callable_console.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:18 -0700
Message-ID: <56f0404e.CERc1qLPosW/2Usp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931AbcCUTVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, calvinowens@fb.com, davej@codemonkey.org.uk, jack@suse.com, kyle@kernel.org, pmladek@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: check CON_ENABLED in have_callable_console()
has been removed from the -mm tree.  Its filename was
     printk-check-con_enabled-in-have_callable_console.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: printk: check CON_ENABLED in have_callable_console()

have_callable_console() must also test CON_ENABLED bit, not just
CON_ANYTIME.  We may have disabled CON_ANYTIME console so printk can
wrongly assume that it's safe to call_console_drivers().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
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
@@ -2146,7 +2146,8 @@ static int have_callable_console(void)
 	struct console *con;
 
 	for_each_console(con)
-		if (con->flags & CON_ANYTIME)
+		if ((con->flags & CON_ENABLED) &&
+				(con->flags & CON_ANYTIME))
 			return 1;
 
 	return 0;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


