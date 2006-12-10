From: akpm@osdl.org
Subject: - fdtable-implement-new-pagesize-based-fdtable-allocator-avoid-fdset-cacheline-ping-pong.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:29:47 -0800
Message-ID: <200612100829.kBA8TlcH018903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760475AbWLJI3t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:29:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlobanov@speakeasy.net, mm-commits@vger.kernel.org


The patch titled
     fdtable: Avoid fdset cacheline ping-pong.
has been removed from the -mm tree.  Its filename was
     fdtable-implement-new-pagesize-based-fdtable-allocator-avoid-fdset-cacheline-ping-pong.patch

This patch was dropped because it was folded into fdtable-implement-new-pagesize-based-fdtable-allocator.patch

------------------------------------------------------
Subject: fdtable: Avoid fdset cacheline ping-pong.
From: Vadim Lobanov <vlobanov@speakeasy.net>

This is a performance optimization for the fdtable code.  When expanding
the fdtable for a task, we want to allocate at least L1_CACHE_BYTES for the
new fdset memory -- this will ensure that the fdsets of two different tasks
will not share the same cacheline, causing lots of cacheline ping-pongs.

Signed-off-by: Vadim Lobanov <vlobanov@speakeasy.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/file.c~fdtable-implement-new-pagesize-based-fdtable-allocator-avoid-fdset-cacheline-ping-pong fs/file.c
--- a/fs/file.c~fdtable-implement-new-pagesize-based-fdtable-allocator-avoid-fdset-cacheline-ping-pong
+++ a/fs/file.c
@@ -158,7 +158,8 @@ static struct fdtable * alloc_fdtable(un
 	if (!data)
 		goto out_fdt;
 	fdt->fd = (struct file **)data;
-	data = alloc_fdmem(2 * nr / BITS_PER_BYTE);
+	data = alloc_fdmem(max_t(unsigned int,
+				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
 	if (!data)
 		goto out_arr;
 	fdt->open_fds = (fd_set *)data;
_

Patches currently in -mm which might be from vlobanov@speakeasy.net are

fdtable-delete-pointless-code-in-dup_fd.patch
fdtable-make-fdarray-and-fdsets-equal-in-size.patch
fdtable-remove-the-free_files-field.patch
fdtable-implement-new-pagesize-based-fdtable-allocator.patch
fdtable-implement-new-pagesize-based-fdtable-allocator-avoid-fdset-cacheline-ping-pong.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch

