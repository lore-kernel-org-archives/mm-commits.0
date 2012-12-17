From: akpm@linux-foundation.org
Subject: [folded-merged] scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:52:07 -0800
Message-ID: <20121217235208.4680982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35201 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2LQX7e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:59:34 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so721616vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:59:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, maximlevitsky@gmail.com, nbowler@elliptictech.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix
has been removed from the -mm tree.  Its filename was
     scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch

This patch was dropped because it was folded into scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix

s/E2BIG/EINVAL/

Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/scatterlist.c~scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix
+++ a/lib/scatterlist.c
@@ -249,7 +249,7 @@ int __sg_alloc_table(struct sg_table *ta
 
 #ifndef ARCH_HAS_SG_CHAIN
 	if (WARN_ON_ONCE(nents > max_ents))
-		return -E2BIG;
+		return -EINVAL;
 #endif
 
 	memset(table, 0, sizeof(*table));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error.patch

