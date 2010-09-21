From: akpm@linux-foundation.org
Subject: + printk-change-type-of-boot_delay-to-int.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:11:25 -0700
Message-ID: <201009212311.o8LNBPtw008389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab0IUXLg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:11:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, mingo@elte.hu


The patch titled
     printk: change type of 'boot_delay' to int *
has been added to the -mm tree.  Its filename is
     printk-change-type-of-boot_delay-to-int.patch

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
Subject: printk: change type of 'boot_delay' to int *
From: Namhyung Kim <namhyung@gmail.com>

get_option() takes its 2nd arg as int * so passing boot_delay to it
caused following warnings from sparse:

 kernel/printk.c:223:27: warning: incorrect type in argument 2 (different signedness)
 kernel/printk.c:223:27:    expected int *pint
 kernel/printk.c:223:27:    got unsigned int static [toplevel] *<noident>

Since boot_delay can't grow more than 10,000 changing it to 'int *'
will not produce any problem.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-change-type-of-boot_delay-to-int kernel/printk.c
--- a/kernel/printk.c~printk-change-type-of-boot_delay-to-int
+++ a/kernel/printk.c
@@ -210,7 +210,7 @@ __setup("log_buf_len=", log_buf_len_setu
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
-static unsigned int boot_delay; /* msecs delay after each printk during bootup */
+static int boot_delay; /* msecs delay after each printk during bootup */
 static unsigned long long loops_per_msec;	/* based on boot_delay */
 
 static int __init boot_delay_setup(char *str)
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
init-mark-__user-address-space-on-string-literals.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

