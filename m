From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-change-mm-debug-routines-back-to-export_symbol.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:00:13 -0700
Message-ID: <5344635d.ESIMMuqGkDUte0q1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHVAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, jwboyer@redhat.com, jhubbard@nvidia.com

Subject: [merged] mm-page_allocc-change-mm-debug-routines-back-to-export_symbol.patch removed from -mm tree
To: jhubbard@nvidia.com,jwboyer@redhat.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:00:13 -0700


The patch titled
     Subject: mm/page_alloc.c: change mm debug routines back to EXPORT_SYMBOL
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-change-mm-debug-routines-back-to-export_symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/page_alloc.c: change mm debug routines back to EXPORT_SYMBOL

A new dump_page() routine was recently added, and marked
EXPORT_SYMBOL_GPL.  dump_page() was also added to the VM_BUG_ON_PAGE()
macro, and so the end result is that non-GPL code can no longer call
get_page() and a few other routines.

This only happens if the kernel was compiled with CONFIG_DEBUG_VM.

Change dump_page() to be EXPORT_SYMBOL.

Longer explanation:

Prior to 309381feaee564 ("mm: dump page when hitting a VM_BUG_ON using
VM_BUG_ON_PAGE") , it was possible to build MIT-licensed (non-GPL) drivers
on Fedora.  Fedora is semi-unique, in that it sets CONFIG_VM_DEBUG.

Because Fedora sets CONFIG_VM_DEBUG, they end up pulling in dump_page(),
via VM_BUG_ON_PAGE, via get_page().  As one of the authors of NVIDIA's
new, open source, "UVM-Lite" kernel module, I originally choose to use the
kernel's get_page() routine from within nvidia_uvm_page_cache.c, because
get_page() has always seemed to be very clearly intended for use by
non-GPL, driver code.

So I'm hoping that making get_page() widely accessible again will not be
too controversial.  We did check with Fedora first, and they responded
(https://bugzilla.redhat.com/show_bug.cgi?id=1074710#c3) that we should
try to get upstream changed, before asking Fedora to change.  Their
reasoning seems beneficial to Linux: leaving CONFIG_DEBUG_VM set allows
Fedora to help catch mm bugs.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Josh Boyer <jwboyer@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-change-mm-debug-routines-back-to-export_symbol mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-change-mm-debug-routines-back-to-export_symbol
+++ a/mm/page_alloc.c
@@ -6566,4 +6566,4 @@ void dump_page(struct page *page, const
 {
 	dump_page_badflags(page, reason, 0);
 }
-EXPORT_SYMBOL_GPL(dump_page);
+EXPORT_SYMBOL(dump_page);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

origin.patch

