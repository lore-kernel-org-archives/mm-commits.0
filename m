From: akpm@linux-foundation.org
Subject: + proc-pagetypeinfo-fix-output-for-memoryless-nodes.patch added to -mm tree
Date: Tue, 29 Apr 2008 13:28:56 -0700
Message-ID: <200804292028.m3TKSu9X008167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986AbYD2U31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 16:29:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     /proc/pagetypeinfo: fix output for memoryless nodes
has been added to the -mm tree.  Its filename is
     proc-pagetypeinfo-fix-output-for-memoryless-nodes.patch

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
Subject: /proc/pagetypeinfo: fix output for memoryless nodes
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

on memoryless node, /proc/pagetypeinfo is displayed slightly funny output.
this patch fix it.

output example (header is outputed, but no data is outputed)
--------------------------------------------------------------
Page block order: 14
Pages per block:  16384

Free pages count per migrate type at order       0      1      2      3      4      5    \
  6      7      8      9     10     11     12     13     14     15     16

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
Page block order: 14
Pages per block:  16384

Free pages count per migrate type at order       0      1      2      3      4      5    \
  6      7      8      9     10     11     12     13     14     15     16

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/vmstat.c~proc-pagetypeinfo-fix-output-for-memoryless-nodes mm/vmstat.c
--- a/mm/vmstat.c~proc-pagetypeinfo-fix-output-for-memoryless-nodes
+++ a/mm/vmstat.c
@@ -548,6 +548,10 @@ static int pagetypeinfo_show(struct seq_
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
 
+	/* check memoryless node */
+	if (!node_state(pgdat->node_id, N_HIGH_MEMORY))
+		return 0;
+
 	seq_printf(m, "Page block order: %d\n", pageblock_order);
 	seq_printf(m, "Pages per block:  %lu\n", pageblock_nr_pages);
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
memcgroup-make-the-memory-controller-more-desktop-responsive.patch
proc-pagetypeinfo-fix-output-for-memoryless-nodes.patch

