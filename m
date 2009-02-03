From: akpm@linux-foundation.org
Subject: + mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch added to -mm tree
Date: Mon, 02 Feb 2009 23:14:36 -0800
Message-ID: <200902030714.n137EaPe009333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbZBCHPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 02:15:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net, cl@linux-foundation.org, david@fromorbit.com, peterz@infradead.org, rientjes@google.com


The patch titled
     mm: fix dirty_bytes/dirty_background_bytes sysctls on 64bit arches
has been added to the -mm tree.  Its filename is
     mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch

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
Subject: mm: fix dirty_bytes/dirty_background_bytes sysctls on 64bit arches
From: Sven Wegener <sven.wegener@stealer.net>

We need to pass an unsigned long as the minimum, because it gets casted
to an unsigned long in the sysctl handler. If we pass an int, we'll
access four more bytes on 64bit arches, resulting in a random minimum
value.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/sysctl.c~mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches kernel/sysctl.c
--- a/kernel/sysctl.c~mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches
+++ a/kernel/sysctl.c
@@ -103,6 +103,7 @@ static int two = 2;
 
 static int zero;
 static int one = 1;
+static unsigned long one_ul = 1;
 static int one_hundred = 100;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
@@ -1007,7 +1008,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &dirty_background_bytes_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &one,
+		.extra1		= &one_ul,
 	},
 	{
 		.ctl_name	= VM_DIRTY_RATIO,
@@ -1028,7 +1029,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &dirty_bytes_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &one,
+		.extra1		= &one_ul,
 	},
 	{
 		.procname	= "dirty_writeback_centisecs",
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch
mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch

