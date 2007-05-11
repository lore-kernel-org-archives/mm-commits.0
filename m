From: akpm@linux-foundation.org
Subject: + use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch added to -mm tree
Date: Fri, 11 May 2007 12:49:17 -0700
Message-ID: <200705111949.l4BJnHoM025069@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763727AbXEKTta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tjanouse@redhat.com, johnstul@us.ibm.com, tsmetana@redhat.com


The patch titled
     use-boot-based-time-for-process-start-time-and-boot-time-fix 2
has been added to the -mm tree.  Its filename is
     use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 deletions(-)

diff -puN fs/proc/proc_misc.c~use-boot-based-time-for-process-start-time-and-boot-time-fix-2 fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~use-boot-based-time-for-process-start-time-and-boot-time-fix-2
+++ a/fs/proc/proc_misc.c
@@ -451,8 +451,6 @@ static int show_stat(struct seq_file *p,
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
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch
use-boot-based-time-for-uptime-in-proc.patch
