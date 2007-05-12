From: akpm@linux-foundation.org
Subject: - dont-init-pgrp-and-__session-in-init_signals.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:51 -0700
Message-ID: <200705120534.l4C5YppS002231@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382AbXELFfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com, oleg@tv-sign.ru, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Don't init pgrp and __session in INIT_SIGNALS
has been removed from the -mm tree.  Its filename was
     dont-init-pgrp-and-__session-in-init_signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
