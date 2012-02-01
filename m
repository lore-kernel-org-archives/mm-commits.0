From: akpm@linux-foundation.org
Subject: + procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch added to -mm tree
Date: Wed, 01 Feb 2012 12:36:53 -0800
Message-ID: <20120201203653.A727EA00EA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:53214 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2BAUg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 15:36:56 -0500
Received: by eekb15 with SMTP id b15so49334eek.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 12:36:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrea@betterlinux.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: procfs: avoid breaking the ABI in /proc/stat
has been added to the -mm tree.  Its filename is
     procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Righi <andrea@betterlinux.com>
Subject: procfs: avoid breaking the ABI in /proc/stat

The speed up of /proc/stat changed the output of the cpu statistics adding
an extra space between the string "cpu" and the cpu id.

Restore the old ABI by removing this space.

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/stat.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix-2 fs/proc/stat.c
--- a/fs/proc/stat.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix-2
+++ a/fs/proc/stat.c
@@ -114,7 +114,7 @@ static int show_stat(struct seq_file *p,
 		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
-		seq_printf(p, "cpu %d", i);
+		seq_printf(p, "cpu%d", i);
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
_
Subject: Subject: procfs: avoid breaking the ABI in /proc/stat

Patches currently in -mm which might be from andrea@betterlinux.com are

procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch

