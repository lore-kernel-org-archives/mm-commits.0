Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F8B12E72
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vdYK7LBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6863BC433C8;
	Fri, 29 Dec 2023 19:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879181;
	bh=X6a2eshC++982YnUkjcARNltulurSIVnLRPjSjYPcoE=;
	h=Date:To:From:Subject:From;
	b=vdYK7LBWeuxKsOiUrScMMNBC4hppjmwEp4tZa+XxR1eCrl1oNFyT2ShshDq41DqWn
	 vb7TQevx1eJ/AXYa8uhBT5XkNp/yXC5QYTpYV8Ndk3nYqh7mt96FI/tfyNlEWHqGkC
	 WvEVnESSd8gUO8xk6765QuhGJKedeqJceo9fLsgo=
Date: Fri, 29 Dec 2023 11:46:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,naresh.kamboju@linaro.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] buffer-fix-grow_buffers-for-block-size-page_size-fix.patch removed from -mm tree
Message-Id: <20231229194621.6863BC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: add cast in grow_buffers() to avoid a multiplication libcall
has been removed from the -mm tree.  Its filename was
     buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

This patch was dropped because it was folded into buffer-fix-grow_buffers-for-block-size-page_size.patch

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

buffer-fix-grow_buffers-for-block-size-page_size.patch
kasan-save-alloc-stack-traces-for-mempool-fix.patch

