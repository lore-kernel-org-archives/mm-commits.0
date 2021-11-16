Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A57C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5936128A
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345059AbhKPB3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 20:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355970AbhKPB1A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 20:27:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B50626128A;
        Tue, 16 Nov 2021 01:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637025843;
        bh=MdmYX8JIIh28O896RiUZXJDnp7T8KWugngNJlAR6FaQ=;
        h=Date:From:To:Subject:From;
        b=JW/TzCMQaREsWK4QbikvyqEYX7BIgvdPPBUwqIAqYhjX6RA8+mSjIuz21sHEb4J0I
         DAKyWot+OG9gGCIo2XSLobFkWS6L2VgPd8+626LEaxJe7QPJUHK42fTVgFE43BtMX/
         DyoGKTeOEY/sW/BbCJEuSk9WOFFPJsblWMYeulXs=
Date:   Mon, 15 Nov 2021 17:24:02 -0800
From:   akpm@linux-foundation.org
To:     cy.fan@huawei.com, cyan@fb.com, guoxuenan@huawei.com,
        hsiangkao@linux.alibaba.com, mm-commits@vger.kernel.org,
        terrelln@fb.com
Subject:  +
 lz4-fix-lz4_decompress_safe_partial-read-out-of-bound.patch added to -mm
 tree
Message-ID: <20211116012402.N1sXsgxfx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lz4: fix LZ4_decompress_safe_partial read out of bound
has been added to the -mm tree.  Its filename is
     lz4-fix-lz4_decompress_safe_partial-read-out-of-bound.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lz4-fix-lz4_decompress_safe_partial-read-out-of-bound.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lz4-fix-lz4_decompress_safe_partial-read-out-of-bound.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guo Xuenan <guoxuenan@huawei.com>
Subject: lz4: fix LZ4_decompress_safe_partial read out of bound

When partialDecoding, it is EOF if we've either, filled the output
buffer or can't proceed with reading an offset for following match.

In some extreme corner cases when compressed data is crusted corrupted,
UAF will occur. As reported by KASAN [1], LZ4_decompress_safe_partial
may lead to read out of bound problem during decoding. lz4 upstream has
fixed it [2] and this issue has been disscussed here [3] before.

current decompression routine was ported from lz4 v1.8.3, bumping lib/lz4
to v1.9.+ is certainly a huge work to be done later, so, we'd better fix
it first.

[1] https://lore.kernel.org/all/000000000000830d1205cf7f0477@google.com/
[2] https://github.com/lz4/lz4/commit/c5d6f8a8be3927c0bec91bcc58667a6cfad244ad#
[3] https://lore.kernel.org/all/CC666AE8-4CA4-4951-B6FB-A2EFDE3AC03B@fb.com/

Link: https://lkml.kernel.org/r/20211111105048.2006070-1-guoxuenan@huawei.com
Reported-by: syzbot+63d688f1d899c588fb71@syzkaller.appspotmail.com
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Yann Collet <cyan@fb.com>
Cc: Chengyang Fan <cy.fan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/lz4/lz4_decompress.c~lz4-fix-lz4_decompress_safe_partial-read-out-of-bound
+++ a/lib/lz4/lz4_decompress.c
@@ -271,8 +271,12 @@ static FORCE_INLINE int LZ4_decompress_g
 			ip += length;
 			op += length;
 
-			/* Necessarily EOF, due to parsing restrictions */
-			if (!partialDecoding || (cpy == oend))
+			/* Necessarily EOF when !partialDecoding.
+			 * When partialDecoding, it is EOF if we've either
+			 * filled the output buffer or
+			 * can't proceed with reading an offset for following match.
+			 */
+			if (!partialDecoding || (cpy == oend) || (ip >= (iend - 2)))
 				break;
 		} else {
 			/* may overwrite up to WILDCOPYLENGTH beyond cpy */
_

Patches currently in -mm which might be from guoxuenan@huawei.com are

lz4-fix-lz4_decompress_safe_partial-read-out-of-bound.patch

