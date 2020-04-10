From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-mmap-initialize-align_offset-explicitly-for-vm_unmapped_area.patch added
 to -mm tree
Date: Thu, 09 Apr 2020 21:55:53 -0700
Message-ID: <20200410045553.t-cezSAeg%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgDJEzz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 00:55:55 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@suse.de, jaewon31.kim@samsung.com, mm-commits@vger.kernel.org, walken@google.com, willy@infradead.org


The patch titled
     Subject: mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area
has been added to the -mm tree.  Its filename is
     mm-mmap-initialize-align_offset-explicitly-for-vm_unmapped_area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-initialize-align_offset-explicitly-for-vm_unmapped_area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-initialize-align_offset-explicitly-for-vm_unmapped_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area

On passing requirement to vm_unmapped_area, arch_get_unmapped_area and
arch_get_unmapped_area_topdown did not set align_offset.  Internally on
both unmapped_area and unmapped_area_topdown, if info->align_mask is 0,
then info->align_offset was meaningless.

But commit df529cabb7a2 ("mm: mmap: add trace point of vm_unmapped_area")
always prints info->align_offset even though it is uninitialized.  Fix
this uninitialized value issue by setting it to 0 explicitly.

Before
92.291104: vm_unmapped_area: addr=0x755b155000 err=0 total_vm=0x15aaf0 flags=0x1 len=0x109000 lo=0x8000 hi=0x75eed48000 mask=0x0 ofs=0x4022

After
68.584210: vm_unmapped_area: addr=0x74a4ca1000 err=0 total_vm=0x168ab1 flags=0x1 len=0x9000 lo=0x8000 hi=0x753d94b000 mask=0x0 ofs=0x0

Link: http://lkml.kernel.org/r/20200409094035.19457-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mmap.c~mm-mmap-initialize-align_offset-explicitly-for-vm_unmapped_area
+++ a/mm/mmap.c
@@ -2138,6 +2138,7 @@ arch_get_unmapped_area(struct file *filp
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_end;
 	info.align_mask = 0;
+	info.align_offset = 0;
 	return vm_unmapped_area(&info);
 }
 #endif
@@ -2179,6 +2180,7 @@ arch_get_unmapped_area_topdown(struct fi
 	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.align_mask = 0;
+	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
 
 	/*
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

mm-mmap-initialize-align_offset-explicitly-for-vm_unmapped_area.patch
