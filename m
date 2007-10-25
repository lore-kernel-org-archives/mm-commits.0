From: akpm@linux-foundation.org
Subject: + mm-sparse-vmemmapc-make-sure-init_mm-is-included.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:13:16 -0700
Message-ID: <200710250413.l9P4DGIl031188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbXJYENb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:13:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com


The patch titled
     mm/sparse-vmemmap.c: make sure init_mm is included
has been added to the -mm tree.  Its filename is
     mm-sparse-vmemmapc-make-sure-init_mm-is-included.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/sparse-vmemmap.c: make sure init_mm is included
From: Glauber de Oliveira Costa <gcosta@redhat.com>

mm/sparse-vmemmap.c uses init_mm in some places.  However, it is not
present in any of the headers currently included in the file.

init_mm is defined as extern in sched.h, so we add it to the headers list

Up to now, this problem was masked by the fact that functions like
set_pte_at() and pmd_populate_kernel() are usually macros that expand to
simpler variants that does not use the first parameter at all.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/sparse-vmemmap.c~mm-sparse-vmemmapc-make-sure-init_mm-is-included mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmapc-make-sure-init_mm-is-included
+++ a/mm/sparse-vmemmap.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
+#include <linux/sched.h>
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
_

Patches currently in -mm which might be from gcosta@redhat.com are

mm-sparse-vmemmapc-make-sure-init_mm-is-included.patch
git-kvm.patch
