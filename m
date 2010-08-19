From: akpm@linux-foundation.org
Subject: + timer-initialize-the-field-slack-of-timer_list.patch added to -mm tree
Date: Thu, 19 Aug 2010 16:55:55 -0700
Message-ID: <201008192355.o7JNttZR015943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab0HSX4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 19:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaosuo@gmail.com, arjan@infradead.org, tglx@linutronix.de


The patch titled
     timer: initialize the field slack of timer_list
has been added to the -mm tree.  Its filename is
     timer-initialize-the-field-slack-of-timer_list.patch

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
Subject: timer: initialize the field slack of timer_list
From: Changli Gao <xiaosuo@gmail.com>

TIMER_INITIALIZER() should initialize the field slack of timer_list as
__init_timer() does.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/timer.h~timer-initialize-the-field-slack-of-timer_list include/linux/timer.h
--- a/include/linux/timer.h~timer-initialize-the-field-slack-of-timer_list
+++ a/include/linux/timer.h
@@ -54,6 +54,7 @@ extern struct tvec_base boot_tvec_bases;
 		.expires = (_expires),				\
 		.data = (_data),				\
 		.base = &boot_tvec_bases,			\
+		.slack = -1,					\
 		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
 			__FILE__ ":" __stringify(__LINE__))	\
 	}
_

Patches currently in -mm which might be from xiaosuo@gmail.com are

timer-initialize-the-field-slack-of-timer_list.patch

