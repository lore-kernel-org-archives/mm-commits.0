From: akpm@linux-foundation.org
Subject: + printk-drop-logbuf_cpu-volatile-qualifier.patch added to -mm
 tree
Date: Tue, 18 Nov 2014 13:44:58 -0800
Message-ID: <546bbdda.0jSYcm359BHHMhbH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaKRVo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 16:44:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elder@linaro.org, bobby.prani@gmail.com, jack@suse.cz, joe@perches.com, mcgrof@suse.com, pmladek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: drop logbuf_cpu volatile qualifier
has been added to the -mm tree.  Its filename is
     printk-drop-logbuf_cpu-volatile-qualifier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-drop-logbuf_cpu-volatile-qualifier.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/printk-drop-logbuf_cpu-volatile-qualifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Elder <elder@linaro.org>
Subject: printk: drop logbuf_cpu volatile qualifier

Pranith Kumar posted a patch in which removed the "volatile"
qualifier for the "logbuf_cpu" variable in vprintk_emit().
    https://lkml.org/lkml/2014/11/13/894
In his patch, he used ACCESS_ONCE() for all references to
that symbol to provide whatever protection was intended.

There was some discussion that followed, and in the end
Stephen Rostedt concluded that not only was "volatile" not
needed, neither was it required to use ACCESS_ONCE().  I
offered an elaborate description that concluded Stephen
was right, and Pranith asked me to submit an alternative
patch.  And this is it.

The basic reason "volatile" is not needed is that "logbuf_cpu" has
static storage duration, and vprintk_emit() is an exported
interface.  This means that the value of logbuf_cpu must be read
from memory the first time it is used in a particular call of
vprintk_emit().  The variable's value is read only once in that
function, when it's read it'll be the copy from memory (or cache).

In addition, the value of "logbuf_cpu" is only ever written under
protection of a spinlock.  So the value that is read is the "real"
value (and not an out-of-date cached one).  If its value is not
UINT_MAX, it is the current CPU's processor id, and it will have
been last written by the running CPU.

Signed-off-by: Alex Elder <elder@linaro.org>
Reported-by: Pranith Kumar <bobby.prani@gmail.com>
Suggested-by: Stephen Rostet <rostedt@goodmis.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-drop-logbuf_cpu-volatile-qualifier kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-drop-logbuf_cpu-volatile-qualifier
+++ a/kernel/printk/printk.c
@@ -1624,7 +1624,7 @@ asmlinkage int vprintk_emit(int facility
 	int printed_len = 0;
 	bool in_sched = false;
 	/* cpu currently holding logbuf_lock in this function */
-	static volatile unsigned int logbuf_cpu = UINT_MAX;
+	static unsigned int logbuf_cpu = UINT_MAX;
 
 	if (level == LOGLEVEL_SCHED) {
 		level = LOGLEVEL_DEFAULT;
_

Patches currently in -mm which might be from elder@linaro.org are

printk-drop-logbuf_cpu-volatile-qualifier.patch
linux-next.patch

