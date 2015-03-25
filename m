From: akpm@linux-foundation.org
Subject: +
 zsmalloc-fix-fatal-corruption-due-to-wrong-size-class-selection.patch added to -mm tree
Date: Wed, 25 Mar 2015 14:13:26 -0700
Message-ID: <551324f6.vg5v5pEy0WApdLs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbbCYVN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heesub.shin@samsung.com, minchan@kernel.org, s.suk@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix fatal corruption due to wrong size class selection
has been added to the -mm tree.  Its filename is
     zsmalloc-fix-fatal-corruption-due-to-wrong-size-class-selection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-fix-fatal-corruption-due-to-wrong-size-class-selection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-fix-fatal-corruption-due-to-wrong-size-class-selection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heesub Shin <heesub.shin@samsung.com>
Subject: zsmalloc: fix fatal corruption due to wrong size class selection

There is no point in overriding the size class below.  It causes fatal
corruption on the next chunk on the 3264-bytes size class, which is the
last size class that is not huge.

For example, if the requested size was exactly 3264 bytes, current
zsmalloc allocates and returns a chunk from the size class of 3264 bytes,
not 4096.  User access to this chunk may overwrite head of the next
adjacent chunk.

Here is the panic log captured when freelist was corrupted due to this:

    Kernel BUG at ffffffc00030659c [verbose debug info unavailable]
    Internal error: Oops - BUG: 96000006 [#1] PREEMPT SMP
    Modules linked in:
    exynos-snapshot: core register saved(CPU:5)
    CPUMERRSR: 0000000000000000, L2MERRSR: 0000000000000000
    exynos-snapshot: context saved(CPU:5)
    exynos-snapshot: item - log_kevents is disabled
    CPU: 5 PID: 898 Comm: kswapd0 Not tainted 3.10.61-4497415-eng #1
    task: ffffffc0b8783d80 ti: ffffffc0b71e8000 task.ti: ffffffc0b71e8000
    PC is at obj_idx_to_offset+0x0/0x1c
    LR is at obj_malloc+0x44/0xe8
    pc : [<ffffffc00030659c>] lr : [<ffffffc000306604>] pstate: a0000045
    sp : ffffffc0b71eb790
    x29: ffffffc0b71eb790 x28: ffffffc00204c000
    x27: 000000000001d96f x26: 0000000000000000
    x25: ffffffc098cc3500 x24: ffffffc0a13f2810
    x23: ffffffc098cc3501 x22: ffffffc0a13f2800
    x21: 000011e1a02006e3 x20: ffffffc0a13f2800
    x19: ffffffbc02a7e000 x18: 0000000000000000
    x17: 0000000000000000 x16: 0000000000000feb
    x15: 0000000000000000 x14: 00000000a01003e3
    x13: 0000000000000020 x12: fffffffffffffff0
    x11: ffffffc08b264000 x10: 00000000e3a01004
    x9 : ffffffc08b263fea x8 : ffffffc0b1e611c0
    x7 : ffffffc000307d24 x6 : 0000000000000000
    x5 : 0000000000000038 x4 : 000000000000011e
    x3 : ffffffbc00003e90 x2 : 0000000000000cc0
    x1 : 00000000d0100371 x0 : ffffffbc00003e90

Reported-by: Sooyong Suk <s.suk@samsung.com>
Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
Tested-by: Sooyong Suk <s.suk@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-fatal-corruption-due-to-wrong-size-class-selection mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-fatal-corruption-due-to-wrong-size-class-selection
+++ a/mm/zsmalloc.c
@@ -1398,11 +1398,6 @@ unsigned long zs_malloc(struct zs_pool *
 	/* extra space in chunk to keep the handle */
 	size += ZS_HANDLE_SIZE;
 	class = pool->size_class[get_size_class_index(size)];
-	/* In huge class size, we store the handle into first_page->private */
-	if (class->huge) {
-		size -= ZS_HANDLE_SIZE;
-		class = pool->size_class[get_size_class_index(size)];
-	}
 
 	spin_lock(&class->lock);
 	first_page = find_get_zspage(class);
_

Patches currently in -mm which might be from heesub.shin@samsung.com are

zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch
zsmalloc-fix-fatal-corruption-due-to-wrong-size-class-selection.patch

