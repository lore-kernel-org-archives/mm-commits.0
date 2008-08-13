From: akpm@linux-foundation.org
Subject: - docsrc-fix-getdelays-printk-formats.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:31 -0700
Message-ID: <200808130853.m7D8rVt6008335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbYHMJEP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:04:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, balbir@in.ibm.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     docsrc: fix getdelays printk formats
has been removed from the -mm tree.  Its filename was
     docsrc-fix-getdelays-printk-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docsrc: fix getdelays printk formats
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printf format type warnings (seen on alpha & ia64):

Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 6 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 7 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 8 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 9 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 12 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 13 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 16 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 17 has type '__u64'
Documentation/accounting/getdelays.c:214: warning: format '%15llu' expects type 'long long unsigned int', but argument 4 has type '__u64'
Documentation/accounting/getdelays.c:214: warning: format '%15llu' expects type 'long long unsigned int', but argument 5 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 2 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 5 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type '__u64'
Documentation/accounting/getdelays.c:236: warning: 'cmd_type' may be used uninitialized in this function

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN Documentation/accounting/getdelays.c~docsrc-fix-getdelays-printk-formats Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~docsrc-fix-getdelays-printk-formats
+++ a/Documentation/accounting/getdelays.c
@@ -201,13 +201,19 @@ void print_delayacct(struct taskstats *t
 	       "RECLAIM  %12s%15s\n"
 	       "      %15llu%15llu\n",
 	       "count", "real total", "virtual total", "delay total",
-	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
-	       t->cpu_delay_total,
+	       (unsigned long long)t->cpu_count,
+	       (unsigned long long)t->cpu_run_real_total,
+	       (unsigned long long)t->cpu_run_virtual_total,
+	       (unsigned long long)t->cpu_delay_total,
 	       "count", "delay total",
-	       t->blkio_count, t->blkio_delay_total,
-	       "count", "delay total", t->swapin_count, t->swapin_delay_total,
+	       (unsigned long long)t->blkio_count,
+	       (unsigned long long)t->blkio_delay_total,
 	       "count", "delay total",
-	       t->freepages_count, t->freepages_delay_total);
+	       (unsigned long long)t->swapin_count,
+	       (unsigned long long)t->swapin_delay_total,
+	       "count", "delay total",
+	       (unsigned long long)t->freepages_count,
+	       (unsigned long long)t->freepages_delay_total);
 }
 
 void task_context_switch_counts(struct taskstats *t)
@@ -215,14 +221,17 @@ void task_context_switch_counts(struct t
 	printf("\n\nTask   %15s%15s\n"
 	       "       %15llu%15llu\n",
 	       "voluntary", "nonvoluntary",
-	       t->nvcsw, t->nivcsw);
+	       (unsigned long long)t->nvcsw, (unsigned long long)t->nivcsw);
 }
 
 void print_cgroupstats(struct cgroupstats *c)
 {
 	printf("sleeping %llu, blocked %llu, running %llu, stopped %llu, "
-		"uninterruptible %llu\n", c->nr_sleeping, c->nr_io_wait,
-		c->nr_running, c->nr_stopped, c->nr_uninterruptible);
+		"uninterruptible %llu\n", (unsigned long long)c->nr_sleeping,
+		(unsigned long long)c->nr_io_wait,
+		(unsigned long long)c->nr_running,
+		(unsigned long long)c->nr_stopped,
+		(unsigned long long)c->nr_uninterruptible);
 }
 
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
ftrace-printk-formatting-infrastructure-fix-fix.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

