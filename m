From: akpm@linux-foundation.org
Subject: + mm-vmstatc-fix-cleanup-ifdefs-fix-2.patch added to -mm tree
Date: Wed, 21 Jan 2015 14:32:00 -0800
Message-ID: <54c028e0.PLEoBuxeEqAxLE1S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbAUWcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jan 2015 17:32:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@ingics.com, iamjoonsoo.kim@lge.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: fix build error when !CONFIG_PROC_FS
has been added to the -mm tree.  Its filename is
     mm-vmstatc-fix-cleanup-ifdefs-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstatc-fix-cleanup-ifdefs-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstatc-fix-cleanup-ifdefs-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: mm: vmstat: fix build error when !CONFIG_PROC_FS

Fix build error when CONFIG_DEBUG_FS && CONFIG_COMPACTION && !CONFIG_PROC_FS:

  CC      mm/vmstat.o
mm/vmstat.c:1607:11: error: 'frag_start' undeclared here (not in a function)
mm/vmstat.c:1608:10: error: 'frag_next' undeclared here (not in a function)
mm/vmstat.c:1609:10: error: 'frag_stop' undeclared here (not in a function)
make[1]: *** [mm/vmstat.o] Error 1
make: *** [mm] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff -puN mm/vmstat.c~mm-vmstatc-fix-cleanup-ifdefs-fix-2 mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-fix-cleanup-ifdefs-fix-2
+++ a/mm/vmstat.c
@@ -852,6 +852,30 @@ const char * const vmstat_text[] = {
 
 #if (defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)) || \
      defined(CONFIG_PROC_FS)
+static void *frag_start(struct seq_file *m, loff_t *pos)
+{
+	pg_data_t *pgdat;
+	loff_t node = *pos;
+
+	for (pgdat = first_online_pgdat();
+	     pgdat && node;
+	     pgdat = next_online_pgdat(pgdat))
+		--node;
+
+	return pgdat;
+}
+
+static void *frag_next(struct seq_file *m, void *arg, loff_t *pos)
+{
+	pg_data_t *pgdat = (pg_data_t *)arg;
+
+	(*pos)++;
+	return next_online_pgdat(pgdat);
+}
+
+static void frag_stop(struct seq_file *m, void *arg)
+{
+}
 
 /* Walk all the zones in a node and print using a callback */
 static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
@@ -886,30 +910,6 @@ static char * const migratetype_names[MI
 #endif
 };
 
-static void *frag_start(struct seq_file *m, loff_t *pos)
-{
-	pg_data_t *pgdat;
-	loff_t node = *pos;
-	for (pgdat = first_online_pgdat();
-	     pgdat && node;
-	     pgdat = next_online_pgdat(pgdat))
-		--node;
-
-	return pgdat;
-}
-
-static void *frag_next(struct seq_file *m, void *arg, loff_t *pos)
-{
-	pg_data_t *pgdat = (pg_data_t *)arg;
-
-	(*pos)++;
-	return next_online_pgdat(pgdat);
-}
-
-static void frag_stop(struct seq_file *m, void *arg)
-{
-}
