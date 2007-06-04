From: akpm@linux-foundation.org
Subject: + nommu-stub-expand_stack-for-nommu-case.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:05:03 -0700
Message-ID: <200706042005.l54K56Ds015879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760181AbXFDUF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:05:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, dhowells@redhat.com, gerg@uclinux.org


The patch titled
     nommu: stub expand_stack() for nommu case
has been added to the -mm tree.  Its filename is
     nommu-stub-expand_stack-for-nommu-case.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nommu: stub expand_stack() for nommu case
From: Greg Ungerer <gerg@snapgear.com>

Be consistent with VM mmap, implement expand_stack().  We can't actually do
anything other than return an error in the no MMU case though.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN mm/nommu.c~nommu-stub-expand_stack-for-nommu-case mm/nommu.c
--- a/mm/nommu.c~nommu-stub-expand_stack-for-nommu-case
+++ a/mm/nommu.c
@@ -367,6 +367,11 @@ struct vm_area_struct *find_extend_vma(s
 	return find_vma(mm, addr);
 }
 
+int expand_stack(struct vm_area_struct *vma, unsigned long address)
+{
+	return -ENOMEM;
+}
+
 /*
  * look up the first VMA exactly that exactly matches addr
  * - should be called with mm->mmap_sem at least held readlocked
_

Patches currently in -mm which might be from gerg@snapgear.com are

drivers-mtd-maps-nettelc-possible-cleanups.patch
m68knommu-fix-coldfire-timer-off-by-1.patch
nommu-stub-expand_stack-for-nommu-case.patch
m68knommu-use-trhead_size-instead-of-hard-constant.patch
m68knommu-remove-cruft-from-setup-code.patch
m68knommu-remove-old-cache-management-cruft-from-mm-code.patch
nommu-report-correct-errno-in-message.patch
