From: akpm@linux-foundation.org
Subject: + slub-another-slabinfo-fix.patch added to -mm tree
Date: Wed, 16 May 2007 22:38:33 -0700
Message-ID: <200705170538.l4H5cWLM018285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756037AbXEQFjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 01:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: another slabinfo fix
has been added to the -mm tree.  Its filename is
     slub-another-slabinfo-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: another slabinfo fix
From: Christoph Lameter <clameter@sgi.com>

The slab manipulation functions should not be triggered by slabs
that are unresovable in the subset of slabs selected on the command line.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slabinfo.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN Documentation/vm/slabinfo.c~slub-another-slabinfo-fix Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~slub-another-slabinfo-fix
+++ a/Documentation/vm/slabinfo.c
@@ -262,11 +262,17 @@ void decode_numa_list(int *numa, char *t
 
 void slab_validate(struct slabinfo *s)
 {
+	if (strcmp(s->name, "*") == 0)
+		return;
+
 	set_obj(s, "validate", 1);
 }
 
 void slab_shrink(struct slabinfo *s)
 {
+	if (strcmp(s->name, "*") == 0)
+		return;
+
 	set_obj(s, "shrink", 1);
 }
 
@@ -550,6 +556,9 @@ int slab_empty(struct slabinfo *s)
 
 void slab_debug(struct slabinfo *s)
 {
+	if (strcmp(s->name, "*") == 0)
+		return;
+
 	if (sanity && !s->sanity_checks) {
 		set_obj(s, "sanity", 1);
 	}
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-it-is-legit-to-allocate-a-slab-of-the-maximum-permitted-size.patch
slub-dont-confuse-ctor-and-dtor.patch
slab-allocators-drop-support-for-destructors.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
slab-warn-on-zero-length-allocations.patch
slub-fix-handling-of-oversized-slabs.patch
slub-slabinfo-fixes.patch
slub-do-our-own-flags-based-on-pg_active-and-pg_error.patch
remove-slab_ctor_constructor.patch
slub-simplify-debug-code.patch
slab-allocators-define-common-size-limitations.patch
fix-find_or_create_page-skips-cpuset-memory-spreading.patch
i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
fix-page-allocation-flags-in-grow_dev_page.patch
slub-another-slabinfo-fix.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
