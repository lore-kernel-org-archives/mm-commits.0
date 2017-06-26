From: akpm@linux-foundation.org
Subject: [merged]
 mm-huge-vmap-fail-gracefully-on-unexpected-huge-vmap-mappings.patch removed
 from -mm tree
Date: Mon, 26 Jun 2017 13:22:39 -0700
Message-ID: <20170626202239.RIOonz-kG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdFZUWl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 16:22:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, dave.hansen@intel.com, labbott@redhat.com, mark.rutland@arm.com, mhocko@suse.com, mm-commits@vger.kernel.org, zhongjiang@huawei.com


The patch titled
     Subject: mm/vmalloc.c: huge-vmap: fail gracefully on unexpected huge vmap mappings
has been removed from the -mm tree.  Its filename was
     mm-huge-vmap-fail-gracefully-on-unexpected-huge-vmap-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: mm/vmalloc.c: huge-vmap: fail gracefully on unexpected huge vmap mappings

Existing code that uses vmalloc_to_page() may assume that any address for
which is_vmalloc_addr() returns true may be passed into vmalloc_to_page()
to retrieve the associated struct page.

This is not un unreasonable assumption to make, but on architectures that
have CONFIG_HAVE_ARCH_HUGE_VMAP=y, it no longer holds, and we need to
ensure that vmalloc_to_page() does not go off into the weeds trying to
dereference huge PUDs or PMDs as table entries.

Given that vmalloc() and vmap() themselves never create huge mappings or
deal with compound pages at all, there is no correct answer in this case,
so return NULL instead, and issue a warning.

When reading /proc/kcore on arm64, you will hit an oops as soon as you
hit the huge mappings used for the various segments that make up the
mapping of vmlinux.  With this patch applied, you will no longer hit
the oops, but the kcore contents willl be incorrect (these regions will
be zeroed out)

We are fixing this for kcore specifically, so it avoids vread() for
those regions.  At least one other problematic user exists, i.e.,
/dev/kmem, but that is currently broken on arm64 for other reasons.

Link: http://lkml.kernel.org/r/20170609082226.26152-1-ard.biesheuvel@linaro.org
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Laura Abbott <labbott@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-huge-vmap-fail-gracefully-on-unexpected-huge-vmap-mappings mm/vmalloc.c
--- a/mm/vmalloc.c~mm-huge-vmap-fail-gracefully-on-unexpected-huge-vmap-mappings
+++ a/mm/vmalloc.c
@@ -287,10 +287,21 @@ struct page *vmalloc_to_page(const void
 	if (p4d_none(*p4d))
 		return NULL;
 	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud))
+
+	/*
+	 * Don't dereference bad PUD or PMD (below) entries. This will also
+	 * identify huge mappings, which we may encounter on architectures
+	 * that define CONFIG_HAVE_ARCH_HUGE_VMAP=y. Such regions will be
+	 * identified as vmalloc addresses by is_vmalloc_addr(), but are
+	 * not [unambiguously] associated with a struct page, so there is
+	 * no correct value to return for them.
+	 */
+	WARN_ON_ONCE(pud_bad(*pud));
+	if (pud_none(*pud) || pud_bad(*pud))
 		return NULL;
 	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	WARN_ON_ONCE(pmd_bad(*pmd));
+	if (pmd_none(*pmd) || pmd_bad(*pmd))
 		return NULL;
 
 	ptep = pte_offset_map(pmd, addr);
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are


