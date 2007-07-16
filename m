From: akpm@linux-foundation.org
Subject: - nommu-stub-expand_stack-for-nommu-case.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:11 -0700
Message-ID: <200707162050.l6GKoBuh001299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759733AbXGPVa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, dhowells@redhat.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     nommu: stub expand_stack() for nommu case
has been removed from the -mm tree.  Its filename was
     nommu-stub-expand_stack-for-nommu-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 5 insertions(+)

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

origin.patch
git-mtd.patch
