From: akpm@linux-foundation.org
Subject: + revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch added to -mm tree
Date: Wed, 30 Apr 2008 00:37:07 -0700
Message-ID: <200804300737.m3U7b7H3001821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201AbYD3HhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 03:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, pbadari@us.ibm.com, torvalds@linux-foundation.org, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com


The patch titled
     revert "memory hotplug: allocate usemap on the section with pgdat"
has been added to the -mm tree.  Its filename is
     revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch

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
Subject: revert "memory hotplug: allocate usemap on the section with pgdat"
From: Andrew Morton <akpm@linux-foundation.org>

This:

commit 86f6dae1377523689bd8468fed2f2dd180fc0560
Author: Yasunori Goto <y-goto@jp.fujitsu.com>
Date:   Mon Apr 28 02:13:33 2008 -0700

    memory hotplug: allocate usemap on the section with pgdat
    
    Usemaps are allocated on the section which has pgdat by this.
    
    Because usemap size is very small, many other sections usemaps are allocated
    on only one page.  If a section has usemap, it can't be removed until removing
    other sections.  This dependency is not desirable for memory removing.
    
    Pgdat has similar feature.  When a section has pgdat area, it must be the last
    section for removing on the node.  So, if section A has pgdat and section B
    has usemap for section A, Both sections can't be removed due to dependency
    each other.
    
    To solve this issue, this patch collects usemap on same section with pgdat.
    If other sections doesn't have any dependency, this section will be able to be
    removed finally.
    
    Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
    Cc: Badari Pulavarty <pbadari@us.ibm.com>
    Cc: Yinghai Lu <yhlu.kernel@gmail.com>
    Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

broke davem's sparc64 bootup.  Revert it while we work out what went wrong.

Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN mm/sparse.c~revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat mm/sparse.c
--- a/mm/sparse.c~revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat
+++ a/mm/sparse.c
@@ -250,22 +250,11 @@ static unsigned long *__kmalloc_section_
 
 static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 {
-	unsigned long *usemap, section_nr;
+	unsigned long *usemap;
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
-	struct pglist_data *pgdat = NODE_DATA(nid);
 
-	/*
-	 * Usemap's page can't be freed until freeing other sections
-	 * which use it. And, Pgdat has same feature.
-	 * If section A has pgdat and section B has usemap for other
-	 * sections (includes section A), both sections can't be removed,
-	 * because there is the dependency each other.
-	 * To solve above issue, this collects all usemap on the same section
-	 * which has pgdat.
-	 */
-	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
-	usemap = alloc_bootmem_section(usemap_size(), section_nr);
+	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
 	if (usemap)
 		return usemap;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
devpts-factor-out-pty-index-allocation.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
fuse-fix-race-in-llseek.patch
basic-braille-screen-reader-support.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch

