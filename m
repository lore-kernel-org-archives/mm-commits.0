From: akpm@linux-foundation.org
Subject: [merged] mm-actually-remap-enough-memory.patch removed from -mm
 tree
Date: Fri, 13 Feb 2015 12:21:03 -0800
Message-ID: <54de5caf.4kWRb+HDOkZgtP7g%akpm__17301.3523839929$1423858868$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbbBMUVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: notasas@gmail.com, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: actually remap enough memory
has been removed from the -mm tree.  Its filename was
     mm-actually-remap-enough-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Grazvydas Ignotas <notasas@gmail.com>
Subject: mm/memory.c: actually remap enough memory

For whatever reason, generic_access_phys() only remaps one page, but
actually allows to access arbitrary size.  It's quite easy to trigger
large reads, like printing out large structure with gdb, which leads to a
crash.  Fix it by remapping correct size.

Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-actually-remap-enough-memory mm/memory.c
--- a/mm/memory.c~mm-actually-remap-enough-memory
+++ a/mm/memory.c
@@ -3462,7 +3462,7 @@ int generic_access_phys(struct vm_area_s
 	if (follow_phys(vma, addr, write, &prot, &phys_addr))
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
+	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
 	if (write)
 		memcpy_toio(maddr + offset, buf, len);
 	else
_

Patches currently in -mm which might be from notasas@gmail.com are

origin.patch

