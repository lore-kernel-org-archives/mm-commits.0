From: akpm@linux-foundation.org
Subject: + init-mainc-mark-do_one_initcall-as-__init_or_module.patch added to -mm tree
Date: Wed, 07 Jul 2010 17:18:51 -0700
Message-ID: <201007080018.o680Ip7v002943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756377Ab0GHATC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 20:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kjwinchester@gmail.com, mingo@elte.hu, rusty@rustcorp.com.au


The patch titled
     init/main.c: mark do_one_initcall* as __init_or_module
has been added to the -mm tree.  Its filename is
     init-mainc-mark-do_one_initcall-as-__init_or_module.patch

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
Subject: init/main.c: mark do_one_initcall* as __init_or_module
From: Kevin Winchester <kjwinchester@gmail.com>

Andrew Morton suggested that the do_one_initcall and do_one_initcall_debug
functions can be marked __init_or_module such that they can be discarded
for the CONFIG_MODULES=N case.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/main.c~init-mainc-mark-do_one_initcall-as-__init_or_module init/main.c
--- a/init/main.c~init-mainc-mark-do_one_initcall-as-__init_or_module
+++ a/init/main.c
@@ -724,7 +724,7 @@ core_param(initcall_debug, initcall_debu
 
 static char msgbuf[64];
 
-static int do_one_initcall_debug(initcall_t fn)
+static int __init_or_module do_one_initcall_debug(initcall_t fn)
 {
 	ktime_t calltime, delta, rettime;
 	unsigned long long duration;
@@ -742,7 +742,7 @@ static int do_one_initcall_debug(initcal
 	return ret;
 }
 
-int do_one_initcall(initcall_t fn)
+int __init_or_module do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	int ret;
_

Patches currently in -mm which might be from kjwinchester@gmail.com are

linux-next.patch
init-mainc-fix-warning-calltimetv64-may-be-used-uninitialized.patch
init-mainc-mark-do_one_initcall-as-__init_or_module.patch

