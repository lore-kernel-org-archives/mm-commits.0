From: akpm@linux-foundation.org
Subject: - xen-mask-_page_pcd-from-ptes.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:20:57 -0800
Message-ID: <200712010020.lB10KvNe031725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756185AbXLAAVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:21:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen: mask _PAGE_PCD from ptes
has been removed from the -mm tree.  Its filename was
     xen-mask-_page_pcd-from-ptes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xen: mask _PAGE_PCD from ptes
From: Jeremy Fitzhardinge <jeremy@goop.org>

_PAGE_PCD maps a page with caching disabled, which is typically used for
mapping harware registers.  Xen never allows it to be set on a mapping, and
unprivileged guests never need it since they can't see the real underlying
hardware.  However, some uncached mappings are made early when probing the
(non-existent) APIC, and its OK to mask off the PCD flag in these cases.

This became necessary because Xen started checking for this bit, rather
than silently masking it off.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/x86/xen/mmu.c~xen-mask-_page_pcd-from-ptes arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~xen-mask-_page_pcd-from-ptes
+++ a/arch/x86/xen/mmu.c
@@ -244,6 +244,8 @@ pte_t xen_make_pte(unsigned long long pt
 	if (pte & 1)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
 
+	pte &= ~_PAGE_PCD;
+
 	return (pte_t){ pte, pte >> 32 };
 }
 
@@ -291,6 +293,8 @@ pte_t xen_make_pte(unsigned long pte)
 	if (pte & _PAGE_PRESENT)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
 
+	pte &= ~_PAGE_PCD;
+
 	return (pte_t){ pte };
 }
 
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
git-x86.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-kpagecount-interface.patch
