From: akpm@osdl.org
Subject: - fdtable-implement-new-pagesize-based-fdtable-allocator-bound-minimum-allocation-size.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:29:44 -0800
Message-ID: <200612100829.kBA8TiWu018900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760466AbWLJI3t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:29:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlobanov@speakeasy.net, mm-commits@vger.kernel.org


The patch titled
     fdtable: Bound minimum allocation size.
has been removed from the -mm tree.  Its filename was
     fdtable-implement-new-pagesize-based-fdtable-allocator-bound-minimum-allocation-size.patch

This patch was dropped because it was folded into fdtable-implement-new-pagesize-based-fdtable-allocator.patch

------------------------------------------------------
Subject: fdtable: Bound minimum allocation size.
From: Vadim Lobanov <vlobanov@speakeasy.net>

This patch modifies the fdtable minimum allocation unit, setting it to a
fixed size of 1024 bytes instead of basing it on the architecture page
size.  This leaves the algorithm heuristics unchanged for the common 4K
page size, but does rebalance the "memory wasted versus number of
reallocations" tradeoff for architectures with larger page sizes (like
64K).

Signed-off-by: Vadim Lobanov <vlobanov@speakeasy.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/file.c~fdtable-implement-new-pagesize-based-fdtable-allocator-bound-minimum-allocation-size fs/file.c
--- a/fs/file.c~fdtable-implement-new-pagesize-based-fdtable-allocator-bound-minimum-allocation-size
+++ a/fs/file.c
@@ -141,12 +141,12 @@ static struct fdtable * alloc_fdtable(un
 	 * Figure out how many fds we actually want to support in this fdtable.
 	 * Allocation steps are keyed to the size of the fdarray, since it
 	 * grows far faster than any of the other dynamic data. We try to fit
-	 * the fdarray into page-sized chunks: starting at a quarter of a page,
+	 * the fdarray into comfortable page-tuned chunks: starting at 1024B
 	 * and growing in powers of two from there on.
 	 */
-	nr /= (PAGE_SIZE / 4 / sizeof(struct file *));
+	nr /= (1024 / sizeof(struct file *));
 	nr = roundup_pow_of_two(nr + 1);
-	nr *= (PAGE_SIZE / 4 / sizeof(struct file *));
+	nr *= (1024 / sizeof(struct file *));
 	if (nr > NR_OPEN)
 		nr = NR_OPEN;
 
_

Patches currently in -mm which might be from vlobanov@speakeasy.net are

fdtable-delete-pointless-code-in-dup_fd.patch
fdtable-make-fdarray-and-fdsets-equal-in-size.patch
fdtable-remove-the-free_files-field.patch
fdtable-implement-new-pagesize-based-fdtable-allocator.patch
fdtable-implement-new-pagesize-based-fdtable-allocator-bound-minimum-allocation-size.patch
fdtable-implement-new-pagesize-based-fdtable-allocator-avoid-fdset-cacheline-ping-pong.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch

