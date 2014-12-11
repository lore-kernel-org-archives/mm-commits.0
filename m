From: akpm@linux-foundation.org
Subject: [merged] printk-drop-logbuf_cpu-volatile-qualifier.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:05:11 -0800
Message-ID: <5489eae7.ySTEMClrAhCYE2F6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaLKTFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elder@linaro.org, bobby.prani@gmail.com, jack@suse.cz, joe@perches.com, mcgrof@suse.com, pmladek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: drop logbuf_cpu volatile qualifier
has been removed from the -mm tree.  Its filename was
     printk-drop-logbuf_cpu-volatile-qualifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Elder <elder@linaro.org>
Subject: printk: drop logbuf_cpu volatile qualifier

Pranith Kumar posted a patch in which removed the "volatile"
qualifier for the "logbuf_cpu" variable in vprintk_emit().
    https://lkml.org/lkml/2014/11/13/894
In his patch, he used ACCESS_ONCE() for all references to
that symbol to provide whatever protection was intended.

There was some discussion that followed, and in the end Steven Rostedt
concluded that not only was "volatile" not needed, neither was it
required to use ACCESS_ONCE().  I offered an elaborate description that
concluded Steven was right, and Pranith asked me to submit an
alternative patch.  And this is it.

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
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
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

origin.patch

