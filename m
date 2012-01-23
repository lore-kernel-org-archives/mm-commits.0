From: akpm@linux-foundation.org
Subject: [merged] mm-percpu-vmc-use-bitmap_clear.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:22:07 -0800
Message-ID: <20120123202208.245875C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37643 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab2AWUWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:22:10 -0500
Received: by eekb15 with SMTP id b15so139869eek.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:22:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, cl@linux-foundation.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu-vm.c: use bitmap_clear()
has been removed from the -mm tree.  Its filename was
     mm-percpu-vmc-use-bitmap_clear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/percpu-vm.c: use bitmap_clear()

Use bitmap_clear() rather than clearing individual bits in a memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-vm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/percpu-vm.c~mm-percpu-vmc-use-bitmap_clear mm/percpu-vm.c
--- a/mm/percpu-vm.c~mm-percpu-vmc-use-bitmap_clear
+++ a/mm/percpu-vm.c
@@ -184,8 +184,7 @@ static void pcpu_unmap_pages(struct pcpu
 				   page_end - page_start);
 	}
 
-	for (i = page_start; i < page_end; i++)
-		__clear_bit(i, populated);
+	bitmap_clear(populated, page_start, page_end - page_start);
 }
 
 /**
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
drivers-scsi-hpsac-use-find_first_zero_bit.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
sysctl-use-bitmap-library-functions.patch

