From: akpm@linux-foundation.org
Subject: + mm-vmallocc-dont-use-vmalloc_end.patch added to -mm tree
Date: Mon, 07 Dec 2009 15:36:21 -0800
Message-ID: <200912072336.nB7NaLQI020762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935547AbZLGXhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 18:37:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, geert@linux-m68k.org, jbeulich@novell.com, tj@kernel.org, tony.luck@intel.com


The patch titled
     mm/vmalloc.c: don't use vmalloc_end
has been added to the -mm tree.  Its filename is
     mm-vmallocc-dont-use-vmalloc_end.patch

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
Subject: mm/vmalloc.c: don't use vmalloc_end
From: "Jan Beulich" <JBeulich@novell.com>

At least on ia64 vmalloc_end is a global variable that VMALLOC_END expands
to.  Hence having a local variable named vmalloc_end and initialized from
VMALLOC_END won't work on such platforms.  Rename these variables, and for
consistency also rename vmalloc_start.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-dont-use-vmalloc_end mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-dont-use-vmalloc_end
+++ a/mm/vmalloc.c
@@ -2060,13 +2060,13 @@ static unsigned long pvm_determine_end(s
 				       struct vmap_area **pprev,
 				       unsigned long align)
 {
-	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	const unsigned long end = VMALLOC_END & ~(align - 1);
 	unsigned long addr;
 
 	if (*pnext)
-		addr = min((*pnext)->va_start & ~(align - 1), vmalloc_end);
+		addr = min((*pnext)->va_start & ~(align - 1), end);
 	else
-		addr = vmalloc_end;
+		addr = end;
 
 	while (*pprev && (*pprev)->va_end > addr) {
 		*pnext = *pprev;
@@ -2105,8 +2105,8 @@ struct vm_struct **pcpu_get_vm_areas(con
 				     const size_t *sizes, int nr_vms,
 				     size_t align, gfp_t gfp_mask)
 {
-	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
-	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	const unsigned long vstart = ALIGN(VMALLOC_START, align);
+	const unsigned long vend = VMALLOC_END & ~(align - 1);
 	struct vmap_area **vas, *prev, *next;
 	struct vm_struct **vms;
 	int area, area2, last_area, term_area;
@@ -2142,7 +2142,7 @@ struct vm_struct **pcpu_get_vm_areas(con
 	}
 	last_end = offsets[last_area] + sizes[last_area];
 
-	if (vmalloc_end - vmalloc_start < last_end) {
+	if (vend - vstart < last_end) {
 		WARN_ON(true);
 		return NULL;
 	}
@@ -2167,7 +2167,7 @@ retry:
 	end = start + sizes[area];
 
 	if (!pvm_find_next_prev(vmap_area_pcpu_hole, &next, &prev)) {
-		base = vmalloc_end - last_end;
+		base = vend - last_end;
 		goto found;
 	}
 	base = pvm_determine_end(&next, &prev, align) - end;
@@ -2180,7 +2180,7 @@ retry:
 		 * base might have underflowed, add last_end before
 		 * comparing.
 		 */
-		if (base + last_end < vmalloc_start + last_end) {
+		if (base + last_end < vstart + last_end) {
 			spin_unlock(&vmap_area_lock);
 			if (!purged) {
 				purge_vmap_area_lazy();
_

Patches currently in -mm which might be from JBeulich@novell.com are

origin.patch
linux-next.patch
mm-vmallocc-dont-use-vmalloc_end.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
kbuild-generate-modulesbuiltin-fix-2.patch
fix-section-mismatch-in-early-ehci-dbgp.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
mm-bootmemc-properly-__init-annotate-helper-functions.patch
dma-mapping-fix-off-by-one-error-in-dma_capable.patch

