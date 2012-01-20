From: akpm@linux-foundation.org
Subject: + mm-percpu-vmc-use-bitmap_clear.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:13:40 -0800
Message-ID: <20120120231340.EBBED5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:54096 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab2ATXNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:13:43 -0500
Received: by wgbdr1 with SMTP id dr1so39269wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:13:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, cl@linux-foundation.org, tj@kernel.org


The patch titled
     Subject: mm/percpu-vm.c: use bitmap_clear()
has been added to the -mm tree.  Its filename is
     mm-percpu-vmc-use-bitmap_clear.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm/percpu-vm.c: use bitmap_clear()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

mm-percpu-vmc-use-bitmap_clear.patch
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

