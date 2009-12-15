From: akpm@linux-foundation.org
Subject: [folded] dev-mem-remove-the-written-variable-in-write_kmem-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 16:56:52 -0800
Message-ID: <200912150056.nBF0uquv017383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757449AbZLOA4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 19:56:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     dev-mem-remove-the-written-variable-in-write_kmem-fix
has been removed from the -mm tree.  Its filename was
     dev-mem-remove-the-written-variable-in-write_kmem-fix.patch

This patch was dropped because it was folded into dev-mem-remove-the-written-variable-in-write_kmem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dev-mem-remove-the-written-variable-in-write_kmem-fix
From: Wu Fengguang <fengguang.wu@intel.com>

> @@ -547,20 +541,20 @@ static ssize_t write_kmem(struct file *
>  		if (!kbuf)
>  			return wrote ? wrote : -ENOMEM;
>  		while (count > 0) {
> -			int len = size_inside_page(p, count);
> +			unsigned long sz = size_inside_page(p, count);
>
> -			written = copy_from_user(kbuf, buf, len);
> -			if (written) {
> +			sz = copy_from_user(kbuf, buf, sz);

Sorry, it introduced a bug: the "sz" will be zero in normal,

> +			if (sz) {
>  				if (wrote + virtr)
>  					break;
>  				free_page((unsigned long)kbuf);
>  				return -EFAULT;
>  			}
> -			len = vwrite(kbuf, (char *)p, len);
> +			sz = vwrite(kbuf, (char *)p, sz);

and get passed to vwrite here.

This patch fixes it, the new var "n" will be used in another bug
fixing patch following this one.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-remove-the-written-variable-in-write_kmem-fix drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-remove-the-written-variable-in-write_kmem-fix
+++ a/drivers/char/mem.c
@@ -540,9 +540,10 @@ static ssize_t write_kmem(struct file * 
 			return wrote ? wrote : -ENOMEM;
 		while (count > 0) {
 			unsigned long sz = size_inside_page(p, count);
+			unsigned long n;
 
-			sz = copy_from_user(kbuf, buf, sz);
-			if (sz) {
+			n = copy_from_user(kbuf, buf, sz);
+			if (n) {
 				if (wrote + virtr)
 					break;
 				free_page((unsigned long)kbuf);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
page-types-constify-read-only-arrays.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
page-types-learn-to-describe-flags-directly-from-command-line.patch
page-types-whitespace-alignment.patch
page-types-exit-early-when-invoked-with-d-describe.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch
rmap-move-the-out-to-a-more-proper-place.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
vmscan-simplify-code.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
mm-hugetlb-add-hugepage-support-to-pagemap-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch

