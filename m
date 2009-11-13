From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-fix-section-mismatch.patch added to -mm tree
Date: Fri, 13 Nov 2009 15:25:29 -0800
Message-ID: <200911132325.nADNPTm7008806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932430AbZKMXZw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 18:25:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seto.hidetoshi@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, y-goto@jp.fujitsu.com


The patch titled
     mm/memory_hotplug: fix section mismatch
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-fix-section-mismatch.patch

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
Subject: mm/memory_hotplug: fix section mismatch
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

With CONFIG_MEMORY_HOTPLUG I got following warning:

WARNING: vmlinux.o(.text+0x1276b0): Section mismatch in reference from
the function hotadd_new_pgdat() to the function
.meminit.text:free_area_init_node()
The function hotadd_new_pgdat() references
the function __meminit free_area_init_node().
This is often because hotadd_new_pgdat lacks a __meminit
annotation or the annotation of free_area_init_node is wrong.

Use __ref to fix this.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-fix-section-mismatch mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-section-mismatch
+++ a/mm/memory_hotplug.c
@@ -448,7 +448,8 @@ int online_pages(unsigned long pfn, unsi
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
-static pg_data_t *hotadd_new_pgdat(int nid, u64 start)
+/* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
+static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 {
 	struct pglist_data *pgdat;
 	unsigned long zones_size[MAX_NR_ZONES] = {0};
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

mm-memory_hotplug-fix-section-mismatch.patch
linux-next.patch
checkpatch-trivial-fix-for-trailing-statements-check.patch

