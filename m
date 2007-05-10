From: akpm@linux-foundation.org
Subject: + use-defines-in-sys_getpriority-sys_setpriority.patch added to -mm tree
Date: Thu, 10 May 2007 16:48:27 -0700
Message-ID: <200705102348.l4ANmROD001660@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932690AbXEJXsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 19:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, mingo@elte.hu


The patch titled
     use defines in sys_getpriority/sys_setpriority
has been added to the -mm tree.  Its filename is
     use-defines-in-sys_getpriority-sys_setpriority.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use defines in sys_getpriority/sys_setpriority
From: Daniel Walker <dwalker@mvista.com>

Switch to the defines for these two checks, instead of hard coding the
values.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~use-defines-in-sys_getpriority-sys_setpriority kernel/sys.c
--- a/kernel/sys.c~use-defines-in-sys_getpriority-sys_setpriority
+++ a/kernel/sys.c
@@ -659,7 +659,7 @@ asmlinkage long sys_setpriority(int whic
 	int error = -EINVAL;
 	struct pid *pgrp;
 
-	if (which > 2 || which < 0)
+	if (which > PRIO_USER || which < PRIO_PROCESS)
 		goto out;
 
 	/* normalize: avoid signed division (rounding problems) */
@@ -723,7 +723,7 @@ asmlinkage long sys_getpriority(int whic
 	long niceval, retval = -ESRCH;
 	struct pid *pgrp;
 
-	if (which > 2 || which < 0)
+	if (which > PRIO_USER || which < PRIO_PROCESS)
 		return -EINVAL;
 
 	read_lock(&tasklist_lock);
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
use-defines-in-sys_getpriority-sys_setpriority.patch
use-defines-in-sys_getpriority-sys_setpriority-fix.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
