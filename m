From: akpm@linux-foundation.org
Subject: + mm-bootmemc-properly-__init-annotate-helper-functions.patch added to -mm tree
Date: Mon, 23 Nov 2009 14:46:47 -0800
Message-ID: <200911232246.nANMkldN022308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbZKWWqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 17:46:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, hannes@cmpxchg.org, jbeulich@novell.com


The patch titled
     mm/bootmem.c: properly __init-annotate helper functions
has been added to the -mm tree.  Its filename is
     mm-bootmemc-properly-__init-annotate-helper-functions.patch

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
Subject: mm/bootmem.c: properly __init-annotate helper functions
From: "Jan Beulich" <JBeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/bootmem.c~mm-bootmemc-properly-__init-annotate-helper-functions mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmemc-properly-__init-annotate-helper-functions
+++ a/mm/bootmem.c
@@ -432,8 +432,8 @@ int __init reserve_bootmem(unsigned long
 	return mark_bootmem(start, end, 1, flags);
 }
 
-static unsigned long align_idx(struct bootmem_data *bdata, unsigned long idx,
-			unsigned long step)
+static unsigned long __init align_idx(struct bootmem_data *bdata,
+				      unsigned long idx, unsigned long step)
 {
 	unsigned long base = bdata->node_min_pfn;
 
@@ -445,8 +445,8 @@ static unsigned long align_idx(struct bo
 	return ALIGN(base + idx, step) - base;
 }
 
-static unsigned long align_off(struct bootmem_data *bdata, unsigned long off,
-			unsigned long align)
+static unsigned long __init align_off(struct bootmem_data *bdata,
+				      unsigned long off, unsigned long align)
 {
 	unsigned long base = PFN_PHYS(bdata->node_min_pfn);
 
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
kbuild-generate-modulesbuiltin-fix-2.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
mm-bootmemc-properly-__init-annotate-helper-functions.patch
dma-mapping-fix-off-by-one-error-in-dma_capable.patch

