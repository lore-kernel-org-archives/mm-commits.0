From: akpm@linux-foundation.org
Subject: + zsmalloc-expand-class-bit.patch added to -mm tree
Date: Thu, 13 Apr 2017 13:29:30 -0700
Message-ID: <58efdfaa.rRl65UXPv9xLIXmp%akpm__4955.20501067421$1492115378$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755261AbdDMU3d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 16:29:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: expand class bit
has been added to the -mm tree.  Its filename is
     zsmalloc-expand-class-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-expand-class-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-expand-class-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: expand class bit

Now 64K page system, zsamlloc has 257 classes so 8 class bit is not
enough.  With that, it corrupts the system when zsmalloc stores 65536byte
data(ie, index number 256) so that this patch increases class bit for
simple fix for stable backport.  We should clean up this mess soon.

index	size
0	32
1	288
..
..
204	52256
256	65536

Fixes: 3783689a1 ("zsmalloc: introduce zspage structure")
Link: http://lkml.kernel.org/r/1492042622-12074-3-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-expand-class-bit mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-expand-class-bit
+++ a/mm/zsmalloc.c
@@ -276,7 +276,7 @@ struct zs_pool {
 struct zspage {
 	struct {
 		unsigned int fullness:FULLNESS_BITS;
-		unsigned int class:CLASS_BITS;
+		unsigned int class:CLASS_BITS + 1;
 		unsigned int isolated:ISOLATED_BITS;
 		unsigned int magic:MAGIC_VAL_BITS;
 	};
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-operator-precedence-to-get-offset.patch
zram-do-not-use-copy_page-with-non-page-alinged-address.patch
zsmalloc-expand-class-bit.patch
mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-make-the-try_to_munlock-void-function-fix.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch
mm-remove-swap_-fix.patch
zram-handle-multiple-pages-attached-bios-bvec.patch
zram-partial-io-refactoring.patch
zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op.patch
zram-remove-zram_meta-structure.patch
zram-introduce-zram-data-accessor.patch
zram-use-zram_free_page-instead-of-open-coded.patch

