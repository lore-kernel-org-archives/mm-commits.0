From: akpm@linux-foundation.org
Subject: +
 lib-scatterlistc-dont-flush_kernel_dcache_page-on-slab-page.patch added to
 -mm tree
Date: Thu, 31 Oct 2013 15:27:54 -0700
Message-ID: <5272d96a.qnNitb/2+dabAgxm%akpm__9980.63896918229$1383258488$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3JaW1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 18:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, tj@kernel.org, stable@vger.kernel.org, linux@arm.linux.org.uk, gmbnomis@gmail.com, fujita.tomonori@lab.ntt.co.jp, catalin.marinas@arm.com, axboe@kernel.dk, aaro.koskinen@iki.fi, JBottomley@parallels.com, ming.lei@canonical.com

Subject: + lib-scatterlistc-dont-flush_kernel_dcache_page-on-slab-page.patch added to -mm tree
To: ming.lei@canonical.com,JBottomley@parallels.com,aaro.koskinen@iki.fi,axboe@kernel.dk,catalin.marinas@arm.com,fujita.tomonori@lab.ntt.co.jp,gmbnomis@gmail.com,linux@arm.linux.org.uk,stable@vger.kernel.org,tj@kernel.org,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 15:27:54 -0700


The patch titled
     Subject: lib/scatterlist.c: don't flush_kernel_dcache_page on slab page
has been added to the -mm tree.  Its filename is
     lib-scatterlistc-dont-flush_kernel_dcache_page-on-slab-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlistc-dont-flush_kernel_dcache_page-on-slab-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlistc-dont-flush_kernel_dcache_page-on-slab-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: lib/scatterlist.c: don't flush_kernel_dcache_page on slab page

b1adaf65ba03 ("[SCSI] block: add sg buffer copy helper functions")
introduces two sg buffer copy helpers, and calls
flush_kernel_dcache_page() on pages in SG list after these pages are
written to.

Unfortunately, the commit may introduce a potential bug:

	- Before sending some SCSI commands, kmalloc() buffer may be
	passed to block layper, so flush_kernel_dcache_page() can
	see a slab page finally

	- According to cachetlb.txt, flush_kernel_dcache_page() is
	only called on "a user page", which surely can't be a slab page.

	- ARCH's implementation of flush_kernel_dcache_page() may
	use page mapping information to do optimization so page_mapping()
	will see the slab page, then VM_BUG_ON() is triggered.

Aaro Koskinen reported the bug on ARM/kirkwood when DEBUG_VM is enabled,
and this patch fixes the bug by adding test of '!PageSlab(miter->page)'
before calling flush_kernel_dcache_page().

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Simon Baatz <gmbnomis@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/scatterlist.c~lib-scatterlistc-dont-flush_kernel_dcache_page-on-slab-page lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlistc-dont-flush_kernel_dcache_page-on-slab-page
+++ a/lib/scatterlist.c
@@ -577,7 +577,8 @@ void sg_miter_stop(struct sg_mapping_ite
 		miter->__offset += miter->consumed;
 		miter->__remaining -= miter->consumed;
 
-		if (miter->__flags & SG_MITER_TO_SG)
+		if ((miter->__flags & SG_MITER_TO_SG) &&
+		    !PageSlab(miter->page))
 			flush_kernel_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {
_

Patches currently in -mm which might be from ming.lei@canonical.com are

lib-scatterlistc-dont-flush_kernel_dcache_page-on-slab-page.patch
linux-next.patch

