From: akpm@linux-foundation.org
Subject: + pids-increase-pid_max-based-on-num_possible_cpus.patch added to -mm tree
Date: Thu, 29 Apr 2010 15:38:08 -0700
Message-ID: <201004292238.o3TMc8CV015656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932727Ab0D3RIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, hedi@sgi.com, holt@sgi.com, john@stoffel.org, mingo@elte.hu, pavel@ucw.cz, riel@redhat.com, steiner@sgi.com, torvalds@linux-foundation.org


The patch titled
     pids: increase pid_max based on num_possible_cpus
has been added to the -mm tree.  Its filename is
     pids-increase-pid_max-based-on-num_possible_cpus.patch

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
Subject: pids: increase pid_max based on num_possible_cpus
From: Mike Travis <travis@sgi.com>

On a system with a substantial number of processors, the early default
pid_max of 32k will not be enough.  A system with 1664 CPU's, there are
25163 processes started before the login prompt.  It's estimated that with
2048 CPU's we will pass the 32k limit.  With 4096, we'll reach that limit
very early during the boot cycle, and processes would stall waiting for an
available pid.

This patch increases the early maximum number of pids available, and
increases the minimum number of pids that can be set during runtime.

Signed-off-by: Hedi Berriche <hedi@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: John Stoffel <john@stoffel.org>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/threads.h |    9 +++++++++
 kernel/pid.c            |    7 +++++++
 2 files changed, 16 insertions(+)

diff -puN include/linux/threads.h~pids-increase-pid_max-based-on-num_possible_cpus include/linux/threads.h
--- a/include/linux/threads.h~pids-increase-pid_max-based-on-num_possible_cpus
+++ a/include/linux/threads.h
@@ -33,4 +33,13 @@
 #define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
 	(sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
 
+/*
+ * Define a minimum number of pids per cpu.  Heuristically based
+ * on original pid max of 32k for 32 cpus.  Also, increase the
+ * minimum settable value for pid_max on the running system based
+ * on similar defaults.  See kernel/pid.c:pidmap_init() for details.
+ */
+#define PIDS_PER_CPU_DEFAULT	1024
+#define PIDS_PER_CPU_MIN	8
+
 #endif
diff -puN kernel/pid.c~pids-increase-pid_max-based-on-num_possible_cpus kernel/pid.c
--- a/kernel/pid.c~pids-increase-pid_max-based-on-num_possible_cpus
+++ a/kernel/pid.c
@@ -513,6 +513,13 @@ void __init pidhash_init(void)
 
 void __init pidmap_init(void)
 {
+	/* bump default and minimum pid_max based on number of cpus */
+	pid_max = min(pid_max_max, max(pid_max,
+				PIDS_PER_CPU_DEFAULT * num_possible_cpus()));
+	pid_max_min = max(pid_max_min,
+				PIDS_PER_CPU_MIN * num_possible_cpus());
+	pr_info("pid_max: default: %u minimum: %u\n", pid_max, pid_max_min);
+
 	init_pid_ns.pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	/* Reserve PID 0. We never call free_pidmap(0) */
 	set_bit(0, init_pid_ns.pidmap[0].page);
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch
pids-increase-pid_max-based-on-num_possible_cpus.patch

