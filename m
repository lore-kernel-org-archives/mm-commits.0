From: akpm@linux-foundation.org
Subject: + dont-init-pgrp-and-__session-in-init_signals.patch added to -mm tree
Date: Wed, 21 Mar 2007 11:46:49 -0700
Message-ID: <200703211846.l2LIknpv000629@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49057 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933635AbXCUSrl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 14:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, clg@fr.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com, oleg@tv-sign.ru, serue@us.ibm.com


The patch titled
     Don't init pgrp and __session in INIT_SIGNALS
has been added to the -mm tree.  Its filename is
     dont-init-pgrp-and-__session-in-init_signals.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Don't init pgrp and __session in INIT_SIGNALS
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Remove initialization of pgrp and __session in INIT_SIGNALS, as these are
later set by the call to __set_special_pids() in init/main.c by the patch:

	explicitly-set-pgid-and-sid-of-init-process.patch

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/init_task.h~dont-init-pgrp-and-__session-in-init_signals include/linux/init_task.h
--- a/include/linux/init_task.h~dont-init-pgrp-and-__session-in-init_signals
+++ a/include/linux/init_task.h
@@ -65,9 +65,9 @@
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
-	.pgrp		= 1,						\
+	.pgrp		= 0,						\
 	.tty_old_pgrp   = NULL,						\
-	{ .__session      = 1},						\
+	{ .__session      = 0},						\
 }
 
 extern struct nsproxy init_nsproxy;
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

attach_pid-with-struct-pid-parameter.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
