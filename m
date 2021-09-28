Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C767C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED8D2611F2
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbhI1AcJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238236AbhI1AcJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 20:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEECA60F4F;
        Tue, 28 Sep 2021 00:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632789030;
        bh=bnJssLlr1fnmLRBb1+gpjfAq1F4XysPmWiQlEoPoqxg=;
        h=Date:From:To:Subject:From;
        b=XXsIEcIS+KMmjy2r0h1VRvY6ymv2xrTJXRGgIe9fNaVoSXTYrjazlvJogSIdVhSaU
         5wKzNDnGssP+u1c04B1suCKJ0glCy3wJMcKewcprvaf5O8kvUs8lB8q1oplsm6Ar3v
         GJIr+Lq1lNzoYkBmPPoJu4CvRq6U3TCSWMXhPdFc=
Date:   Mon, 27 Sep 2021 17:30:30 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, paskripkin@gmail.com
Subject:  + sysv-use-build_bug_on-instead-of-runtime-check.patch
 added to -mm tree
Message-ID: <20210928003030.O5XJjnLwk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysv: use BUILD_BUG_ON instead of runtime check
has been added to the -mm tree.  Its filename is
     sysv-use-build_bug_on-instead-of-runtime-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysv-use-build_bug_on-instead-of-runtime-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysv-use-build_bug_on-instead-of-runtime-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Skripkin <paskripkin@gmail.com>
Subject: sysv: use BUILD_BUG_ON instead of runtime check

There were runtime checks about sizes of struct v7_super_block and struct
sysv_inode.  If one of these checks fail the kernel will panic.  Since
these values are known at compile time let's use BUILD_BUG_ON(), because
it's a standard mechanism for validation checking at build time

Link: https://lkml.kernel.org/r/20210813123020.22971-1-paskripkin@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/super.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/sysv/super.c~sysv-use-build_bug_on-instead-of-runtime-check
+++ a/fs/sysv/super.c
@@ -474,10 +474,8 @@ static int v7_fill_super(struct super_bl
 	struct sysv_sb_info *sbi;
 	struct buffer_head *bh;
 
-	if (440 != sizeof (struct v7_super_block))
-		panic("V7 FS: bad super-block size");
-	if (64 != sizeof (struct sysv_inode))
-		panic("sysv fs: bad i-node size");
+	BUILD_BUG_ON(sizeof(struct v7_super_block) != 440);
+	BUILD_BUG_ON(sizeof(struct sysv_inode) != 64);
 
 	sbi = kzalloc(sizeof(struct sysv_sb_info), GFP_KERNEL);
 	if (!sbi)
_

Patches currently in -mm which might be from paskripkin@gmail.com are

sysv-use-build_bug_on-instead-of-runtime-check.patch

