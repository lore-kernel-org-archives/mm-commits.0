From: akpm@linux-foundation.org
Subject: + xen-mask-_page_pcd-from-ptes.patch added to -mm tree
Date: Fri, 16 Nov 2007 13:58:40 -0800
Message-ID: <200711162158.lAGLweFV005689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757077AbXKPV6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 16:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com


The patch titled
     xen: mask _PAGE_PCD from ptes
has been added to the -mm tree.  Its filename is
     xen-mask-_page_pcd-from-ptes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
xen-mask-_page_pcd-from-ptes.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-kpagecount-interface.patch
