From: akpm@osdl.org
Subject: - fdtable-implement-new-pagesize-based-fdtable-allocator-fix.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:29:39 -0800
Message-ID: <200612100829.kBA8TdH9018896@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760449AbWLJI3m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:29:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlobanov@speakeasy.net, mm-commits@vger.kernel.org


The patch titled
     Potential fix for fdtable badness
has been removed from the -mm tree.  Its filename was
     fdtable-implement-new-pagesize-based-fdtable-allocator-fix.patch

This patch was dropped because it was folded into fdtable-implement-new-pagesize-based-fdtable-allocator.patch

------------------------------------------------------
Subject: Potential fix for fdtable badness
From: Vadim Lobanov <vlobanov@speakeasy.net>

Fix the computation of the length of an allocated fdarray, when we decide to
grow the fdtable. The rationale behind this fix is as follows:
=> The 'nr' variable is the requested fd, so will be one less than the minimum
   allowable fdarray size.
=> Due to the above fact, when we divide 'nr' by a fourth-of-a-page block, we
   will always be exactly one block short of the size we need.
=> Incrementing before the division is wrong, because the division will discard
   a non-zero modulo, possibly leaving us one fourth-of-a-page block short.

Signed-off-by: Vadim Lobanov <vlobanov@speakeasy.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/file.c~fdtable-implement-new-pagesize-based-fdtable-allocator-fix fs/file.c
--- a/fs/file.c~fdtable-implement-new-pagesize-based-fdtable-allocator-fix
+++ a/fs/file.c
@@ -144,9 +144,8 @@ static struct fdtable * alloc_fdtable(un
 	 * the fdarray into page-sized chunks: starting at a quarter of a page,
 	 * and growing in powers of two from there on.
 	 */
-	nr++;
 	nr /= (PAGE_SIZE / 4 / sizeof(struct file *));
-	nr = roundup_pow_of_two(nr);
+	nr = roundup_pow_of_two(nr + 1);
 	nr *= (PAGE_SIZE / 4 / sizeof(struct file *));
 	if (nr > NR_OPEN)
 		nr = NR_OPEN;
_

Patches currently in -mm which might be from vlobanov@speakeasy.net are

fdtable-delete-pointless-code-in-dup_fd.patch
fdtable-make-fdarray-and-fdsets-equal-in-size.patch
fdtable-remove-the-free_files-field.patch
fdtable-implement-new-pagesize-based-fdtable-allocator.patch
fdtable-implement-new-pagesize-based-fdtable-allocator-fix.patch
fdtable-implement-new-pagesize-based-fdtable-allocator-bound-minimum-allocation-size.patch
fdtable-implement-new-pagesize-based-fdtable-allocator-avoid-fdset-cacheline-ping-pong.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch

