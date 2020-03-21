From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-compaction-disable-compact_unevictable_allowed-on-rt-v5.patch added to
 -mm tree
Date: Fri, 20 Mar 2020 17:54:34 -0700
Message-ID: <20200321005434.nZGmUXF99%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAyg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 20:54:36 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, keescook@chromium.org, mcgrof@kernel.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org, tglx@linutronix.de, vbabka@suse.cz, yzaikin@google.com


The patch titled
     Subject: mm-compaction-disable-compact_unevictable_allowed-on-rt-v5
has been added to the -mm tree.  Its filename is
     mm-compaction-disable-compact_unevictable_allowed-on-rt-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-disable-compact_unevictable_allowed-on-rt-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-disable-compact_unevictable_allowed-on-rt-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm-compaction-disable-compact_unevictable_allowed-on-rt-v5

v4-v5: - Add Vlastimil's Acked-by
       - s/changed changed/changed/

v3-v4: - Replace WARN_ONCE() with pr_warn_once() and extend the message
         by name of the task and its pid.
       - Use proc_dointvec_minmax() in the !RT case.
       - Added Mel's Ack as per
         20200304091159.GN3818@techsingularity.net.

Link: https://lore.kernel.org/linux-mm/20190710144138.qyn4tuttdq6h7kqx@linutronix.de/
Link: http://lkml.kernel.org/r/20200319165536.ovi75tsr2seared4@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/kernel/sysctl.c~mm-compaction-disable-compact_unevictable_allowed-on-rt-v5
+++ a/kernel/sysctl.c
@@ -213,9 +213,9 @@ static int proc_do_cad_pid(struct ctl_ta
 static int proc_taint(struct ctl_table *table, int write,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #ifdef CONFIG_COMPACTION
-static int proc_dointvec_warn_RT_change(struct ctl_table *table, int write,
-					void __user *buffer, size_t *lenp,
-					loff_t *ppos);
+static int proc_dointvec_minmax_warn_RT_change(struct ctl_table *table,
+					       int write, void __user *buffer,
+					       size_t *lenp, loff_t *ppos);
 #endif
 #endif
 
@@ -1489,7 +1489,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_compact_unevictable_allowed,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_warn_RT_change,
+		.proc_handler	= proc_dointvec_minmax_warn_RT_change,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -2578,21 +2578,23 @@ int proc_dointvec(struct ctl_table *tabl
 }
 
 #ifdef CONFIG_COMPACTION
-static int proc_dointvec_warn_RT_change(struct ctl_table *table, int write,
-					void __user *buffer, size_t *lenp,
-					loff_t *ppos)
+static int proc_dointvec_minmax_warn_RT_change(struct ctl_table *table,
+					       int write, void __user *buffer,
+					       size_t *lenp, loff_t *ppos)
 {
 	int ret, old;
 
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || !write)
-		return proc_dointvec(table, write, buffer, lenp, ppos);
+		return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	old = *(int *)table->data;
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret)
 		return ret;
-	WARN_ONCE(old != *(int *)table->data, "sysctl attribute %s changed.",
-		  table->procname);
+	if (old != *(int *)table->data)
+		pr_warn_once("sysctl attribute %s changed by %s[%d]\n",
+			     table->procname, current->comm,
+			     task_pid_nr(current));
 	return ret;
 }
 #endif
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

really-limit-compact_unevictable_allowed-to-0-and-1.patch
mm-compaction-disable-compact_unevictable_allowed-on-rt.patch
mm-compaction-disable-compact_unevictable_allowed-on-rt-v5.patch
