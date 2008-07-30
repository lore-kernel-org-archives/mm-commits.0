From: akpm@linux-foundation.org
Subject: + docsrc-fix-getdelays-printk-formats.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:31:37 -0700
Message-ID: <200807300031.m6U0VbxY030219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbYG3Abz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:31:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, balbir@in.ibm.com, randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     docsrc: fix getdelays printk formats
has been added to the -mm tree.  Its filename is
     docsrc-fix-getdelays-printk-formats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docsrc: fix getdelays printk formats
From: Randy Dunlap <rdunlap@xenotime.net>


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

Patches currently in -mm which might be from rdunlap@xenotime.net are

docsrc-fix-getdelays-printk-formats.patch

