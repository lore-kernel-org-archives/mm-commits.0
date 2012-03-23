From: akpm@linux-foundation.org
Subject: [folded] procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:32:01 -0700
Message-ID: <20120323213201.D9605A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:45026 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2CWVcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:32:04 -0400
Received: by wejx9 with SMTP id x9so189140wej.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:32:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrea@betterlinux.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: avoid breaking the ABI in /proc/stat
has been removed from the -mm tree.  Its filename was
     procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch

This patch was dropped because it was folded into procfs-add-num_to_str-to-speed-up-proc-stat.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from andrea@betterlinux.com are

origin.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch

