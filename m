Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0245AC4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 01:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjK2BkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Nov 2023 20:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjK2BkZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2023 20:40:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24D8198D
        for <mm-commits@vger.kernel.org>; Tue, 28 Nov 2023 17:40:31 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FBDC433C7;
        Wed, 29 Nov 2023 01:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701222031;
        bh=vk1GimauotcvclsfAjyZA+PXWn5D5Qy1HTAlW8WsXzs=;
        h=Date:To:From:Subject:From;
        b=seGuCzYnRg278X2L/YvG8ZwKLTxqwDSw+Hwb7DXBJwJL5/+nobtIJovnERmiqr1Kc
         0uVNZzICwkol4833XLfGgkxg36F6H/RTkVSETvh4BB4scOPZSpd4pKB5wQSFgKT+3l
         o+C01GqUgX2B+MzTDabbteNO939bKLVh2Tye4Kjo=
Date:   Tue, 28 Nov 2023 17:40:30 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naresh.kamboju@linaro.org, nathan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-fix-grow_buffers-for-block-size-page_size-fix.patch added to mm-unstable branch
Message-Id: <20231129014031.32FBDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: add cast in grow_buffers() to avoid a multiplication libcall
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: buffer: add cast in grow_buffers() to avoid a multiplication libcall
Date: Tue, 28 Nov 2023 16:55:43 -0700

When building with clang after commit 697607935295 ("buffer: fix
grow_buffers() for block size > PAGE_SIZE"), there is an error at link
time due to the generation of a 128-bit multiplication libcall:

  ld.lld: error: undefined symbol: __muloti4
  >>> referenced by buffer.c:0 (fs/buffer.c:0)
  >>>               fs/buffer.o:(bdev_getblk) in archive vmlinux.a

Due to the width mismatch between the factors and the sign mismatch
between the factors and the result, clang generates IR that performs
this overflow check with 65-bit signed multiplication and LLVM does not
improve on it during optimization, so the 65-bit multiplication is
extended to 128-bit during legalization, resulting in the libcall on
most targets.

To avoid the initial situation that causes clang to generate the
problematic IR, cast size (which is an 'unsigned int') to the same
type/width as block (which is currently a 'u64'/'unsigned long long').
GCC appears to already do this internally because there is no binary
difference with the cast for arm, arm64, riscv, or x86_64.

Link: https://github.com/ClangBuiltLinux/linux/issues/1958
Link: https://github.com/llvm/llvm-project/issues/38013
Link: https://lkml.kernel.org/r/20231128-avoid-muloti4-grow_buffers-v1-1-bc3d0f0ec483@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Closes: https://lore.kernel.org/CA+G9fYuA_PTd7R2NsBvtNb7qjwp4avHpCmWi4=OmY4jndDcQYA@mail.gmail.com/
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/buffer.c~buffer-fix-grow_buffers-for-block-size-page_size-fix
+++ a/fs/buffer.c
@@ -1091,7 +1091,7 @@ static bool grow_buffers(struct block_de
 	 * Check for a block which lies outside our maximum possible
 	 * pagecache index.
 	 */
-	if (check_mul_overflow(block, size, &pos) || pos > MAX_LFS_FILESIZE) {
+	if (check_mul_overflow(block, (sector_t)size, &pos) || pos > MAX_LFS_FILESIZE) {
 		printk(KERN_ERR "%s: requested out-of-range block %llu for device %pg\n",
 			__func__, (unsigned long long)block,
 			bdev);
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

