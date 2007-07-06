From: akpm@linux-foundation.org
Subject: + mm-fixup-proc-vmstat-output.patch added to -mm tree
Date: Fri, 06 Jul 2007 11:05:07 -0700
Message-ID: <200707061805.l66I579O011560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761925AbXGFSFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 14:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl


The patch titled
     mm: fixup /proc/vmstat output
has been added to the -mm tree.  Its filename is
     mm-fixup-proc-vmstat-output.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fixup /proc/vmstat output
From: Peter Zijlstra <peterz@infradead.org>

Line up the vmstat_text with zone_stat_item

enum zone_stat_item {
	/* First 128 byte cacheline (assuming 64 bit words) */
	NR_FREE_PAGES,
	NR_INACTIVE,
	NR_ACTIVE,

We current have nr_active and nr_inactive reversed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-fixup-proc-vmstat-output mm/vmstat.c
--- a/mm/vmstat.c~mm-fixup-proc-vmstat-output
+++ a/mm/vmstat.c
@@ -477,8 +477,8 @@ const struct seq_operations fragmentatio
 static const char * const vmstat_text[] = {
 	/* Zoned VM counters */
 	"nr_free_pages",
-	"nr_active",
 	"nr_inactive",
+	"nr_active",
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
_

Patches currently in -mm which might be from peterz@infradead.org are

mm-fixup-proc-vmstat-output.patch
