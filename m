From: akpm@linux-foundation.org
Subject: + add-isolate-migratetype-name-to-proc-pagetypeinfo.patch added to -mm tree
Date: Mon, 14 Apr 2008 22:47:35 -0700
Message-ID: <200804150547.m3F5lZRm013292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbYDOFsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 01:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     add "Isolate" migratetype name to /proc/pagetypeinfo
has been added to the -mm tree.  Its filename is
     add-isolate-migratetype-name-to-proc-pagetypeinfo.patch

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
Subject: add "Isolate" migratetype name to /proc/pagetypeinfo
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>

In a5d76b54a3f3a40385d7f76069a2feac9f1bad63 (memory unplug: page isolation by
KAMEZAWA Hiroyuki), "isolate" migratetype added.  but unfortunately, it
doesn't treat /proc/pagetypeinfo display logic.

this patch add "Isolate" to pagetype name field.

/proc/pagetype
before:
------------------------------------------------------------------------------------------------------------------------
Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10
Node    0, zone      DMA, type    Unmovable      1      2      2      2      1      2      2      1      1      0      0
Node    0, zone      DMA, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone      DMA, type      Movable      2      3      3      1      3      3      2      0      0      0      0
Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      0      1
Node    0, zone      DMA, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone   Normal, type    Unmovable      1      9      7      4      1      1      1      1      0      0      0
Node    0, zone   Normal, type  Reclaimable      5      2      0      0      1      1      0      0      0      1      0
Node    0, zone   Normal, type      Movable      0      1      1      0      0      0      1      0      0      1     60
Node    0, zone   Normal, type      Reserve      0      0      0      0      0      0      0      0      0      0      1
Node    0, zone   Normal, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone  HighMem, type    Unmovable      0      0      1      1      1      0      1      1      2      2      0
Node    0, zone  HighMem, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone  HighMem, type      Movable    236     62      6      2      2      1      1      0      1      1     16
Node    0, zone  HighMem, type      Reserve      0      0      0      0      0      0      0      0      0      0      1
Node    0, zone  HighMem, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve       <NULL>
Node 0, zone      DMA            1            0            2       1            0
Node 0, zone   Normal           10           40          169       1            0
Node 0, zone  HighMem            2            0          283       1            0

after:
------------------------------------------------------------------------------------------------------------------------
Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10
Node    0, zone      DMA, type    Unmovable      1      2      2      2      1      2      2      1      1      0      0
Node    0, zone      DMA, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone      DMA, type      Movable      2      3      3      1      3      3      2      0      0      0      0
Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      0      1
Node    0, zone      DMA, type      Isolate      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone   Normal, type    Unmovable      0      2      1      1      0      1      0      0      0      0      0
Node    0, zone   Normal, type  Reclaimable      1      1      1      1      1      0      1      1      1      0      0
Node    0, zone   Normal, type      Movable      0      1      1      1      0      1      0      1      0      0    196
Node    0, zone   Normal, type      Reserve      0      0      0      0      0      0      0      0      0      0      1
Node    0, zone   Normal, type      Isolate      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone  HighMem, type    Unmovable      0      1      0      0      0      1      1      1      2      2      0
Node    0, zone  HighMem, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone  HighMem, type      Movable      1      0      1      1      0      0      0      0      1      0    200
Node    0, zone  HighMem, type      Reserve      0      0      0      0      0      0      0      0      0      0      1
Node    0, zone  HighMem, type      Isolate      0      0      0      0      0      0      0      0      0      0      0

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
Node 0, zone      DMA            1            0            2       1            0
Node 0, zone   Normal            8            4          207       1            0
Node 0, zone  HighMem            2            0          283       1            0

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmstat.c~add-isolate-migratetype-name-to-proc-pagetypeinfo mm/vmstat.c
--- a/mm/vmstat.c~add-isolate-migratetype-name-to-proc-pagetypeinfo
+++ a/mm/vmstat.c
@@ -388,6 +388,7 @@ static char * const migratetype_names[MI
 	"Reclaimable",
 	"Movable",
 	"Reserve",
+	"Isolate",
 };
 
 static void *frag_start(struct seq_file *m, loff_t *pos)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

add-isolate-migratetype-name-to-proc-pagetypeinfo.patch
git-ia64.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmallocinfo-add-caller-information.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
smaps-account-swap-entries.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
memcgroup-make-the-memory-controller-more-desktop-responsive.patch

