From: akpm@linux-foundation.org
Subject: + fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch added to -mm tree
Date: Wed, 23 May 2007 11:30:35 -0700
Message-ID: <200705231830.l4NIUYWW029204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbXEWScJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:32:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wli@holomorphy.com, apw@shadowen.org, bill.irwin@oracle.com, bob.picco@hp.com, mel@csn.ul.ie, tony.luck@intel.com


The patch titled
     fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2 fix
has been added to the -mm tree.  Its filename is
     fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2 fix
From: William Lee Irwin III <wli@holomorphy.com>

CONFIG_SPARSEMEM sans CONFIG_MEMORY_HOTPLUG trips the following warning:
mm/sparse.c:254: warning: '__kmalloc_section_usemap' defined but not used
The following patch silences it.

Signed-off-by: William Irwin <bill.irwin@oracle.com>
Cc: Bob Picco <bob.picco@hp.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/sparse.c~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix mm/sparse.c
--- a/mm/sparse.c~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix
+++ a/mm/sparse.c
@@ -250,10 +250,12 @@ static unsigned long usemap_size(void)
 	return size_bytes;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
 static unsigned long *__kmalloc_section_usemap(void)
 {
 	return kmalloc(usemap_size(), GFP_KERNEL);
 }
+#endif /* CONFIG_MEMORY_HOTPLUG */
 
 static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
 {
_

Patches currently in -mm which might be from wli@holomorphy.com are

quicklist-support-for-x86_64.patch
x86_64-support-poll-on-dev-mcelog-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
