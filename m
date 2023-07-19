Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFFEC001DC
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 19:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjGSTsc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjGSTsb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 15:48:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8C81BCF
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 12:48:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C83ED617FE
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 19:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDD1C433C8;
        Wed, 19 Jul 2023 19:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689796109;
        bh=/EYjlxsPtnYdrfSuUSyxnEvDZxCHYM5eGkVBjpXEQ70=;
        h=Date:To:From:Subject:From;
        b=r2AOGL0x1ndiSawO7BWAjieTpUqqHaBq//WmS3T9fMqNziExzbVRQRYyxkLQSl5eD
         XrKpn4sj2SRR3VQszpppTWe0J1Y8J95CbTtibJeG16uaoCTH0vSgCP6EU8ghVRqA9r
         yVzF+Q6cNSerpZZ+shcZltDsHvjV9UhkfRBTlv7U=
Date:   Wed, 19 Jul 2023 12:48:28 -0700
To:     mm-commits@vger.kernel.org, brauner@kernel.org,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-hfsplus-make-extend-error-rate-limited.patch added to mm-nonmm-unstable branch
Message-Id: <20230719194829.1EDD1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: hfsplus: make extend error rate limited
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-hfsplus-make-extend-error-rate-limited.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-hfsplus-make-extend-error-rate-limited.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: fs: hfsplus: make extend error rate limited
Date: Wed, 19 Jul 2023 13:17:35 +0100

Extending a file where there is not enough free space can trigger frequent
extend alloc file error messages and this can easily spam the kernel log. 
Make the error message rate limited.

Link: https://lkml.kernel.org/r/20230719121735.2831164-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/hfsplus/extents.c~fs-hfsplus-make-extend-error-rate-limited
+++ a/fs/hfsplus/extents.c
@@ -448,9 +448,9 @@ int hfsplus_file_extend(struct inode *in
 	if (sbi->alloc_file->i_size * 8 <
 	    sbi->total_blocks - sbi->free_blocks + 8) {
 		/* extend alloc file */
-		pr_err("extend alloc file! (%llu,%u,%u)\n",
-		       sbi->alloc_file->i_size * 8,
-		       sbi->total_blocks, sbi->free_blocks);
+		pr_err_ratelimited("extend alloc file! (%llu,%u,%u)\n",
+				   sbi->alloc_file->i_size * 8,
+				   sbi->total_blocks, sbi->free_blocks);
 		return -ENOSPC;
 	}
 
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

fs-hfsplus-make-extend-error-rate-limited.patch

