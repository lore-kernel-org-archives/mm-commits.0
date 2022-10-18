Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C158C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiJRBNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiJRBNS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:13:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA45B120A5
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:13:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19A4761326
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D884C433C1;
        Tue, 18 Oct 2022 01:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055596;
        bh=wraLunVESvHaiToWm3BAth/JTOHPZ45fjUuwQHi4pCQ=;
        h=Date:To:From:Subject:From;
        b=e0EtslPxXLiDtS48SFvrClwocHLrMrVbjs2zgmhxYNZigzv28HlcRzkDUKG4iasvF
         nYV95Ir9DtkJzHQAyl1th9v3yjn7BC6L2IOPNRYkjSXoK1+ol/90hvX3FzGFStdxRL
         XUR3x8AaJfi2NDym6SvDp+MDUekW/olMHnzCiymA=
Date:   Mon, 17 Oct 2022 18:13:15 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        andriy.shevchenko@linux.intel.com, Jason@zx2c4.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch added to mm-nonmm-unstable branch
Message-Id: <20221018011316.6D884C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax: clamp more efficiently by avoiding extra comparison
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: minmax: clamp more efficiently by avoiding extra comparison
Date: Mon, 26 Sep 2022 15:34:35 +0200

Currently the clamp algorithm does:

    if (val > hi)
        val = hi;
    if (val < lo)
        val = lo;

But since hi > lo by definition, this can be made more efficient with:

    if (val > hi)
        val = hi;
    else if (val < lo)
        val = lo;

So fix up the clamp and clamp_t functions to do this, adding the same
argument checking as for min and min_t.

For simple cases, code generation on x86_64 and aarch64 stay about the
same:

    before:
            cmp     edi, edx
            mov     eax, esi
            cmova   edi, edx
            cmp     edi, esi
            cmovnb  eax, edi
            ret
    after:
            cmp     edi, esi
            mov     eax, edx
            cmovnb  esi, edi
            cmp     edi, edx
            cmovb   eax, esi
            ret

    before:
            cmp     w0, w2
            csel    w8, w0, w2, lo
            cmp     w8, w1
            csel    w0, w8, w1, hi
            ret
    after:
            cmp     w0, w1
            csel    w8, w0, w1, hi
            cmp     w0, w2
            csel    w0, w8, w2, lo
            ret

On MIPS64, however, code generation improves, by removing arithmetic in
the second branch:

    before:
            sltu    $3,$6,$4
            bne     $3,$0,.L2
            move    $2,$6

            move    $2,$4
    .L2:
            sltu    $3,$2,$5
            bnel    $3,$0,.L7
            move    $2,$5

    .L7:
            jr      $31
            nop
    after:
            sltu    $3,$4,$6
            beq     $3,$0,.L13
            move    $2,$6

            sltu    $3,$4,$5
            bne     $3,$0,.L12
            move    $2,$4

    .L13:
            jr      $31
            nop

    .L12:
            jr      $31
            move    $2,$5

For more complex cases with surrounding code, the effects are a bit
more complicated. For example, consider this simplified version of
timestamp_truncate() from fs/inode.c on x86_64:

    struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode)
    {
        struct super_block *sb = inode->i_sb;
        unsigned int gran = sb->s_time_gran;

        t.tv_sec = clamp(t.tv_sec, sb->s_time_min, sb->s_time_max);
        if (t.tv_sec == sb->s_time_max || t.tv_sec == sb->s_time_min)
            t.tv_nsec = 0;
        return t;
    }

    before:
            mov     r8, rdx
            mov     rdx, rsi
            mov     rcx, QWORD PTR [r8]
            mov     rax, QWORD PTR [rcx+8]
            mov     rcx, QWORD PTR [rcx+16]
            cmp     rax, rdi
            mov     r8, rcx
            cmovge  rdi, rax
            cmp     rdi, rcx
            cmovle  r8, rdi
            cmp     rax, r8
            je      .L4
            cmp     rdi, rcx
            jge     .L4
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            mov     rax, r8
            ret

    after:
            mov     rax, QWORD PTR [rdx]
            mov     rdx, QWORD PTR [rax+8]
            mov     rax, QWORD PTR [rax+16]
            cmp     rax, rdi
            jg      .L6
            mov     r8, rax
            xor     edx, edx
    .L2:
            mov     rax, r8
            ret
    .L6:
            cmp     rdx, rdi
            mov     r8, rdi
            cmovge  r8, rdx
            cmp     rax, r8
            je      .L4
            xor     eax, eax
            cmp     rdx, rdi
            cmovl   rax, rsi
            mov     rdx, rax
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            jmp     .L2

In this case, we actually gain a branch, unfortunately, because the
compiler's replacement axioms no longer as cleanly apply.

So all and all, this change is a bit of a mixed bag.

Link: https://lkml.kernel.org/r/20220926133435.1333846-2-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/minmax.h~minmax-clamp-more-efficiently-by-avoiding-extra-comparison
+++ a/include/linux/minmax.h
@@ -38,7 +38,7 @@
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
 #define __clamp(val, lo, hi)							\
-	__cmp(__cmp(val, lo, >), hi, <)
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
 #define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
 		typeof(val) unique_val = (val);					\
_

Patches currently in -mm which might be from Jason@zx2c4.com are

minmax-sanity-check-constant-bounds-when-clamping.patch
minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch

