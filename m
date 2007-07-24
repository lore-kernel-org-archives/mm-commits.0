From: akpm@linux-foundation.org
Subject: + xen-xen-pageh-compile-fix.patch added to -mm tree
Date: Tue, 24 Jul 2007 15:18:46 -0700
Message-ID: <200707242218.l6OMIkEh003805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756935AbXGXWTD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 18:19:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com


The patch titled
     xen: xen/page.h compile fix
has been added to the -mm tree.  Its filename is
     xen-xen-pageh-compile-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen: xen/page.h compile fix
From: Jeremy Fitzhardinge <jeremy@goop.org>

Fix:
linux/include/xen/page.h: In function mfn_pte:
linux/include/xen/page.h:149: error: __supported_pte_mask undeclared (first use in this function)
linux/include/xen/page.h:149: error: (Each undeclared identifier is reported only once
linux/include/xen/page.h:149: error: for each function it appears in.)

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/xen/page.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/xen/page.h~xen-xen-pageh-compile-fix include/xen/page.h
--- a/include/xen/page.h~xen-xen-pageh-compile-fix
+++ a/include/xen/page.h
@@ -4,6 +4,7 @@
 #include <linux/pfn.h>
 
 #include <asm/uaccess.h>
+#include <asm/pgtable.h>
 
 #include <xen/features.h>
 
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-xen-pageh-compile-fix.patch
acpiphp_ibm-add-missing-n.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fix-the-softlockup-watchdog-to-actually-work.patch
