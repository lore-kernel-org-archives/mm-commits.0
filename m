From: akpm@linux-foundation.org
Subject: - early_pfn_to_nid-needs-to-be-__meminit.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:13 -0700
Message-ID: <200705120515.l4C5FDlk001737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308AbXELFPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     early_pfn_to_nid needs to be __meminit
has been removed from the -mm tree.  Its filename was
     early_pfn_to_nid-needs-to-be-__meminit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: early_pfn_to_nid needs to be __meminit
From: Stephen Rothwell <sfr@canb.auug.org.au>

Since it is referenced by memmap_init_zone (which is __meminit) via the
early_pfn_in_nid macro when CONFIG_NODES_SPAN_OTHER_NODES is set (which
basically means PowerPC 64).

This removes a section mismatch warning in those circumstances.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~early_pfn_to_nid-needs-to-be-__meminit mm/page_alloc.c
--- a/mm/page_alloc.c~early_pfn_to_nid-needs-to-be-__meminit
+++ a/mm/page_alloc.c
@@ -2284,7 +2284,7 @@ static int __meminit next_active_region_
  * was used and there are no special requirements, this is a convenient
  * alternative
  */
-int __init early_pfn_to_nid(unsigned long pfn)
+int __meminit early_pfn_to_nid(unsigned long pfn)
 {
 	int i;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
consolidate-asm-pollh.patch
missing-include-file-in-tpm_atmelh.patch
maintainers-remove-invalid-list-address-for-tpm.patch
powerpc64-symbols-start-with.patch
