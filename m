From: akpm@linux-foundation.org
Subject: + xen-relax-signature-check.patch added to -mm tree
Date: Mon, 10 Dec 2007 16:06:53 -0800
Message-ID: <200712110006.lBB06rAh025913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbXLKAG5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 19:06:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com


The patch titled
     xen: relax signature check
has been added to the -mm tree.  Its filename is
     xen-relax-signature-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen: relax signature check
From: Jeremy Fitzhardinge <jeremy@goop.org>

Some versions of Xen 3.x set their magic number to "xen-3.[12]", so relax
the test to match them.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/enlighten.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/xen/enlighten.c~xen-relax-signature-check arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~xen-relax-signature-check
+++ a/arch/x86/xen/enlighten.c
@@ -1131,7 +1131,7 @@ asmlinkage void __init xen_start_kernel(
 	if (!xen_start_info)
 		return;
 
-	BUG_ON(memcmp(xen_start_info->magic, "xen-3.0", 7) != 0);
+	BUG_ON(memcmp(xen_start_info->magic, "xen-3", 5) != 0);
 
 	/* Install Xen paravirt ops */
 	pv_info = xen_info;
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-relax-signature-check.patch
git-x86.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-kpagecount-interface.patch
