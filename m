From: akpm@linux-foundation.org
Subject: - use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:46:14 -0700
Message-ID: <200707092146.l69LkEi4013961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094AbXGIVqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tjanouse@redhat.com, johnstul@us.ibm.com, tsmetana@redhat.com, mm-commits@vger.kernel.org


The patch titled
     use-boot-based-time-for-process-start-time-and-boot-time-fix 2
has been removed from the -mm tree.  Its filename was
     use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch

This patch was dropped because it was folded into use-boot-based-time-for-process-start-time-and-boot-time.patch

------------------------------------------------------
Subject: use-boot-based-time-for-process-start-time-and-boot-time-fix 2
From: Tomas Janousek <tjanouse@redhat.com>

Restores the original behaviour of boot time calculation.

Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
Cc: Tomas Smetana <tsmetana@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/proc_misc.c~use-boot-based-time-for-process-start-time-and-boot-time-fix-2 fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~use-boot-based-time-for-process-start-time-and-boot-time-fix-2
+++ a/fs/proc/proc_misc.c
@@ -464,8 +464,6 @@ static int show_stat(struct seq_file *p,
 		irq = softirq = steal = cputime64_zero;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
-	if (boottime.tv_nsec)
-		++jif;
 
 	for_each_possible_cpu(i) {
 		int j;
_

Patches currently in -mm which might be from tjanouse@redhat.com are

introduce-boot-based-time.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch
use-boot-based-time-for-uptime-in-proc.patch
